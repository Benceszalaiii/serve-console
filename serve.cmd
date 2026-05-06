@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SERVE_CONFIG=%USERPROFILE%\.serve-projects.txt"

if not exist "%SERVE_CONFIG%" type nul > "%SERVE_CONFIG%"

if "%~1"=="" goto :help
if /I "%~1"=="add" goto :add
if /I "%~1"=="list" goto :list
if /I "%~1"=="help" goto :help
if /I "%~1"=="--help" goto :help
if /I "%~1"=="-h" goto :help

goto :run

:add
set "PROJECT_NAME=%~2"
if "%PROJECT_NAME%"=="" (
  echo Missing project name.
  echo Usage: serve add project-name --path "C:\path\to\dir"
  exit /b 1
)

set "PROJECT_PATH="
:parseAddArgs
if "%~3"=="" goto :finishAddArgs
if /I "%~3"=="--path" (
  set "PROJECT_PATH=%~4"
  shift
  shift
  goto :parseAddArgs
)
shift
goto :parseAddArgs

:finishAddArgs
if "%PROJECT_PATH%"=="" (
  echo Missing --path argument.
  echo Usage: serve add project-name --path "C:\path\to\dir"
  exit /b 1
)

findstr /B /I /C:"%PROJECT_NAME%|" "%SERVE_CONFIG%" >nul
if not errorlevel 1 (
  > "%SERVE_CONFIG%.tmp" (
    for /f "usebackq delims=" %%L in ("%SERVE_CONFIG%") do (
      set "line=%%L"
      echo(!line!| findstr /B /I /C:"%PROJECT_NAME%|" >nul
      if errorlevel 1 echo(!line!
    )
  )
  move /Y "%SERVE_CONFIG%.tmp" "%SERVE_CONFIG%" >nul
)

echo %PROJECT_NAME%^|%PROJECT_PATH%>>"%SERVE_CONFIG%"
echo Added %PROJECT_NAME% = %PROJECT_PATH%
exit /b 0

:list
set "FOUND_ANY="
for /f "usebackq tokens=1,* delims=|" %%A in ("%SERVE_CONFIG%") do (
  set "FOUND_ANY=1"
  echo %%A = %%B
)
if not defined FOUND_ANY echo No projects saved.
exit /b 0

:run
set "PROJECT_NAME=%~1"
set "PROJECT_PATH="
for /f "usebackq tokens=1,* delims=|" %%A in ("%SERVE_CONFIG%") do (
  if /I "%%A"=="%PROJECT_NAME%" set "PROJECT_PATH=%%B"
)

if not defined PROJECT_PATH (
  echo Unknown project: %PROJECT_NAME%
  echo.
  goto :list
)

if not exist "%PROJECT_PATH%" (
  echo Saved path does not exist:
  echo %PROJECT_PATH%
  exit /b 1
)

cd /d "%PROJECT_PATH%"
echo Running bun dev in %CD%
bun dev
exit /b %errorlevel%

:help
echo serve - run bun dev from saved project aliases
echo.
echo Usage:
echo   serve add project-name --path "C:\path\to\dir"
echo   serve list
echo   serve project-name
echo.
echo Examples:
echo   serve add tic-tac-toe --path "C:\projects\tic-tac-toe"
echo   serve add portfolio --path "D:\dev\portfolio"
echo   serve tic-tac-toe
exit /b 0
