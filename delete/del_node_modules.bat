@echo off
setlocal EnableDelayedExpansion

REM Deletes all node_modules folders in the current directory and its subdirectories.

for /r %%d in (node_modules) do (
    rd /s /q "%%d"
    echo deleted "%%d"
)

pause