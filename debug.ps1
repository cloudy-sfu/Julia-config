<#
.SYNOPSIS
Build & run a Julia project.
.DESCRIPTION
To run a Julia script or open a Julia interactive dialog, run activate_run.ps1 followed by arguments.
Behaviors:
1. The files Manifest.toml and Project.toml will be automatically generated in base_dir.
2. It will use the provided julia_path, or search Julia instances in $env:LOCALAPPDATA\Programs.
   If not found, it asks the user to manually input the absolute path.
3. If multiple Julia are installed in the default folder, the latest version will be used.
4. Any extra arguments after the script name are forwarded to the Julia script via ARGS.
.PARAMETER Script
The relative path of any Julia script in the Julia project. Default: enter interactive Julia REPL.
.PARAMETER ProjectDir
(Non-positional) The root folder of Julia project. Default: the current folder.
.PARAMETER JuliaPath
(Non-positional) The absolute path to julia.exe executable. Default: auto-detects in LOCALAPPDATA.
.PARAMETER ScriptArgs
Remaining arguments forwarded to the Julia script (accessible via ARGS in Julia).
.EXAMPLE
.\activate_run.ps1 src\main.jl -- arg1 arg2 --myopt value
.\activate_run.ps1 src\main.jl arg1 arg2
.\activate_run.ps1 -ProjectDir C:\MyProject -JuliaPath C:\Julia\bin\julia.exe src\main.jl arg1
#>

[CmdletBinding(PositionalBinding=$false)]
param(
    [Parameter(Mandatory=$false, Position=0, 
    HelpMessage="The relative path of any Julia script in the Julia project.")] [string]$Script,
    [Parameter(Mandatory=$false, HelpMessage="The root folder of Julia project.")] [string]$ProjectDir,
    [Parameter(Mandatory=$false, HelpMessage="The absolute path to julia.exe executable.")] [string]$JuliaPath,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]]$ScriptArgs
)

# 1. Determine base directory: use provided path or default to current directory.
if (-not $ProjectDir) {
    $ProjectDir = (Get-Location).Path   # default: current working directory
} else {
    # Expand relative base path to absolute
    $ProjectDir = (Resolve-Path -Path $ProjectDir).Path
}

# 2. Find Julia path
# If not provided by the argument, search in the default LocalAppData directory
if (-not $JuliaPath -or -not (Test-Path $JuliaPath -PathType Leaf)) {
    $JuliaPath = Get-ChildItem -Directory -Path "$env:LOCALAPPDATA\Programs" -Filter "Julia-*" 2>$null |
        Sort-Object { [version]($_.Name -replace '^Julia-','') } -Descending |
        Select-Object -First 1 |
        ForEach-Object { Join-Path $_.FullName "bin\julia.exe" }
}

# If Julia is still not found, abort with an error.
if (-not (Test-Path $JuliaPath -PathType Leaf)) {
    Write-Error "Julia parameter not provided, fallback to $JuliaPath, but still invalid."
    exit 1
}

# 3. Convert base directory path to Unix-style for Julia (replace '\' with '/')
$base_dir_unix = ($ProjectDir -replace '\\', '/').TrimEnd('/')

# 4. Set environment variables for Julia to use this project and local depot
$env:JULIA_DEPOT_PATH = Join-Path $ProjectDir "local_depot"
$env:JULIA_PROJECT    = $ProjectDir

# 5. Load environment variables
$env_path = Join-Path $ProjectDir ".env"
if (Test-Path $env_path) {
    Get-Content $env_path | Where-Object { $_ -match '=' -and $_ -notmatch '^\s*#' } | ForEach-Object {
        # Split only on the first '='
        $key, $value = $_ -split '=', 2
        $key = $key.Trim()
        $value = $value.Trim()
        [Environment]::SetEnvironmentVariable($key, $value, "Process")
    }
}

# 6. Activate and instantiate the project environment using Julia
$activate_script = Join-Path $ProjectDir "_activate.jl"

# Check for existing activation script to avoid overwriting
if (Test-Path $activate_script) {
    Write-Error "Temporary activation script already exists at $activate_script Please remove it before retrying."
    exit 1
}

@"
using Pkg
Pkg.activate("$base_dir_unix")
Pkg.instantiate()
Pkg.add("Infiltrator")
"@ | Set-Content -Encoding UTF8 $activate_script

& "$JuliaPath" --project="$ProjectDir" "$activate_script"
Remove-Item -Force $activate_script

# 7. If a Julia script file was provided, run it; otherwise, launch the REPL.
$script_abs_path = Join-Path $ProjectDir $Script
$script_path = if (Test-Path $script_abs_path -PathType Leaf) { $script_abs_path } else { $Script }
$script_path_unix = ($script_path -replace '\\', '/').TrimEnd('/')

$debug_script = Join-Path $ProjectDir "_debug.jl"
@"
using Infiltrator; 
include("$script_path_unix")
"@ | Set-Content -Encoding UTF8 $debug_script

if (-not $Script -or -not (Test-Path $script_path -PathType Leaf)) {
    Write-Host "Enter interactive Julia REPL. Press Ctrl+D to quit."
    & "$JuliaPath" --project="$ProjectDir" -i -e "using Infiltrator"
} else {
    Write-Host "Debugging $script_path Execution will pause at @infiltrate"
    & "$JuliaPath" --project="$ProjectDir" -i "$debug_script" @ScriptArgs
    Remove-Item -Force $debug_script
}
