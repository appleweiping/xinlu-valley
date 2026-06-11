param(
    [string[]]$RoomIds = @(),
    [switch]$Quick,
    [string]$ManifestName = "room-scenes-manifest.json"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Godot = Join-Path $Root "tools\godot\Godot_v4.6.3-stable_win64_console.exe"
$ShotDir = Join-Path $Root "screenshots"
$RoomRegistryPath = Join-Path $Root "godot\data\room_scenes.json"

function ConvertTo-RoomShotName {
    param([string]$RoomId)
    $safe = $RoomId -replace "[^A-Za-z0-9_-]", "-"
    return "room-$safe.png"
}

if (!(Test-Path $Godot)) {
    throw "Godot executable missing: $Godot"
}
if (!(Test-Path $RoomRegistryPath)) {
    throw "Room scene registry missing: $RoomRegistryPath"
}

New-Item -ItemType Directory -Force -Path $ShotDir | Out-Null

$RegistryRooms = Get-Content -LiteralPath $RoomRegistryPath -Raw | ConvertFrom-Json
$SelectedIds = @()
if ($RoomIds.Count -gt 0) {
    $SelectedIds = $RoomIds
}
elseif ($Quick) {
    $SelectedIds = @("file-vault", "research-hall", "code-workshop", "agent-hub", "testing-arena")
}
else {
    $SelectedIds = @($RegistryRooms | ForEach-Object { $_.id })
}

$Rooms = @()
foreach ($id in $SelectedIds) {
    $room = $RegistryRooms | Where-Object { $_.id -eq $id } | Select-Object -First 1
    if ($null -eq $room) {
        throw "Room id is not present in room scene registry: $id"
    }
    $Rooms += [ordered]@{
        Id = [string]$room.id
        Title = [string]$room.title
        Output = ConvertTo-RoomShotName -RoomId ([string]$room.id)
    }
}

$Manifest = [ordered]@{
    generated_at = (Get-Date).ToString("s")
    mode = $(if ($Quick) { "quick" } elseif ($RoomIds.Count -gt 0) { "selected" } else { "all-room-scenes" })
    registry = "godot/data/room_scenes.json"
    room_count = $Rooms.Count
    min_size_bytes = 10000
    screenshots = @()
}

foreach ($room in $Rooms) {
    $output = Join-Path $ShotDir $room.Output
    Write-Host "[room-visuals] Capturing $($room.Id) -> $output"
    if (Test-Path $output) {
        Remove-Item -LiteralPath $output -Force
    }
    $env:AGENT_TOWN_CAPTURE = "1"
    $env:AGENT_TOWN_CAPTURE_ROOM = $room.Id
    $env:AGENT_TOWN_CAPTURE_OUTPUT = $room.Output
    try {
        & $Godot --path (Join-Path $Root "godot") --quit-after 10
        if ($LASTEXITCODE -ne 0) {
            throw "Godot capture failed for $($room.Id) with exit code $LASTEXITCODE"
        }
    }
    finally {
        Remove-Item Env:\AGENT_TOWN_CAPTURE -ErrorAction SilentlyContinue
        Remove-Item Env:\AGENT_TOWN_CAPTURE_ROOM -ErrorAction SilentlyContinue
        Remove-Item Env:\AGENT_TOWN_CAPTURE_OUTPUT -ErrorAction SilentlyContinue
    }
    if (!(Test-Path $output)) {
        throw "Room visual screenshot was not created: $output"
    }
    $size = (Get-Item $output).Length
    if ($size -lt 10000) {
        throw "Room visual screenshot is suspiciously small: $output ($size bytes)"
    }
    $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $output).Hash.ToLowerInvariant()
    $Manifest.screenshots += [ordered]@{
        room_id = $room.Id
        title = $room.Title
        file = "screenshots/$($room.Output)"
        bytes = $size
        sha256 = $hash
    }
    Write-Host "[room-visuals] OK $($room.Id) ($size bytes)"
}

$manifestPath = Join-Path $ShotDir $ManifestName
$Manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $manifestPath -Encoding UTF8
Write-Host "[room-visuals] Manifest: $manifestPath"
Write-Host "[room-visuals] OK captured $($Rooms.Count) room screenshots"
