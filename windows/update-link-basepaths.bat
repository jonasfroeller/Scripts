@echo off
setlocal enabledelayedexpansion

REM Set the source and target you want to replace in the shortcuts
set "source=<path_to_replace>"
set "target=<path_that_replaces>"

REM Loop through all shortcuts in the current directory
for %%f in (*.lnk) do (
    set "link=%%~ff"
    set "target_link=!link:%source%=%target%!"

    REM Display which shortcut is being updated
    echo Updating !link! to !target_link!

    REM Use PowerShell to update the shortcut path
    set "command=powershell -Command [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic'); $shortcut = [Microsoft.VisualBasic.Interaction]::CreateObject('WScript.Shell').CreateShortcut('!link!'); $shortcut.TargetPath = $shortcut.TargetPath.replace('%source%', '%target%'); $shortcut.Save();"

    REM Execute the PowerShell command
    cmd /c "!command!"
)

pause
