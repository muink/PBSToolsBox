:: PBSToolsBox
:: Portable System ToolsBox For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

:init
pushd %~dp0Core
set "X64Paa=%~dp0Core\7za\x64"
set "X86Paa=%~dp0Core\7za"
set "Paa=%X64Paa%"

if "%processor_architecture%" == "x86" (
	set "Paa=%X86Paa%"
	if exist "%windir%\SysWOW64" "%windir%\SysNative\cmd" /c %~f0 & exit
)
set "path=%path%;%Paa%"

:main
set PKG=template
7za x "%~dp0Core\%PKG%.7z" -y >nul

xcopy "%PKG%\BOOTICE" "%BIN%\SysTools\BOOTICE" /i /s /y >nul
md "%TARGET%\%SYS%\SysTools\BOOTICE" 2>nul
mklink "%TARGET%\%SYS%\SysTools\BOOTICE\BOOTICE (64bit)" "..\..\..\..\Bin\SysTools\BOOTICE\1.3.4.0\BOOTICEx64.exe"
mklink "%TARGET%\%SYS%\SysTools\BOOTICE\BOOTICE (32bit)" "..\..\..\..\Bin\SysTools\BOOTICE\1.3.4.0\BOOTICEx86.exe"

xcopy "%PKG%\NatTypeTester" "%BIN%\NetTools\NatTypeTester" /i /s /y >nul
md "%TARGET%\%SYS%\NetTools\NatTypeTester" 2>nul
mklink "%TARGET%\%SYS%\NetTools\NatTypeTester\NatTypeTester" "..\..\..\..\Bin\NetTools\NatTypeTester\NatTypeTester.exe"

popd
rd /s /q "%~dp0Core" 2>nul
