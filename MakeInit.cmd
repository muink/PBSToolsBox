:: PBSToolsBox
:: Portable System ToolsBox For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

pushd %~1
:--init--
set "BIN=%~dp0Bin"
set "TARGET=%~dp0Menu"
set "LKGEN=%~dp0Menu\LinkGen"

set SYS=System
set USER=User
set "KEY=Disk=8;Down=122;Edit=259;Hard=21;Media=301;Net=13;Other=23;Safe=47;Shell=24;Store=258;Sys=imageres.dll:56;Virtual=11"

:--bin--
md "%BIN%" 2>nul || goto :--target--
setlocal enabledelayedexpansion
:--bin--#loop
for /f "tokens=1* delims=;" %%i in ("!KEY!") do (
	for /f "tokens=1,2 delims==" %%k in ("%%i") do call:[MKKEY] "%BIN%" "%%~k" "%%~l"
	set "KEY=%%j"
	goto :--bin--#loop
)
endlocal

:--target--
md "%TARGET%" 2>nul && (
	call:[WTini] "%TARGET%" "" 300
	md "%TARGET%\%SYS%"  2>nul && call:[WTini] "%TARGET%\%SYS%"  "" 298
	md "%TARGET%\%USER%" 2>nul && call:[WTini] "%TARGET%\%USER%" "" 298
	md "%LKGEN%" 2>nul && call:[WTini] "%LKGEN%" "" 263
)
call:[CheckKEY] "%TARGET%\%SYS%"
call:[CheckKEY] "%TARGET%\%USER%"

:--template--
if exist "%~dp0One-off_Run.cmd" (
	call "%~dp0One-off_Run.cmd" "%~1"
	del /f /q "%~dp0One-off_Run.cmd" >nul 2>nul
)

popd & goto :eof



:[WTini]
setlocal enabledelayedexpansion
set "icolib=%~2"
if "%icolib%" == "" set "icolib=SHELL32.dll"
set "pa=%~1"
(echo.[.ShellClassInfo]
echo.IconResource=%SystemRoot%\system32\%icolib%,%~3)>"%pa%\desktop.ini"
attrib +r "%pa%"
attrib +s +h "%pa%\desktop.ini"
endlocal
goto :eof

:[MKKEY]
setlocal enabledelayedexpansion
set "pa=%~1\%~2Tools"
set "key=%~2"
set "value=%~3"
set "value2=%value::=" "%"
if "%value%" == "%value2%" set value2=" "%value%
md "%pa%" 2>nul
call:[WTini] "%pa%" "%value2%"
endlocal
goto :eof

:[CheckKEY]
pushd "%~1"
for /f "delims=" %%i in ('dir /a:d /b "%BIN%" 2^>nul') do md "%%~i" 2>nul && (
	mklink /h "%%~i\desktop.ini" "%BIN%\%%~i\desktop.ini" >nul 2>nul
	attrib +r "%%~i"
)
popd
goto :eof
