@echo off

REM This script deletes all temporary files and directories.

REM setting temp path
set tmp_dir=%localappdata%\Temp

REM changing to temp dir
cd /d %tmp_dir%

REM deleting temporary files and directories
del /q /f /s *
for /d %%x in (*) do rmdir /s /q "%%x"

pause