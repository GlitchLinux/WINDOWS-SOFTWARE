@echo off
:: Windows Software Downloader Utility - Simplified Installer
:: Assumes 7-Zip is already installed

SETLOCAL
color 0A
title Windows Software Downloader Utility

:: Check if running as administrator
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo ########################################################
    echo # This script requires administrator privileges!       #
    echo # Right-click and select "Run as administrator"        #
    echo ########################################################
    echo.
    pause
    exit /b 1
)

:: Configuration
set "PS_SCRIPT_URL=https://raw.githubusercontent.com/GlitchLinux/WINDOWS-SOFTWARE/main/WINDOWS-TOOLKIT.ps1"
set "UPDATE_SCRIPT_URL=https://raw.githubusercontent.com/GlitchLinux/WINDOWS-SOFTWARE/main/Update-WIN-Toolkit.ps1"
set "PS_SCRIPT_NAME=WindowsSoftwareDownloader.ps1"
set "UPDATE_SCRIPT_NAME=Update-WindowsToolkit.ps1"
set "TEMP_DIR=%TEMP%\WINDOWS-SOFTWARE-INSTALLER"
set "LOCAL_SCRIPT_DIR=%~dp0"
set "LOCAL_SCRIPT_PATH=%LOCAL_SCRIPT_DIR%%PS_SCRIPT_NAME%"
set "BACKUP_SCRIPT_PATH=%LOCAL_SCRIPT_DIR%%PS_SCRIPT_NAME%.backup_%date:/=-%_%time::=-%"

:: Create temp directory
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Main menu
:MAIN_MENU
cls
echo ########################################################
echo #        Windows Software Downloader Utility          #
echo ########################################################
echo.
echo 1. Run Windows Software Downloader
echo 2. Update Windows Software Downloader
echo 3. Exit
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" goto RUN_TOOLKIT
if "%choice%"=="2" goto UPDATE_TOOLKIT
if "%choice%"=="3" goto EXIT
goto MAIN_MENU

:RUN_TOOLKIT
cls
echo ########################################################
echo #       Launching Windows Software Downloader         #
echo ########################################################
echo.

:: Check if local script exists, if not download it
if not exist "%LOCAL_SCRIPT_PATH%" (
    echo Downloading main script...
    powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri '%PS_SCRIPT_URL%' -OutFile '%LOCAL_SCRIPT_PATH%' -ErrorAction Stop; exit 0 } catch { exit 1 }"
    if not exist "%LOCAL_SCRIPT_PATH%" (
        echo Failed to download main script
        pause
        exit /b 1
    )
)

:: Execute the script
powershell -NoProfile -ExecutionPolicy Bypass -File "%LOCAL_SCRIPT_PATH%"
pause
goto MAIN_MENU

:UPDATE_TOOLKIT
cls
echo ########################################################
echo #       Updating Windows Software Downloader          #
echo ########################################################
echo.

:: Download the update script
echo Downloading update script...
powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri '%UPDATE_SCRIPT_URL%' -OutFile '%TEMP_DIR%\%UPDATE_SCRIPT_NAME%' -ErrorAction Stop; exit 0 } catch { exit 1 }"
if not exist "%TEMP_DIR%\%UPDATE_SCRIPT_NAME%" (
    echo Failed to download update script
    pause
    goto MAIN_MENU
)

:: Create backup of current script
if exist "%LOCAL_SCRIPT_PATH%" (
    echo Creating backup of current script...
    copy "%LOCAL_SCRIPT_PATH%" "%BACKUP_SCRIPT_PATH%"
    echo Backup created: %BACKUP_SCRIPT_PATH%
)

:: Run the update script
echo.
echo Running update process...
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_DIR%\%UPDATE_SCRIPT_NAME%"

:: Verify the update
if exist "%LOCAL_SCRIPT_PATH%" (
    echo.
    echo Update completed successfully!
    echo The updated script has been saved to:
    echo %LOCAL_SCRIPT_PATH%
    echo.
    echo You can now run the updated version.
) else (
    echo.
    echo Update failed! The original script remains unchanged.
)

pause
goto MAIN_MENU

:EXIT
:: Cleanup (optional)
:: if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
exit /b 0
