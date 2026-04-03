<#
.SYNOPSIS
Start the Julia project in Pluto.
.DESCRIPTION
To open a Pluto notebook in the Julia project, run pluto.ps1 followed by arguments.
Behaviors:
1. The files Manifest.toml and Project.toml will be automatically generated in base_dir.
2. It will use the provided julia_path, or automatically search Julia instances in $env:LOCALAPPDATA\Programs. If not found, it will abort with an error.
3. If multiple Julia instances are installed in the default folder, the latest version will be used.
4. If Pluto is not installed in the local depot, this script will automatically install it.
.PARAMETER base_dir
The root folder of Julia project. Default: the current folder.
.PARAMETER julia_path
The absolute path to julia.exe executable. Default: auto-detects in LOCALAPPDATA.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, HelpMessage="The root folder of Julia project.")] [string]$ProjectDir,
    [Parameter(Mandatory=$false, HelpMessage="The absolute path to julia.exe executable.")] [string]$JuliaPath
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
"@ | Set-Content -Encoding UTF8 $activate_script

& "$JuliaPath" --project="$ProjectDir" "$activate_script"

Remove-Item -Force $activate_script

# 7. Add Pluto if not exists
if (-not (Test-Path "$env:JULIA_DEPOT_PATH\packages\Pluto")) {
    $pluto_script = Join-Path $ProjectDir "_pluto.jl"

    # Check for existing activation script to avoid overwriting
    if (Test-Path $pluto_script) {
        Write-Error "Temporary Pluto installer already exists at $pluto_script Please remove it before retrying."
        exit 1
    }

@"
using Pkg;
Pkg.add("Pluto");
"@ | Set-Content -Encoding UTF8 $pluto_script

    & "$JuliaPath" --project="$ProjectDir" "$pluto_script"

    Remove-Item -Force $pluto_script
}

& "$JuliaPath" -e "import Pluto; Pluto.run();"
