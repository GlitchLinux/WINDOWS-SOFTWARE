@echo off
:: Windows Software Downloader Utility - Simplified Installer
:: Assumes 7-Zip is already installed

SETLOCAL
color 0A
title Windows Software Downloader Utility Installer

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
set "PS_SCRIPT_NAME=WindowsSoftwareDownloader.ps1"
set "TEMP_DIR=%TEMP%\WINDOWS-SOFTWARE-INSTALLER"

:: Create temp directory
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Main function
echo ########################################################
echo #        Windows Software Downloader Utility          #
echo #             Automated Installer                    #
echo ########################################################
echo.

:: Download the main PowerShell script
echo Downloading main script...
powershell -Command "$ProgressPreference = 'SilentlyContinue'; try { Invoke-WebRequest -Uri '%PS_SCRIPT_URL%' -OutFile '%TEMP_DIR%\%PS_SCRIPT_NAME%' -ErrorAction Stop; exit 0 } catch { exit 1 }"
if not exist "%TEMP_DIR%\%PS_SCRIPT_NAME%" (
    echo Failed to download main script
    pause
    exit /b 1
)

:: Execute the script
echo.
echo ########################################################
echo #       Launching Windows Software Downloader         #
echo ########################################################
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_DIR%\%PS_SCRIPT_NAME%"

:: Cleanup (optional)
:: if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"

pause
exit /b 0
