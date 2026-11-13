@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Instalacion PERSONAL de ilustraciones desde JW.org.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALAR_IMAGENES_JW_PERSONAL.ps1"
start "" "%~dp0index.html"
