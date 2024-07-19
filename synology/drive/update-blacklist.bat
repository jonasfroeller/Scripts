@echo off
REM The '@echo off' command is used to turn off the display of each command in the batch file as it is executed.

setlocal
REM 'setlocal' is used to limit the scope of environment variable changes to the current batch script.

set sourceFile=.drive_global_blacklist.filter
REM 'sourceFile' variable is set to the path of the file whose contents you want to copy.

for /D %%I in (C:\Users\%USERNAME%\AppData\Local\SynologyDrive\data\session\*) do (
    REM This loop iterates through all subdirectories under the specified path.

    if exist "%%I\conf\blacklist.filter" (
        REM Check if the file to be overwritten exists in the current directory.

        copy %sourceFile% "%%I\conf\blacklist.filter" /Y
        REM Copy the contents of the source file to the destination file, overwriting it. The '/Y' flag suppresses the confirmation prompt.

        echo File contents copied to %%I\conf\blacklist.filter
        REM Display a message indicating that the file contents have been copied successfully.
    ) else (
        echo %%I\conf\blacklist.filter does not exist.
        REM Display a message if the destination file does not exist in the current directory.
    )
)

endlocal
REM 'endlocal' is used to end the local environment variable changes made within the script.
