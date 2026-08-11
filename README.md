# Julia venv

Setup Julia language virtual environment

![](https://shields.io/badge/dependencies-Julia-purple) *(any version)*
![](https://shields.io/badge/dependencies-Powershell_7-navy)
![](https://shields.io/badge/OS-Windows_11-skyblue)

## Install

Ensure Julia is installed for the current user.

-   If not in default location, you need to specify `-JuliaPath` as instructed later.
-   If multiple versions exist, it'll use the latest version. To use an earlier version, specify `-JuliaPath` as instructed later.

In PowerShell, make the current directory be your instance repository. 

Copy the following files into current directory.

```
.vscode  # optional: if using Visual Studio Code
*.ps1
```

If using Visual Studio Code, press `Ctrl + Shift + P` and select "Tasks: Run Build Task" item. The tasks will be then listed there.

If you don't want to introduce virtual environments into instance repositories, which means you use virtual environments for own convenience without adding new things to your users, add the following content into `.gitignore` of instance repositories.

```
# Julia virtual environment https://github.com/cloudy-sfu/Julia-venv
_debug.jl
_activate.jl
_pluto.jl
local_depot
.env
activate_run.ps1
debug.ps1
pluto.ps1
```

## Usage

### Activate

To activate Julia virtual environment and enter a Julia interactive dialog, run the following command.

```
.\activate_run.ps1
```

### Run

To execute a Julia script, run `.\activate_run.ps1` followed by arguments in PowerShell.

Arguments:

| Name        | Required?                                         | Description                                                 |
| ----------- | ------------------------------------------------- | ----------------------------------------------------------- |
| `-Script` | Optional | The relative path of any Julia script in the Julia project. Default: enter interactive Julia REPL. Positional, the first unnamed argument will be considered as `Script`. |
| `-ProjectDir` | Optional   | The root folder of Julia project. Default: the current folder. |
| `-JuliaPath` | Optional | The absolute path to the `julia.exe` executable. Default: auto-detects installation. |

The files `Manifest.toml` and `Project.toml` will be automatically generated in `ProjectDir` . 

It will use the provided `-JuliaPath`, or automatically search Julia instances in `$env:LOCALAPPDATA\Programs` (`$env:` means environment variables). If an instance is not found, the terminal will hint and require the user to manually input the absolute path of Julia.

If multiple Julia are installed in the default folder, the latest version will be used.

If `.env` exists, the Julia script can use environment variables defined in this file. [Format](https://github.com/env-lang/env/blob/main/env.md)

### Debug

To debug a Julia script, run `.\debug.ps1` followed by arguments.

Arguments:

| Name          | Required? | Description                                                  |
| ------------- | --------- | ------------------------------------------------------------ |
| `-Script`     | Optional  | The relative path of any Julia script in the Julia project. Default: enter interactive Julia REPL. Positional, the first unnamed argument will be considered as `Script`. |
| `-ProjectDir` | Optional  | The root folder of Julia project. Default: the current folder. |
| `-JuliaPath`  | Optional  | The absolute path to the `julia.exe` executable. Default: auto-detects installation. |

Add `@infiltrate` in Julia code to pause the execution there.

In Julia debugger session, press `Ctrl+D` to quit the debugger.

### Interact in Pluto

To enter Pluto environment, run `.\pluto.ps1` followed by arguments.

If Pluto is not installed, this script will automatically install it.

Arguments:

| Name        | Required?                               | Description                       |
| ----------- | --------------------------------------- | --------------------------------- |
| `-ProjectDir` | Optional | The root folder of Julia project. Default: the current folder. |
| `-JuliaPath` | Optional | The absolute path to the `julia.exe` executable. Default: auto-detects installation. |

In the Pluto home page, the dropdown of "Open a notebook" list files in `base_dir`.

To clear "My work" list, press F12 to open inspection in browser.

Run the following command in JavaScript console.

```javascript
localStorage.clear()
```

