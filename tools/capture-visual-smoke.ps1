$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Godot = Join-Path $Root "tools\godot\Godot_v4.6.3-stable_win64_console.exe"
$Output = Join-Path $Root "screenshots\visual-smoke.png"

if (!(Test-Path $Godot)) {
    throw "Godot executable missing: $Godot"
}

Write-Host "[visual-smoke] Capturing Godot screenshot"
$env:AGENT_TOWN_CAPTURE = "1"
try {
    & $Godot --path (Join-Path $Root "godot") --quit-after 10
}
finally {
    Remove-Item Env:\AGENT_TOWN_CAPTURE -ErrorAction SilentlyContinue
}

if (!(Test-Path $Output)) {
    throw "Visual smoke screenshot was not created: $Output"
}

$size = (Get-Item $Output).Length
if ($size -lt 10000) {
    throw "Visual smoke screenshot is suspiciously small: $size bytes"
}

Write-Host "[visual-smoke] OK $Output ($size bytes)"
