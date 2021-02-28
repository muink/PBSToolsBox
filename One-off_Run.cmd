:: PBSToolsBox
:: Portable System ToolsBox For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

set "coredir=%~dp0Core"
pushd %coredir%
:init
set "jzBX64=%coredir%\7za\x64"
set "jzBX86=%coredir%\7za"
set "jzB=%jzBX64%"

if "%processor_architecture%" == "x86" (
	set "jzB=%jzBX86%"
	if exist "%windir%\SysWOW64" "%windir%\SysNative\cmd" /c ""%~f0" "%coredir%"" & exit
)
if "%path:~-1%" == ";" (set "path=%path%%jzB%") else (set "path=%path%;%jzB%")

:main
set PKG=template
7za x "%coredir%\%PKG%.7z" -y >nul

xcopy "%PKG%\BOOTICE" "%BIN%\SysTools\BOOTICE" /i /s /y >nul
md "%TARGET%\%SYS%\SysTools\BOOTICE" 2>nul
mklink "%TARGET%\%SYS%\SysTools\BOOTICE\BOOTICE (64bit)" "..\..\..\..\Bin\SysTools\BOOTICE\1.3.4.0\BOOTICEx64.exe"
mklink "%TARGET%\%SYS%\SysTools\BOOTICE\BOOTICE (32bit)" "..\..\..\..\Bin\SysTools\BOOTICE\1.3.4.0\BOOTICEx86.exe"

xcopy "%PKG%\NatTypeTester" "%BIN%\NetTools\NatTypeTester" /i /s /y >nul
md "%TARGET%\%SYS%\NetTools\NatTypeTester" 2>nul
mklink "%TARGET%\%SYS%\NetTools\NatTypeTester\NatTypeTester" "..\..\..\..\Bin\NetTools\NatTypeTester\NatTypeTester.exe"

popd
rd /s /q "%coredir%" 2>nul
