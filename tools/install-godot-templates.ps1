param(
    [string]$Version = "4.6.3-stable",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$GodotTools = Join-Path $Root "tools\godot"
$Archive = Join-Path $GodotTools "Godot_v$Version`_export_templates.tpz"
$TemplateDir = Join-Path $GodotTools "templates\4.6.3.stable\templates"
$Url = "https://godot-releases.nbg1.your-objectstorage.com/$Version/Godot_v$Version`_export_templates.tpz"

New-Item -ItemType Directory -Force -Path $GodotTools | Out-Null
New-Item -ItemType Directory -Force -Path $TemplateDir | Out-Null

$releaseTemplate = Join-Path $TemplateDir "windows_release_x86_64.exe"
$debugTemplate = Join-Path $TemplateDir "windows_debug_x86_64.exe"
if ((Test-Path -LiteralPath $releaseTemplate) -and (Test-Path -LiteralPath $debugTemplate) -and (-not $Force)) {
    Write-Host "[templates] Windows templates already present: $TemplateDir"
    exit 0
}

if ((-not (Test-Path -LiteralPath $Archive)) -or $Force) {
    Write-Host "[templates] Downloading $Url"
    curl.exe -L --fail --retry 3 --output $Archive $Url
}

Write-Host "[templates] Extracting Windows x86_64 templates"
tar -xf $Archive -C (Split-Path -Parent $TemplateDir) `
    templates/version.txt `
    templates/windows_debug_x86_64.exe `
    templates/windows_release_x86_64.exe `
    templates/windows_debug_x86_64_console.exe `
    templates/windows_release_x86_64_console.exe

if (!(Test-Path -LiteralPath $releaseTemplate) -or !(Test-Path -LiteralPath $debugTemplate)) {
    throw "Windows export templates were not extracted correctly."
}

Write-Host "[templates] OK: $TemplateDir"
