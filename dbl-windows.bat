@echo off

REM Check if no arguments are provided
if "%~1"=="" (
    echo MUST GIVE A DBL FILE AS AN ARGUMENT
    exit /b 1
)

REM Check if directory exists and delete it
if exist "windows\commands\" (
    rd /s /q "windows\commands"
)

REM Copy the file
copy "%~1" "windows\%~1"

REM Change directory
cd windows

REM Run node
node lang.js "%~1"

REM Remove the file
del "%~1"

REM Return to the previous directory

cd ..

exit /b
