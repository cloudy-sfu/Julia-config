@echo off
REM --------------- USER INPUT BEGIN ---------------
set "julia_path=C:\Users\%username%\AppData\Local\Programs\Julia-1.11.4\bin\julia.exe"
REM --------------- USER INPUT END   ---------------

if not defined julia_path (
    echo Error: Variable "julia_path" is not defined or is empty.
    exit /b 1
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
    %julia_path% "%current_file%"
) else (
    %julia_path%
)
