param(
    [switch]$KeepOpen,
    [switch]$UseWindowsMcpScreenshots,
    [int]$ClickWindowX = 976,
    [int]$ClickWindowY = 304
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Godot = Join-Path $Root "tools\godot\Godot_v4.6.3-stable_win64.exe"
$Project = Join-Path $Root "godot"
$ShotDir = Join-Path $Root "screenshots"
$Before = Join-Path $ShotDir "desktop-ui-before.png"
$After = Join-Path $ShotDir "desktop-ui-after.png"
$StateFile = Join-Path $ShotDir "desktop-ui-state.json"
$McpCall = Join-Path $Root "tools\windows-mcp-call.mjs"
$Node = "D:\devtools\node\node.exe"

if (!(Test-Path $Godot)) {
    throw "Godot executable missing: $Godot"
}
if (!(Test-Path (Join-Path $Project "project.godot"))) {
    throw "Godot project missing: $Project"
}
if (!(Test-Path $McpCall)) {
    throw "Windows-MCP helper missing: $McpCall"
}
if (!(Test-Path $Node)) {
    $Node = (Get-Command node -ErrorAction Stop).Source
}

New-Item -ItemType Directory -Force -Path $ShotDir | Out-Null
Remove-Item -LiteralPath $Before, $After, $StateFile -Force -ErrorAction SilentlyContinue

Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class AgentTownWin32 {
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool MoveWindow(IntPtr hWnd, int x, int y, int width, int height, bool repaint);

    [DllImport("user32.dll")]
    public static extern bool GetClientRect(IntPtr hWnd, out RECT rect);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect);

    [DllImport("user32.dll")]
    public static extern bool ClientToScreen(IntPtr hWnd, ref POINT point);

    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int x, int y);

    [DllImport("user32.dll")]
    public static extern void mouse_event(uint flags, uint dx, uint dy, uint data, UIntPtr extraInfo);

    public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const uint MOUSEEVENTF_LEFTUP = 0x0004;
}
"@

