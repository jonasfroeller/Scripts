@echo off
setlocal enabledelayedexpansion

:: Prompt the user for the input filename
set /p input_file=Enter the input filename (e.g., input.mp4): 

:: Remove surrounding quotes if they exist
set input_file=%input_file:"=%

:: Check if the input file exists
if not exist "%input_file%" (
  echo File not found!
  pause
  exit /b 1
)

:: Generate the output filename by appending "-normalized" before the file extension
for %%i in ("%input_file%") do set output_file=%%~ni-normalized%%~xi

:: First Pass: Measure Loudness
ffmpeg -i "%input_file%" -af loudnorm=I=-14:TP=-1:LRA=11:print_format=json -f null - 2> loudnorm.json

:: Check if the loudnorm.json file was created
if not exist loudnorm.json (
  echo Failed to create loudnorm.json
  pause
  exit /b 1
)

:: Extract values from JSON
for /f "tokens=2 delims=:," %%i in ('findstr /c:"input_i" loudnorm.json') do set input_i=%%i
for /f "tokens=2 delims=:," %%i in ('findstr /c:"input_tp" loudnorm.json') do set input_tp=%%i
for /f "tokens=2 delims=:," %%i in ('findstr /c:"input_lra" loudnorm.json') do set input_lra=%%i
for /f "tokens=2 delims=:," %%i in ('findstr /c:"input_thresh" loudnorm.json') do set input_thresh=%%i
for /f "tokens=2 delims=:," %%i in ('findstr /c:"offset" loudnorm.json') do set offset=%%i

:: Remove leading spaces from extracted values
for %%i in (input_i input_tp input_lra input_thresh offset) do (
    set "value=!%%i!"
    set "%%i=!value:~1!"
)

:: Print extracted values for debugging
echo input_i=%input_i%
echo input_tp=%input_tp%
echo input_lra=%input_lra%
echo input_thresh=%input_thresh%
echo offset=%offset%

:: Second Pass: Normalize Loudness
ffmpeg -i "%input_file%" -af loudnorm=I=-14:TP=-1:LRA=11:measured_I=%input_i%:measured_TP=%input_tp%:measured_LRA=%input_lra%:measured_thresh=%input_thresh%:offset=%offset%:linear=true:print_format=summary "%output_file%"

:: Check if the output file was created
if not exist "%output_file%" (
  echo Failed to create output file
  pause
  exit /b 1
)

:: Clean up the JSON file
del loudnorm.json

echo Loudness normalization complete. Output saved to "%output_file%".
pause
