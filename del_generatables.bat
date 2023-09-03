@echo off
setlocal EnableDelayedExpansion

REM This script deletes all generatable files and folders you specify in the variables below.

REM ./<folder_domain>/<further_path>
set "frontend=node_modules .svelte-kit"
set "backend=vendor"

REM .env
set "del_prvt_vars=true"

REM .pem
set "del_prvt_keys=true"

if "%del_prvt_vars%"=="true" (
    echo deleting .env files
    del /s /q .\*.env
) else (
    echo skipping deletion of .env files
)

if "%del_prvt_keys%"=="true" (
    echo deleting .pem files
    del /s /q .\*.pem
) else (
    echo skipping deletion of .pem files
)

for %%A in (frontend backend) do (
    echo domain=%%A
    for %%B in (!%%A!) do (
        echo path=%%B
        set "folder_to_delete=%%A\%%B"

        echo deleting !folder_to_delete!
        rmdir /s /q "!folder_to_delete!"
    )
)

pause
