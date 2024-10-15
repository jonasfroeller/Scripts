@echo off

REM Revoke inheritance for the key file
icacls <key_name>.key /inheritance:r

REM Grant read and execute permissions to the current user
icacls <key_name>.key /grant:r %USERNAME%:(RX)

REM Remove permissions from all other users
icacls <key_name>.key /remove:g Everyone
icacls <key_name>.key /remove:g Users

echo Permissions have been adjusted successfully.
pause