function Get-ProjectProcessIds {
    $escaped = $Project.Replace("\", "\\")
    Get-CimInstance Win32_Process |
        Where-Object {
            $_.Name -like "Godot*" -and
            ($_.CommandLine -like "*$Project*" -or $_.CommandLine -like "*$escaped*")
        } |
        Select-Object -ExpandProperty ProcessId
}

function Wait-ForGodotWindow {
    param([System.Diagnostics.Process]$Process, [int]$TimeoutSec = 30)

    $deadline = (Get-Date).AddSeconds($TimeoutSec)
    while ((Get-Date) -lt $deadline) {
        $Process.Refresh()
        if ($Process.HasExited) {
            throw "Godot exited before a game window appeared."
        }

        $candidateIds = @($Process.Id) + @(Get-ProjectProcessIds)
        foreach ($id in ($candidateIds | Select-Object -Unique)) {
            $p = Get-Process -Id $id -ErrorAction SilentlyContinue
            if ($p -and $p.MainWindowHandle -ne 0) {
                return $p
            }
        }
        Start-Sleep -Milliseconds 250
    }

    throw "Timed out waiting for the Agent Town Godot window."
}

function Wait-ForState {
    param([string]$ExpectedEvent, [int]$TimeoutSec = 20)

    $deadline = (Get-Date).AddSeconds($TimeoutSec)
    while ((Get-Date) -lt $deadline) {
        if (Test-Path $StateFile) {
            $state = Get-Content -LiteralPath $StateFile -Raw | ConvertFrom-Json
            if ($state.event -eq $ExpectedEvent) {
                return $state
            }
        }
        Start-Sleep -Milliseconds 250
    }

    throw "Timed out waiting for desktop UI state event: $ExpectedEvent"
}

function Get-ClientOrigin {
    param([IntPtr]$Hwnd)

    $point = New-Object AgentTownWin32+POINT
    $point.X = 0
    $point.Y = 0
    [AgentTownWin32]::ClientToScreen($Hwnd, [ref]$point) | Out-Null
    return $point
}

function Capture-Client {
    param([IntPtr]$Hwnd, [string]$Path)

    $rect = New-Object AgentTownWin32+RECT
    [AgentTownWin32]::GetClientRect($Hwnd, [ref]$rect) | Out-Null
    $width = $rect.Right - $rect.Left
    $height = $rect.Bottom - $rect.Top
    if ($width -lt 100 -or $height -lt 100) {
        throw "Godot client area is unexpectedly small: ${width}x${height}"
    }

    $origin = Get-ClientOrigin -Hwnd $Hwnd
    $bitmap = New-Object System.Drawing.Bitmap($width, $height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    try {
        $graphics.CopyFromScreen($origin.X, $origin.Y, 0, 0, $bitmap.Size)
        $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    }
    finally {
        $graphics.Dispose()
        $bitmap.Dispose()
    }
}

function Click-ClientPoint {
    param([IntPtr]$Hwnd, [int]$X, [int]$Y)

    $rect = New-Object AgentTownWin32+RECT
    [AgentTownWin32]::GetClientRect($Hwnd, [ref]$rect) | Out-Null
    if ($X -lt 0 -or $Y -lt 0 -or $X -ge $rect.Right -or $Y -ge $rect.Bottom) {
        throw "Refusing to click outside the Godot client area: $X,$Y"
    }

    $origin = Get-ClientOrigin -Hwnd $Hwnd
    $screenX = $origin.X + $X
    $screenY = $origin.Y + $Y
    [AgentTownWin32]::SetCursorPos($screenX, $screenY) | Out-Null
    Start-Sleep -Milliseconds 80
    [AgentTownWin32]::mouse_event([AgentTownWin32]::MOUSEEVENTF_LEFTDOWN, 0, 0, 0, [UIntPtr]::Zero)
    Start-Sleep -Milliseconds 80
    [AgentTownWin32]::mouse_event([AgentTownWin32]::MOUSEEVENTF_LEFTUP, 0, 0, 0, [UIntPtr]::Zero)
}

function Compare-ImageSamples {
    param([string]$PathA, [string]$PathB)

    $a = [System.Drawing.Bitmap]::FromFile($PathA)
    $b = [System.Drawing.Bitmap]::FromFile($PathB)
    try {
        $width = [Math]::Min($a.Width, $b.Width)
        $height = [Math]::Min($a.Height, $b.Height)
        $changed = 0
        $samples = 0
        for ($y = 0; $y -lt $height; $y += 12) {
            for ($x = 0; $x -lt $width; $x += 12) {
                $pa = $a.GetPixel($x, $y)
                $pb = $b.GetPixel($x, $y)
                $delta = [Math]::Abs($pa.R - $pb.R) + [Math]::Abs($pa.G - $pb.G) + [Math]::Abs($pa.B - $pb.B)
                if ($delta -gt 35) {
                    $changed++
                }
                $samples++
            }
        }
        return $changed / [double]$samples
    }
    finally {
        $a.Dispose()
        $b.Dispose()
    }
}

function Invoke-WindowsMcpTool {
    param(
        [string]$ToolName,
        [hashtable]$Arguments,
        [string]$ImageOut = ""
    )

    $jsonArgs = $Arguments | ConvertTo-Json -Compress
    $encodedArgs = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($jsonArgs))
    $args = @($McpCall, $ToolName, "base64:$encodedArgs")
    if ($ImageOut -ne "") {
        $args += @("--image-out", $ImageOut)
    }
    & $Node @args
    if ($LASTEXITCODE -ne 0) {
        throw "Windows-MCP tool failed: $ToolName"
    }
}

$env:AGENT_TOWN_DESKTOP_TEST = "1"
$godotProcess = $null
$windowProcess = $null
try {
    Write-Host "[desktop-ui] Launching Godot desktop test mode"
    $godotProcess = Start-Process -FilePath $Godot -ArgumentList @("--path", $Project) -PassThru -WindowStyle Normal
    Remove-Item Env:\AGENT_TOWN_DESKTOP_TEST -ErrorAction SilentlyContinue

    $windowProcess = Wait-ForGodotWindow -Process $godotProcess
    $hwnd = $windowProcess.MainWindowHandle
    [AgentTownWin32]::ShowWindow($hwnd, 9) | Out-Null
    [AgentTownWin32]::MoveWindow($hwnd, 80, 80, 1280, 760, $true) | Out-Null
    [AgentTownWin32]::SetForegroundWindow($hwnd) | Out-Null

    $ready = Wait-ForState -ExpectedEvent "ready"
    Write-Host "[desktop-ui] Ready in room: $($ready.room_id)"
    Start-Sleep -Milliseconds 500

    if ($UseWindowsMcpScreenshots) {
        Invoke-WindowsMcpTool -ToolName "Screenshot" -Arguments @{ use_annotation = $false } -ImageOut $Before
    }
    else {
        Capture-Client -Hwnd $hwnd -Path $Before
    }
    Write-Host "[desktop-ui] Before screenshot: $Before"

    $windowRect = New-Object AgentTownWin32+RECT
    [AgentTownWin32]::GetWindowRect($hwnd, [ref]$windowRect) | Out-Null
    $windowWidth = $windowRect.Right - $windowRect.Left
    $windowHeight = $windowRect.Bottom - $windowRect.Top
    if ($ClickWindowX -lt 0 -or $ClickWindowY -lt 0 -or $ClickWindowX -ge $windowWidth -or $ClickWindowY -ge $windowHeight) {
        throw "Refusing to click outside the Godot window: $ClickWindowX,$ClickWindowY"
    }
    $screenX = $windowRect.Left + $ClickWindowX
    $screenY = $windowRect.Top + $ClickWindowY
    Invoke-WindowsMcpTool -ToolName "Click" -Arguments @{ loc = @($screenX, $screenY); button = "left"; clicks = 2 }
    $clicked = Wait-ForState -ExpectedEvent "desktop_click_received"
    Write-Host "[desktop-ui] Click state: $($clicked.event)"
    Start-Sleep -Milliseconds 500

    if ($UseWindowsMcpScreenshots) {
        Invoke-WindowsMcpTool -ToolName "Screenshot" -Arguments @{ use_annotation = $false } -ImageOut $After
    }
    else {
        Capture-Client -Hwnd $hwnd -Path $After
    }
    Write-Host "[desktop-ui] After screenshot: $After"

    $ratio = Compare-ImageSamples -PathA $Before -PathB $After
    if ($ratio -lt 0.001) {
        throw "Screenshots changed too little after the click: ratio=$ratio"
    }

    Write-Host ("[desktop-ui] OK visual change ratio={0:P2}" -f $ratio)
}
finally {
    Remove-Item Env:\AGENT_TOWN_DESKTOP_TEST -ErrorAction SilentlyContinue
    if (!$KeepOpen) {
        if ($windowProcess -and !$windowProcess.HasExited) {
            $windowProcess.CloseMainWindow() | Out-Null
            Start-Sleep -Milliseconds 800
            if (!$windowProcess.HasExited) {
                Stop-Process -Id $windowProcess.Id -Force -ErrorAction SilentlyContinue
            }
        }
        if ($godotProcess -and !$godotProcess.HasExited -and (!$windowProcess -or $godotProcess.Id -ne $windowProcess.Id)) {
            Stop-Process -Id $godotProcess.Id -Force -ErrorAction SilentlyContinue
        }
    }
}
