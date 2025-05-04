# Julia config

![](https://shields.io/badge/dependencies-Julia_1.11-purple)
![](https://shields.io/badge/OS-Windows_10_64--bit-navy)

## Install

If Julia is not installed in the default path:

*The default installation is at* `C:\Users\%username%\AppData\Local\Programs\Julia-1.11.4\bin\julia.exe`

- Open `activate.bat` and modify `julia_path` variable in "USER INPUT" area.

To use visual studio code shortcut:

- Combine `.vscode/tasks.json` into the user's project.

## Usage

Definitions:

- `%base_dir%` is the workspace, or program's root directory. The automatically generated `Manifest.toml` and `Project.toml` are in this directory.
- `%file_path%` is the Julia file to execute (e.g. `hello_world.jl`), also the file corresponding to the active tab in Visual Studio Code.

In Windows command prompt (CMD), to start Julia dialog in the current folder, run the following command.

*The current folder is set as a virtual environment. In the dialog, packages are all retrieved from and installed into the relative `local_depot` folder.*

``` 
call activate.bat
```

To customize the virtual environment, run the following command.

```
call activate.bat %base_dir%
```

To use the virtual environment to run a Julia file, run the following command.

```
call activate.bat %base_dir% %file_path%
```

In Visual Studio code, to run the active tab, press `Ctrl + Shift + P` and find "Tasks: Run Build Task", then choose this action. The active tab will run in the virtual environment.

### Pluto

To open Pluto notebook on `%base_dir%` (in the Pluto home page, the dropdown of "Open a notebook" list files in `%base_dir%`), run the following command.

*If Pluto is not installed, this script will automatically install it.*

```
call pluto.bat
```

To clear the "My work" recent list, open the F12 console and run

```javascript
localStorage.clear()
```

