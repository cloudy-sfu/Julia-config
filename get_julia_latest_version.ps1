$juliaPath = Get-ChildItem -Directory -Path "$env:LOCALAPPDATA\Programs" -Filter "Julia-*" |
    Sort-Object { [version]($_.Name -replace '^Julia-','') } -Descending |
    Select-Object -First 1 |
    ForEach-Object { Join-Path $_.FullName "bin\julia.exe" }
Write-Output $juliaPath