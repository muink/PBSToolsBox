:: PBSToolsBox
:: Portable System ToolsBox For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

set "nodedir=%~1"
pushd %nodedir%
:--init--
set "BIN=%nodedir%Bin"
set "TARGET=%nodedir%Menu"
set "LINKSYSPATH=%AllUsersProfile%\Microsoft\Windows\Start Menu\Programs"
set "LINKUSERPATH=%AppData%\Microsoft\Windows\Start Menu\Programs"

set ICOF=icon.ico
set SYS=System
set USER=User
set "KEY=Disk=8;Down=122;Edit=259;Hard=21;Media=324;Net=13;Other=23;Safe=47;Shell=24;Store=258;Sys=imageres.dll:56;Virtual=11"

:--icon--
if not exist desktop.ini call:[WTini] "%cd%" "?%ICOF%" "0"
find "%ICOF%" desktop.ini >nul 2>nul || call:[WTini] "%cd%" "?%ICOF%" "0"
attrib +s +h "%ICOF%" 2>nul

:--startmenu--
if defined FORSYS (
	if exist "%LINKSYSPATH%\%NAME%" (
		find "%NAME%.ico" "%LINKSYSPATH%\%NAME%\desktop.ini" >nul 2>nul || (
			::error
			echo."%LINKSYSPATH%\%NAME%" is exist, Please continue after deleting it manually
			ping -n 6 127.0.0.1 >nul
			explorer "%LINKSYSPATH%\%NAME%\.."
			set /p _=Press any key to confirm to continue x3...
			set /p _=Press any key to confirm to continue x2...
			set /p _=Press any key to confirm to continue x1...
	))
	::create
	rd /s /q "%LINKSYSPATH%\%NAME%" >nul 2>nul & md "%LINKSYSPATH%\%NAME%" 2>nul && attrib +r "%LINKSYSPATH%\%NAME%"
	del /f /q /a "%LINKSYSPATH%\%NAME%\%NAME%.ico" 2>nul
	null>"%LINKSYSPATH%\%NAME%\%NAME%.ico" 2>nul & xcopy /h /y "%ICOF%" "%LINKSYSPATH%\%NAME%\%NAME%.ico"
	call:[WTini] "%LINKSYSPATH%\%NAME%" "?%NAME%.ico" "0"
)
if defined FORUSER (
	if exist "%LINKUSERPATH%\%NAME%" (
		find "%NAME%.ico" "%LINKUSERPATH%\%NAME%\desktop.ini" >nul 2>nul || (
			::error
			echo."%LINKUSERPATH%\%NAME%" is exist, Please continue after deleting it manually
			ping -n 6 127.0.0.1 >nul
			explorer "%LINKUSERPATH%\%NAME%\.."
			set /p _=Press any key to confirm to continue x3...
			set /p _=Press any key to confirm to continue x2...
			set /p _=Press any key to confirm to continue x1...
	))
	::create
	rd /s /q "%LINKUSERPATH%\%NAME%" >nul 2>nul & md "%LINKUSERPATH%\%NAME%" 2>nul && attrib +r "%LINKUSERPATH%\%NAME%"
	del /f /q /a "%LINKUSERPATH%\%NAME%\%NAME%.ico" 2>nul
	null>"%LINKUSERPATH%\%NAME%\%NAME%.ico" 2>nul & xcopy /h /y "%ICOF%" "%LINKUSERPATH%\%NAME%\%NAME%.ico"
	call:[WTini] "%LINKUSERPATH%\%NAME%" "?%NAME%.ico" "0"
)

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
	call:[WTini] "%TARGET%" "" 323
	md "%TARGET%\%SYS%"  2>nul && call:[WTini] "%TARGET%\%SYS%"  "" 321
	md "%TARGET%\%USER%" 2>nul && call:[WTini] "%TARGET%\%USER%" "" 321
)
call:[CheckKEY] "%TARGET%\%SYS%"
call:[CheckKEY] "%TARGET%\%USER%"

:--template--
if exist "%~dp0One-off_Run.cmd" (
	call "%~dp0One-off_Run.cmd" "%nodedir%"
	del /f /q "%~dp0One-off_Run.cmd" >nul 2>nul
)

popd & goto :eof



:[WTini]
setlocal enabledelayedexpansion
set "icolib=%~2"
if "%icolib%" == "" set "icolib=SHELL32.dll"
set "icores=%%SystemRoot%%\system32\%icolib%"
if "%icolib:~0,1%" == "?" set "icores=%icolib:~1%"
set "pa=%~1"
del /f /q /a "%pa%\desktop.ini" 2>nul
(echo.[.ShellClassInfo]
echo.IconResource=%icores%,%~3)>"%pa%\desktop.ini"
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
