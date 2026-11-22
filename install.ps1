# Install, update or remove the project skills and commands on Windows.
# Run it from a clone of the repository:
#
#   powershell -ExecutionPolicy Bypass -File install.ps1 [-Link] [-Project DIR] [-Uninstall]
#
#   (no option)    Copy the skills and commands into %USERPROFILE%\.config\opencode,
#                  for every project. Run it again after "git pull" to update.
#   -Link          Link the skills and commands instead of copying them, so
#                  that "git pull" updates the installed ones too.
#   -Project DIR   Install into DIR\.opencode, for that project only.
#   -Uninstall     Remove the skills and commands. PROJECTS.md and Projects\ in
#                  your projects are left alone.
#
# If OPENCODE_CONFIG_DIR is set, it is used in place of %USERPROFILE%\.config\opencode.

param(
    [switch]$Link,
    [string]$Project,
    [switch]$Uninstall
)

$ErrorActionPreference = 'Stop'

$srcSkills = Join-Path $PSScriptRoot 'skills'
$srcCommands = Join-Path $PSScriptRoot 'commands'
if (-not (Test-Path -LiteralPath $srcSkills -PathType Container)) {
    throw "No skills directory beside this script."
}
if (-not (Test-Path -LiteralPath $srcCommands -PathType Container)) {
    throw "No commands directory beside this script."
}
$srcSkills = (Resolve-Path -LiteralPath $srcSkills).Path
$srcCommands = (Resolve-Path -LiteralPath $srcCommands).Path

if ($Project) {
    if (-not (Test-Path -LiteralPath $Project -PathType Container)) {
        throw "Not a directory: $Project"
    }
    $config = Join-Path (Resolve-Path -LiteralPath $Project).Path '.opencode'
} elseif ($env:OPENCODE_CONFIG_DIR) {
    $config = $env:OPENCODE_CONFIG_DIR
} else {
    $config = Join-Path $HOME '.config\opencode'
}
$destSkills = Join-Path $config 'skills'
$destCommands = Join-Path $config 'commands'

if (-not $Uninstall) {
    New-Item -ItemType Directory -Force -Path $destSkills | Out-Null
    New-Item -ItemType Directory -Force -Path $destCommands | Out-Null
    if ((Resolve-Path -LiteralPath $destSkills).Path -eq $srcSkills) {
        throw "$destSkills is this repository's own skills directory."
    }
    if ((Resolve-Path -LiteralPath $destCommands).Path -eq $srcCommands) {
        throw "$destCommands is this repository's own commands directory."
    }
}

# Remove one installed item: a link or junction is unlinked, never followed;
# a directory or file is deleted.
function Remove-ItemAt([string]$target) {
    $item = Get-Item -LiteralPath $target -Force -ErrorAction SilentlyContinue
    if (-not $item) { return $false }
    if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
        if ($item.PSIsContainer) {
            [IO.Directory]::Delete($target, $false)
        } else {
            [IO.File]::Delete($target)
        }
    } else {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
    return $true
}

$skills = 0
foreach ($dir in Get-ChildItem -LiteralPath $srcSkills -Directory) {
    if (-not (Test-Path -LiteralPath (Join-Path $dir.FullName 'SKILL.md'))) { continue }
    $target = Join-Path $destSkills $dir.Name
    if ($Uninstall) {
        if (-not (Remove-ItemAt $target)) { continue }
    } elseif ($Link) {
        Remove-ItemAt $target | Out-Null
        New-Item -ItemType Junction -Path $target -Target $dir.FullName | Out-Null
    } else {
        Remove-ItemAt $target | Out-Null
        Copy-Item -LiteralPath $dir.FullName -Destination $target -Recurse
    }
    $skills++
}

$commands = 0
foreach ($file in Get-ChildItem -LiteralPath $srcCommands -File -Filter '*.md') {
    $target = Join-Path $destCommands $file.Name
    if ($Uninstall) {
        if (-not (Remove-ItemAt $target)) { continue }
    } elseif ($Link) {
        Remove-ItemAt $target | Out-Null
        New-Item -ItemType SymbolicLink -Path $target -Target $file.FullName | Out-Null
    } else {
        Remove-ItemAt $target | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $target
    }
    $commands++
}

if ($Uninstall) {
    Write-Host "Removed $skills skills and $commands commands from $config"
} else {
    if ($Link) {
        Write-Host "Linked $skills skills and $commands commands in $config to $PSScriptRoot"
    } else {
        Write-Host "Copied $skills skills and $commands commands to $config"
    }
    Write-Host "Start a new OpenCode session; / lists the commands."
}