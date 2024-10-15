@ECHO OFF
color 0A

REM set paths
SET YOUTUBE_DL_PATH=A:\VideoDownloader\youtube-dl-nightly.exe
SET FFMPEG_PATH=C:\ProgramData\chocolatey\lib\ffmpeg\tools\ffmpeg\bin\ffmpeg.exe
SET OUTPUT_PATH=D:\Downloads

ECHO ======================================================================================================================
ECHO.
SET /P URL="[Enter video URL] "
ECHO.
ECHO ======================================================================================================================
ECHO.

REM download video
%YOUTUBE_DL_PATH% -f "(bestvideo[height>2160][vcodec^=av01]/bestvideo[height>2160][vcodec^=vp9]/bestvideo[height>1440][vcodec^=av01]/bestvideo[height>1440][vcodec^=vp9][fps>30]/bestvideo[height>1440][vcodec^=vp9]/bestvideo[height>1080][vcodec^=av01]/bestvideo[height>1080][vcodec^=vp9][fps>30]/bestvideo[height>1080][vcodec^=vp9]/bestvideo[height>720][vcodec^=av01]/bestvideo[height>720][vcodec^=vp9][fps>30]/bestvideo[height>720][vcodec^=vp9]/bestvideo[height>240][vcodec^=av01]/bestvideo[vcodec^=vp9][fps>30]/bestvideo[height>240][vcodec^=vp9]/best[height>240]/bestvideo[vcodec^=av01]/bestvideo[vcodec^=vp9]/bestvideo)+(bestaudio[asr=48000]/bestaudio)/bestaudio[ext=opus]/best" --verbose --write-sub --all-subs --embed-subs --add-metadata --ffmpeg-location "%FFMPEG_PATH%" --external-downloader ffmpeg --user-agent "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" --merge-output-format mkv --output "%OUTPUT_PATH%\%%(title)s.%%(ext)s" %URL%

REM create mp4 version(s)
for %%I in ("%OUTPUT_PATH%\*.mkv") do (
    SET "INPUT_FILE=%%I"
    CALL :PROCESS_FILE "%%I"
)

GOTO :EOF

:PROCESS_FILE
SET "INPUT_FILE=%~1"
SET "FILE_NAME=%~n1"
%FFMPEG_PATH% -i "%INPUT_FILE%" -c:v libx264 -crf 28 "%OUTPUT_PATH%\%FILE_NAME%.mp4"

GOTO :EOF

ECHO.
ECHO ======================================================================================================================
ECHO.
ECHO Done!

PAUSE
EXIT
