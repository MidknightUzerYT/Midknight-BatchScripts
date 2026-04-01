@echo off
setlocal EnableDelayedExpansion

:: ===== SETTINGS =====
set "wallpaperDir=C:\Wallpapers"
set "counterFile=%wallpaperDir%\counter.txt"
set max=10
:: ====================

if not exist "%wallpaperDir%" exit

if not exist "%counterFile%" (
    echo 0 > "%counterFile%"
)

set /p current=<"%counterFile%"
set /a next=current+1
if !next! GTR !max! set next=1
echo !next! > "%counterFile%"

set "newWallpaper=%wallpaperDir%\!next!.jpg"

if not exist "!newWallpaper!" exit

:: Apply wallpaper
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "!newWallpaper!" /f >nul

powershell -NoProfile -Command ^
"Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public class W { [DllImport(\"user32.dll\",SetLastError=true)] public static extern bool SystemParametersInfo(int a,int b,string c,int d);}'; [W]::SystemParametersInfo(20,0,'!newWallpaper!',3)"

timeout /t 1 >nul

endlocal
exit