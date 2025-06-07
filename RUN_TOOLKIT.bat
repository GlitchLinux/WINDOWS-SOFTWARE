@echo off
:: Windows Software Downloader Utility Installer
:: Checks dependencies, downloads main script, and executes it

SETLOCAL EnableDelayedExpansion
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
set "7ZIP_URL=https://www.7-zip.org/a/7z2301-x64.exe"
set "7ZIP_INSTALLER=7z-installer.exe"

:: Create temp directory
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

:: Main function
call :MAIN
goto :EOF

:MAIN
    echo ########################################################
    echo #        Windows Software Downloader Utility          #
    echo #             Automated Installer                    #
    echo ########################################################
    echo.

    :: Check PowerShell version
    call :CHECK_POWERSHELL
    if !PS_OK! == false (
        echo Failed to verify PowerShell requirements
        pause
        exit /b 1
    )

    :: Check 7-Zip installation
    call :CHECK_7ZIP
    if !7ZIP_OK! == false (
        call :INSTALL_7ZIP
        if !7ZIP_OK! == false (
            echo Failed to install 7-Zip
            pause
            exit /b 1
        )
    )

    :: Download the main PowerShell script
    call :DOWNLOAD_SCRIPT
    if !DOWNLOAD_OK! == false (
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
    
    :: Cleanup
    if exist "%TEMP_DIR%" rmdir /s /q "%TEMP_DIR%"
    
    exit /b 0

:CHECK_POWERSHELL
    echo Checking PowerShell version...
    powershell -command "$PSVersionTable.PSVersion.Major" >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo PowerShell is not installed. Installing PowerShell 5.1...
        call :INSTALL_POWERSHELL
    ) else (
        powershell -command "if ($PSVersionTable.PSVersion.Major -ge 5) { exit 0 } else { exit 1 }"
        if %ERRORLEVEL% equ 0 (
            echo PowerShell version is compatible.
            set "PS_OK=true"
        ) else (
            echo PowerShell version is too old. Attempting to update...
            call :INSTALL_POWERSHELL
        )
    )
    goto :EOF

:INSTALL_POWERSHELL
    echo Installing Windows Management Framework 5.1 (includes PowerShell 5.1)...
    
    :: Check system architecture
    if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
        set "PS_URL=https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu"
        set "PS_INSTALLER=Win8.1AndW2K12R2-KB3191564-x64.msu"
    ) else (
        set "PS_URL=https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1-KB3191564-x86.msu"
        set "PS_INSTALLER=Win8.1-KB3191564-x86.msu"
    )
    
    echo Downloading PowerShell installer...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%PS_URL%', '%TEMP_DIR%\%PS_INSTALLER%')"
    if not exist "%TEMP_DIR%\%PS_INSTALLER%" (
        echo Failed to download PowerShell installer
        set "PS_OK=false"
        goto :EOF
    )
    
    echo Installing PowerShell...
    start /wait wusa "%TEMP_DIR%\%PS_INSTALLER%" /quiet /norestart
    if %ERRORLEVEL% neq 0 (
        echo Failed to install PowerShell
        set "PS_OK=false"
        goto :EOF
    )
    
    echo PowerShell installed successfully
    set "PS_OK=true"
    goto :EOF

:CHECK_7ZIP
    echo Checking for 7-Zip installation...
    where 7z >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo 7-Zip is already installed.
        set "7ZIP_OK=true"
    ) else (
        set "7ZIP_OK=false"
    )
    goto :EOF

:INSTALL_7ZIP
    echo 7-Zip not found. Installing 7-Zip...
    echo Downloading 7-Zip installer...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%7ZIP_URL%', '%TEMP_DIR%\%7ZIP_INSTALLER%')"
    if not exist "%TEMP_DIR%\%7ZIP_INSTALLER%" (
        echo Failed to download 7-Zip installer
        set "7ZIP_OK=false"
        goto :EOF
    )
    
    echo Installing 7-Zip...
    start /wait "" "%TEMP_DIR%\%7ZIP_INSTALLER%" /S
    if %ERRORLEVEL% neq 0 (
        echo Failed to install 7-Zip
        set "7ZIP_OK=false"
        goto :EOF
    )
    
    :: Verify installation
    where 7z >nul 2>&1
    if %ERRORLEVEL% equ 0 (
        echo 7-Zip installed successfully
        set "7ZIP_OK=true"
    ) else (
        echo 7-Zip installation verification failed
        set "7ZIP_OK=false"
    )
    goto :EOF

:DOWNLOAD_SCRIPT
    echo Downloading main PowerShell script...
    powershell -Command "(New-Object Net.WebClient).DownloadFile('%PS_SCRIPT_URL%', '%TEMP_DIR%\%PS_SCRIPT_NAME%')"
    if not exist "%TEMP_DIR%\%PS_SCRIPT_NAME%" (
        echo Failed to download main script
        set "DOWNLOAD_OK=false"
        goto :EOF
    )
    
    echo Script downloaded successfully
    set "DOWNLOAD_OK=true"
    goto :EOF

:ERROR
    echo An error occurred during installation
    pause
    exit /b 1
