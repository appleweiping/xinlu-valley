param(
    [switch]$RunExport,
    [switch]$Overwrite,
    [string]$Preset = "Windows Desktop",
    [string]$OutputPath = "",
    [string]$ReportName = "latest-godot-export-report.json"
)

$ErrorActionPreference = "Stop"
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -ErrorAction SilentlyContinue) {
    $PSNativeCommandUseErrorActionPreference = $false
}

$Root = Split-Path -Parent $PSScriptRoot
$Godot = Join-Path $Root "tools\godot\Godot_v4.6.3-stable_win64_console.exe"
$ProjectDir = Join-Path $Root "godot"
$ExportPresets = Join-Path $ProjectDir "export_presets.cfg"
$DistDir = Join-Path $Root "dist\ai-town"
$ReportsDir = Join-Path $Root "workspace\export-reports"
$ProjectTemplateDir = Join-Path $Root "tools\godot\templates\4.6.3.stable\templates"
if ([string]::IsNullOrWhiteSpace($OutputPath)) {
    $OutputPath = Join-Path $DistDir "AI Town.exe"
}
$OutputPath = [System.IO.Path]::GetFullPath($OutputPath)
$OutputParent = Split-Path -Parent $OutputPath

New-Item -ItemType Directory -Force -Path $ReportsDir | Out-Null
$templateRoot = Join-Path $env:APPDATA "Godot\export_templates"
$templateMatches = @()
if (Test-Path -LiteralPath $templateRoot) {
    $templateMatches = Get-ChildItem -LiteralPath $templateRoot -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like "4.6.3*" } |
        Select-Object -ExpandProperty FullName
}
$projectReleaseTemplate = Join-Path $ProjectTemplateDir "windows_release_x86_64.exe"
$projectDebugTemplate = Join-Path $ProjectTemplateDir "windows_debug_x86_64.exe"

$exportText = ""
if (Test-Path -LiteralPath $ExportPresets) {
    $exportText = Get-Content -LiteralPath $ExportPresets -Raw
}

$checks = @(
    [ordered]@{ id = "godot-console"; label = "Pinned Godot console binary exists"; ok = (Test-Path -LiteralPath $Godot); detail = $Godot },
    [ordered]@{ id = "project-dir"; label = "Godot project directory exists"; ok = (Test-Path -LiteralPath $ProjectDir); detail = $ProjectDir },
    [ordered]@{ id = "export-presets"; label = "Export presets file exists"; ok = (Test-Path -LiteralPath $ExportPresets); detail = $ExportPresets },
    [ordered]@{ id = "preset-name"; label = "Requested preset is configured"; ok = ($exportText -match ('name="' + [regex]::Escape($Preset) + '"')); detail = $Preset },
    [ordered]@{ id = "project-release-template"; label = "Project-local Windows release template exists"; ok = (Test-Path -LiteralPath $projectReleaseTemplate); detail = $projectReleaseTemplate },
    [ordered]@{ id = "project-debug-template"; label = "Project-local Windows debug template exists"; ok = (Test-Path -LiteralPath $projectDebugTemplate); detail = $projectDebugTemplate },
    [ordered]@{ id = "dist-dir"; label = "Distribution directory exists"; ok = (Test-Path -LiteralPath $DistDir); detail = $DistDir },
    [ordered]@{ id = "output-parent"; label = "Output parent directory exists"; ok = (Test-Path -LiteralPath $OutputParent); detail = $OutputParent },
    [ordered]@{ id = "overwrite-policy"; label = "Existing export will not be overwritten accidentally"; ok = ((-not (Test-Path -LiteralPath $OutputPath)) -or $Overwrite); detail = $OutputPath }
)
$blockers = @($checks | Where-Object { -not $_.ok })
$command = @($Godot, "--headless", "--path", $ProjectDir, "--export-release", $Preset, $OutputPath)
$startedAt = (Get-Date).ToString("o")
$stdout = @()
$exitCode = $null
$status = if ($blockers.Count -eq 0) { "preflight-ok" } else { "blocked" }

if ($RunExport -and $blockers.Count -eq 0) {
    Write-Host "[export] Godot release export -> $OutputPath"
    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $stdout = & $Godot --headless --path $ProjectDir --export-release $Preset $OutputPath 2>&1
        $exitCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previousErrorAction
    }
    $stdout = @($stdout | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            $_.Exception.Message
        } else {
            [string]$_
        }
    })
    $status = if ($exitCode -eq 0 -and (Test-Path -LiteralPath $OutputPath)) { "exported" } else { "failed" }
} elseif ($RunExport) {
    Write-Host "[export] Blocked before running Godot export."
} else {
    Write-Host "[export] Preflight only. Pass -RunExport to create the executable."
}

$finishedAt = (Get-Date).ToString("o")
$outputExists = Test-Path -LiteralPath $OutputPath
$report = [ordered]@{
    mode = "godot-export-preflight-or-run"
    status = $status
    run_export = [bool]$RunExport
    overwrite = [bool]$Overwrite
    preset = $Preset
    project_dir = $ProjectDir
    output_path = $OutputPath
    output_exists = $outputExists
    output_bytes = if ($outputExists) { (Get-Item -LiteralPath $OutputPath).Length } else { 0 }
    checks = $checks
    blocker_count = $blockers.Count
    blockers = $blockers
    template_root = $templateRoot
    template_matches = $templateMatches
    project_template_dir = $ProjectTemplateDir
    project_release_template = $projectReleaseTemplate
    project_debug_template = $projectDebugTemplate
    command_preview = $command
    exit_code = $exitCode
    stdout_tail = @($stdout | Select-Object -Last 80)
    started_at = $startedAt
    finished_at = $finishedAt
    safe_note = "Default mode is preflight only. -RunExport creates/updates the configured local executable; -Overwrite is required before replacing an existing target. If templates are missing, run tools/install-godot-templates.ps1 to install them under the project on D:. The script does not start backend services, kill processes, change Git state, publish releases, or call GitHub."
}

$reportPath = Join-Path $ReportsDir $ReportName
$report | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8
Write-Host "[export] status=$status blockers=$($blockers.Count) report=$reportPath"
if ($RunExport -and $status -ne "exported") {
    exit 1
}
