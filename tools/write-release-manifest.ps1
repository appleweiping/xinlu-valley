param(
    [string]$ManifestName = "release-manifest.json"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$DistDir = Join-Path $Root "dist\ai-town"
$ReportsDir = Join-Path $Root "workspace\release-package"
$ExportReport = Join-Path $Root "workspace\export-reports\latest-godot-export-report.json"
$Launcher = Join-Path $Root "start-packaged.cmd"
$SmokeScript = Join-Path $Root "tools\verify-smoke.ps1"

New-Item -ItemType Directory -Force -Path $ReportsDir | Out-Null

function Get-FileEntry {
    param(
        [string]$LiteralFile,
        [string]$Role,
        [bool]$Required = $true
    )
    $exists = Test-Path -LiteralPath $LiteralFile
    $entry = [ordered]@{
        role = $Role
        path = $LiteralFile
        exists = $exists
        required = $Required
        bytes = 0
        sha256 = ""
        updated_utc = ""
    }
    if ($exists) {
        $item = Get-Item -LiteralPath $LiteralFile
        $entry.bytes = $item.Length
        $entry.updated_utc = $item.LastWriteTimeUtc.ToString("o")
        if ($item.PSIsContainer -eq $false) {
            $entry.sha256 = (Get-FileHash -LiteralPath $LiteralFile -Algorithm SHA256).Hash.ToLowerInvariant()
        }
    }
    return $entry
}

$files = @()
$files += Get-FileEntry -LiteralFile (Join-Path $DistDir "AI Town.exe") -Role "exported-game-executable"
$files += Get-FileEntry -LiteralFile (Join-Path $DistDir "README.md") -Role "distribution-readme"
$files += Get-FileEntry -LiteralFile $Launcher -Role "packaged-launcher"
$files += Get-FileEntry -LiteralFile $ExportReport -Role "latest-export-report"
$files += Get-FileEntry -LiteralFile $SmokeScript -Role "smoke-verifier"

$missing = @($files | Where-Object { $_.required -and -not $_.exists })
$game = $files | Where-Object { $_.role -eq "exported-game-executable" } | Select-Object -First 1
$manifest = [ordered]@{
    mode = "local-release-package-manifest"
    status = if ($missing.Count -eq 0 -and $game.exists -and $game.bytes -gt 100000000) { "ok" } else { "needs-review" }
    generated_at = (Get-Date).ToString("o")
    project_root = $Root
    dist_dir = $DistDir
    file_count = $files.Count
    missing_required_count = $missing.Count
    files = $files
    safe_note = "This manifest hashes existing local release files only. It does not run exports, start services, open the game, copy files, zip artifacts, change Git state, or publish anything."
}

$manifestPath = Join-Path $ReportsDir $ManifestName
$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
Write-Host "[release-manifest] status=$($manifest.status) files=$($files.Count) missing=$($missing.Count) path=$manifestPath"
if ($manifest.status -ne "ok") {
    exit 1
}
