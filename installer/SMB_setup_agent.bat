@echo off
setlocal enabledelayedexpansion

echo SmartMarketBuddy Installation Script
echo ===================================

:: Set up directories
set "RESOURCE_DIR=%TEMP%\SMB_Resources"
set "INSTALL_DIR=%LOCALAPPDATA%\SmartMarketBuddy"
set "PYTHON_VERSION=3.12"

:: Create directories
if not exist "%RESOURCE_DIR%" mkdir "%RESOURCE_DIR%"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

:: Step 1: Download Resources
echo.
echo Step 1/5: Downloading required resources...
echo ========================================

:: Download files using PowerShell helper script
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0download_helper.ps1" "%RESOURCE_DIR%\SMB_signal_parser-main.zip" "%RESOURCE_DIR%\tesseract-portable.zip"

:: Check Python Installation
python --version 2>NUL
if %ERRORLEVEL% NEQ 0 (
    echo Python not found. Downloading Python %PYTHON_VERSION%...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; $arch = if ([Environment]::Is64BitOperatingSystem) { 'amd64' } else { 'win32' }; $pythonUrl = 'https://www.python.org/ftp/python/%PYTHON_VERSION%.0/python-%PYTHON_VERSION%.0-' + $arch + '.exe'; Write-Host 'Downloading Python...'; Invoke-WebRequest -Uri $pythonUrl -OutFile '%RESOURCE_DIR%\python_installer.exe'"
)

:: Step 2: Extract and Install
echo.
echo Step 2/5: Extracting and Installing Components...
echo ==============================================

:: Extract archives using PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; if (Test-Path '%RESOURCE_DIR%\SMB_signal_parser-main.zip') { Write-Host 'Extracting fx_trading_app...'; Expand-Archive -Path '%RESOURCE_DIR%\SMB_signal_parser-main.zip' -DestinationPath '%RESOURCE_DIR%' -Force } else { Write-Host 'Error: SMB_signal_parser-main.zip not found!'; exit 1 }"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; if (Test-Path '%RESOURCE_DIR%\tesseract-portable.zip') { Write-Host 'Extracting tesseract-portable...'; Expand-Archive -Path '%RESOURCE_DIR%\tesseract-portable.zip' -DestinationPath '%RESOURCE_DIR%' -Force } else { Write-Host 'Error: tesseract-portable.zip not found!'; exit 1 }"

:: Install Python if needed
if exist "%RESOURCE_DIR%\python_installer.exe" (
    echo Installing Python %PYTHON_VERSION%...
    "%RESOURCE_DIR%\python_installer.exe" /quiet InstallAllUsers=0 PrependPath=1
    :: Wait for Python installation to complete
    timeout /t 30 /nobreak
)

:: Step 3: Setup Virtual Environment and Install Requirements
echo.
echo Step 3/5: Setting up Python Environment...
echo ======================================

:: Refresh environment variables to detect newly installed Python
powershell -NoProfile -ExecutionPolicy Bypass -Command "$env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')"

:: Create and activate virtual environment
python -m venv "%INSTALL_DIR%\venv"
if %ERRORLEVEL% NEQ 0 (
    echo Error creating virtual environment. Installation cannot continue.
    pause
    exit /b 1
)

call "%INSTALL_DIR%\venv\Scripts\activate.bat"

:: Install requirements
python -m pip install --upgrade pip
if exist "%RESOURCE_DIR%\SMB_signal_parser-main\requirements.txt" (
    python -m pip install -r "%RESOURCE_DIR%\SMB_signal_parser-main\requirements.txt"
) else (
    echo Error: requirements.txt not found!
    pause
    exit /b 1
)

:: Move files to installation directory
echo Moving files to installation directory...
xcopy /E /I /Y "%RESOURCE_DIR%\SMB_signal_parser-main\*" "%INSTALL_DIR%"
if exist "%RESOURCE_DIR%\tesseract-portable" (
    xcopy /E /I /Y "%RESOURCE_DIR%\tesseract-portable" "%INSTALL_DIR%\tesseract-portable"
)

:: Step 4: Cleanup
echo.
echo Step 4/5: Cleaning up...
echo =====================
rd /s /q "%RESOURCE_DIR%"

:: Step 5: Create Launch Script and Shortcuts
echo.
echo Step 5/5: Creating shortcuts...
echo ============================

:: Create SMB.bat (hidden launcher)
echo @echo off > "%INSTALL_DIR%\SMB.bat"
echo call "%%~dp0venv\Scripts\activate.bat" >> "%INSTALL_DIR%\SMB.bat"
echo cd "%%~dp0" >> "%INSTALL_DIR%\SMB.bat"
echo python "%%~dp0webview_launcher.py" >> "%INSTALL_DIR%\SMB.bat"

:: Create VBScript launcher to hide command prompt
echo Set oShell = CreateObject^("WScript.Shell"^) > "%INSTALL_DIR%\SMB_launcher.vbs"
echo oShell.Run Chr^(34^) ^& "%INSTALL_DIR%\SMB.bat" ^& Chr^(34^), 0, False >> "%INSTALL_DIR%\SMB_launcher.vbs"

:: Create shortcuts using PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\SmartMarketBuddy.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\SMB_launcher.vbs'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\static\images\SMB_logo_blue.ico'; $Shortcut.Save(); $StartMenuPath = [Environment]::GetFolderPath('StartMenu') + '\Programs\SmartMarketBuddy'; if (-not (Test-Path $StartMenuPath)) { New-Item -ItemType Directory -Path $StartMenuPath }; $Shortcut = $WshShell.CreateShortcut($StartMenuPath + '\SmartMarketBuddy.lnk'); $Shortcut.TargetPath = '%INSTALL_DIR%\SMB_launcher.vbs'; $Shortcut.WorkingDirectory = '%INSTALL_DIR%'; $Shortcut.IconLocation = '%INSTALL_DIR%\static\images\SMB_logo_blue.ico'; $Shortcut.Save()"

:: Create uninstall.bat
echo @echo off > "%INSTALL_DIR%\uninstall.bat"
echo echo Uninstalling SmartMarketBuddy... >> "%INSTALL_DIR%\uninstall.bat"
echo timeout /t 2 /nobreak >> "%INSTALL_DIR%\uninstall.bat"
echo rd /s /q "%INSTALL_DIR%" >> "%INSTALL_DIR%\uninstall.bat"
echo del "%USERPROFILE%\Desktop\SmartMarketBuddy.lnk" >> "%INSTALL_DIR%\uninstall.bat"
echo rd /s /q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\SmartMarketBuddy" >> "%INSTALL_DIR%\uninstall.bat"
echo echo Uninstallation complete. >> "%INSTALL_DIR%\uninstall.bat"
echo pause >> "%INSTALL_DIR%\uninstall.bat"

echo.
echo Installation Complete!
echo ====================
echo SmartMarketBuddy has been installed successfully.
echo Shortcuts have been created on your desktop and in the Start Menu.
echo An uninstall script has been created at %INSTALL_DIR%\uninstall.bat
echo.

:: Display MT5 setup instructions
echo.
echo IMPORTANT MT5 SETUP INSTRUCTIONS:
echo ===============================
echo Please ensure that:
echo 1. You have MetaTrader 5 installed and are logged into your broker account
echo 2. Algorithmic trading is enabled in MT5:
echo    - Open MT5
echo    - Go to Tools -^> Options -^> Expert Advisors
echo    - Enable "Allow automated trading"
echo    - Enable "Allow WebRequest for listed URL"
echo    - Add "localhost" to the WebRequest URLs list
echo.
pause
