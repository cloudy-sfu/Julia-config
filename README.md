# Julia config

![](https://shields.io/badge/dependencies-Julia-purple)
![](https://shields.io/badge/dependencies-Powershell_5.1-cyan)
![](https://shields.io/badge/OS-Windows_10_64--bit-navy)

## Usage

### Run scripts

To run a Julia script or open Julia interactive dialog, run the following command in Windows command prompt (CMD).

```
activate.bat [<base_dir> [<file_path>]]
```

Arguments:

- `base_dir`  means the root folder of Julia project. The files `Manifest.toml` and `Project.toml` will be automatically generated in this folder. If this argument is not provided, the current folder which triggers `activate.bat` script will be used.
- `file_path` means the path of any Julia script in the Julia program `base_dir`.

It is recommended to copy `activate.bat` and `get_julia_latest_version.ps1` to the user's Julia project.

To run the script in active tab in Visual Studio Code, 

1. Copy `.vscode/tasks.json` in this program to `.vscode` of the user's Julia project.
2. Press `Ctrl + Shift + P` and find "Tasks: Run Build Task", choose this action.

### Pluto

To open Pluto notebook in `base_dir`, run the following command.

*If Pluto is not installed, this script will automatically install it.*

```
call pluto.bat
```

In the Pluto home page, the dropdown of "Open a notebook" list files in `base_dir`.

To clear the "My work" list, open the F12 console in browser and run the following command.

```javascript
localStorage.clear()
```

