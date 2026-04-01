# Julia venv

Setup Julia language virtual environment

![](https://shields.io/badge/dependencies-Julia-purple)
![](https://shields.io/badge/dependencies-Powershell_7-navy)
![](https://shields.io/badge/OS-Windows_10_64--bit-navy)

>   [!note]
>
>   The project is theoretically compatible to PowerShell 5.1, but not fully tested.

## Usage

Copy PowerShell scripts into Julia application's root directory. In that directory, open PowerShell.

If using Visual Studio code: Press `Ctrl + Shift + P` and find "Tasks: Run Build Task", select this option. The tasks will be then listed there.

`.gitignore` list relevant to this program:

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



### Activate

To activate Julia virtual environment and enter a Julia interactive dialog, run the following command.

```
.\activate_run.ps1
```

### Run

To execute a Julia script, run `.\activate_run.ps1` followed by arguments.

Arguments:

| Name        | Required?                                         | Description                                                 |
| ----------- | ------------------------------------------------- | ----------------------------------------------------------- |
| `-script`   | Optional | The relative path of any Julia script in the Julia project. Default: enter interactive Julia REPL. |
| `-base_dir` | Optional   | The root folder of Julia project. Default: the current folder. |
| `-julia_path` | Optional | The absolute path to the `julia.exe` executable. Default: auto-detects installation. |

>   [!note]
>
>   This script uses [PowerShell style arguments](https://gist.github.com/cloudy-sfu/dce5106496125096092c7a7cc7846f7b).

The files `Manifest.toml` and `Project.toml` will be automatically generated in `base_dir` . 

It will use the provided `-julia_path`, or automatically search Julia instances in `$env:LOCALAPPDATA\Programs` (`$env:` means environment variables). If an instance is not found, the terminal will hint and require the user to manually input the absolute path of Julia.

If multiple Julia are installed in the default folder, the latest version will be used.

If `.env` exists, the Julia script can use environment variables defined in this file. [Format](https://github.com/env-lang/env/blob/main/env.md)

### Debug

To debug a Julia script, run `.\debug.ps1` followed by arguments.

Arguments:

| Name          | Required? | Description                                                  |
| ------------- | --------- | ------------------------------------------------------------ |
| `-script`     | Optional  | The relative path of any Julia script in the Julia project. Default: enter interactive Julia REPL. |
| `-base_dir`   | Optional  | The root folder of Julia project. Default: the current folder. |
| `-julia_path` | Optional  | The absolute path to the `julia.exe` executable. Default: auto-detects installation. |

Add `@infiltrate` in Julia code to pause the execution there.

In Julia debugger session, press `Ctrl+D` to quit the debugger.

### Pluto

To enter Pluto environment, run `.\pluto.ps1` followed by arguments.

>   [!note]
>
>   If Pluto is not installed, this script will automatically install it.

Arguments:

| Name        | Required?                               | Description                       |
| ----------- | --------------------------------------- | --------------------------------- |
| `-base_dir` | Optional | The root folder of Julia project. Default: the current folder. |
| `-julia_path` | Optional | The absolute path to the `julia.exe` executable. Default: auto-detects installation. |

In the Pluto home page, the dropdown of "Open a notebook" list files in `base_dir`.

To clear "My work" list, press F12 to open inspection in browser.

Run the following command in JavaScript console.

```javascript
localStorage.clear()
```

