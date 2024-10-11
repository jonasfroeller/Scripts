@echo off
setlocal enabledelayedexpansion

:: The root folder is the first argument.
set "start_path=%~1"
if "%start_path%"=="" set "start_path=%CD%"

:: Set logging_enabled to 0 by default (logging off), and enable it if --log is passed
set "logging_enabled=0"
if "%~2"=="--log" (
    set "logging_enabled=1"
)

echo Searching for Git repositories in: "%start_path%"
echo.

set "found=0"

:: Check for .git folders
for /d /r "%start_path%" %%i in (.git) do (
    if exist "%%i" (
        if !logging_enabled! equ 1 (
            echo Checking: %%i
        )
        
        rem Check if the path contains node_modules
        echo %%~dpi | findstr /i "\\node_modules\\" >nul
        if !errorlevel! equ 1 (
            if exist "%%i\HEAD" (
                if !logging_enabled! equ 1 (
                    echo Found HEAD file in: %%i
                ) else (
                    echo %%~dpi
                )

                set /a found+=1
            ) else (
                if !logging_enabled! equ 1 (
                    echo No HEAD file in: %%i
                )
            )
        ) else (
            if !logging_enabled! equ 1 (
                echo Skipped due to node_modules: %%~dpi
            )
        )
    )
)

echo.
if !found! equ 0 (
    echo No Git repositories found.
) else (
    echo Search completed.
    echo Total Git repositories found: !found!
)
echo.
pause
