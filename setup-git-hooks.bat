@echo off
setlocal

echo Setting up git hooks...

if not exist ".git\hooks" (
    mkdir ".git\hooks"
)

REM Create the pre-commit hook with Windows line endings
(
echo @echo off
echo python update-readme-toc.py
echo IF %%ERRORLEVEL%% NEQ 0 EXIT /b %%ERRORLEVEL%%
echo git add README.md
) > .git\hooks\pre-commit.bat

REM Create the pre-commit hook with Unix line endings
(
echo #!/bin/sh
echo python update-readme-toc.py
echo if [ $? -ne 0 ]; then
echo     exit 1
echo fi
echo git add README.md
) > .git\hooks\pre-commit

REM Set the core.fileMode config to false to prevent permission issues
git config core.fileMode false

echo Git hooks setup complete!
echo Pre-commit hooks installed successfully.
