@echo off

for /f "usebackq delims=" %%J in (
  `powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0get_julia_latest_version.ps1"`
) do set "julia_path=%%J"

if not defined julia_path (
    set /p julia_path=Julia installed path ^(path to "...\bin\julia.exe"^):
) else (
    echo Found Julia installed at %julia_path%
)

set "base_dir=%~1"
if not defined base_dir (
    set "base_dir=%cd%"
)
set "base_dir_unix=%base_dir:\=/%"
set "JULIA_DEPOT_PATH=%base_dir%\local_depot"
set "JULIA_PROJECT=%base_dir%"

%julia_path% -e "using Pkg; Pkg.activate(\"%base_dir_unix%\"); Pkg.instantiate();"
set "current_file=%~2"
if defined current_file (
    %julia_path% --project="%base_dir%" "%current_file%"
) else (
    %julia_path%
)
