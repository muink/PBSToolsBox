:: PBSToolsBox
:: Portable System ToolsBox For Windows
:: Author: muink

@echo off
%~1 mshta vbscript:createobject("shell.application").shellexecute("%~f0","::","","runas",1)(window.close)&exit

:Init
cd /d %~dp0
call .\MakeInit.cmd "%~dp0"
set NAME=PBSToolsBox
set "LINKSYSPATH=%AllUsersProfile%\Microsoft\Windows\Start Menu\Programs"
set "LINKUSERPATH=%AppData%\Microsoft\Windows\Start Menu\Programs"

set FORSYS=1
set FORUSER=<nul

:Create_New_Menu_Links
if defined FORSYS (
	rd /s /q "%LKGEN%\%SYS%" >nul 2>nul & md "%LKGEN%\%SYS%" 2>nul && attrib +r "%LKGEN%\%SYS%"
	dir /a:l /b "%LINKSYSPATH%" | find "%NAME%" >nul 2>nul && rd /q "%LINKSYSPATH%\%NAME%" 2>nul
	mklink /d "%LINKSYSPATH%\%NAME%" "%LKGEN%\%SYS%" 2>nul && attrib +r "%LINKSYSPATH%\%NAME%"
)
if defined FORUSER (
	rd /s /q "%LKGEN%\%USER%">nul 2>nul & md "%LKGEN%\%USER%" 2>nul && attrib +r "%LKGEN%\%USER%"
	dir /a:l /b "%LINKUSERPATH%" | find "%NAME%" >nul 2>nul && rd /q "%LINKUSERPATH%\%NAME%" 2>nul
	mklink /d "%LINKUSERPATH%\%NAME%" "%LKGEN%\%USER%" 2>nul && attrib +r "%LINKUSERPATH%\%NAME%"
)

:Gen_Menu_List
if defined FORSYS (
	call:[GenDir]      "%TARGET%\%SYS%" "%LKGEN%\%SYS%"
	call:[GenLink]     "%TARGET%\%SYS%" "%LKGEN%\%SYS%"
	call:[GenShortcut] "%TARGET%\%SYS%" "%LKGEN%\%SYS%"
)
if defined FORUSER (
	call:[GenDir]      "%TARGET%\%USER%" "%LKGEN%\%USER%"
	call:[GenLink]     "%TARGET%\%USER%" "%LKGEN%\%USER%"
	call:[GenShortcut] "%TARGET%\%USER%" "%LKGEN%\%USER%"
)

:Gen_UOSMenu_Shortcut
call:[MKlnk] "%TARGET%\#%SYS%Menu"  "%%%%AllUsersProfile%%%%\Microsoft\Windows\Start Menu\Programs" 2>nul
call:[MKlnk] "%TARGET%\#%USER%Menu" "%%%%AppData%%%%\Microsoft\Windows\Start Menu\Programs" 2>nul

goto :eof


:[GenDir]
setlocal enabledelayedexpansion
set "target=%~1"
set "linkgen=%~2"
set "dir="
pushd "%target%"
for /f "delims=" %%i in ('dir /a:d /b /s 2^>nul') do (
	set "dir=%%~i"
	md "%linkgen%!dir:%target%=!" 2>nul
	attrib +r "%linkgen%!dir:%target%=!"
)
popd & endlocal
goto :eof

:[GenLink]
setlocal enabledelayedexpansion
set link=hardlink
set "target=%~1"
set "linkgen=%~2"
set "file="
pushd "%target%"
for /f "delims=" %%i in ('dir /a-d /b /s desktop.ini 2^>nul') do (
	set "file=%%~i"
	if %link% == hardlink mklink /h "%linkgen%!file:%target%=!" "!file!" >nul 2>nul
	if %link% == symlink  mklink    "%linkgen%!file:%target%=!" "!file!" >nul 2>nul
)
popd & endlocal
goto :eof

:[GenShortcut]
setlocal enabledelayedexpansion
set "target=%~1"
set "linkgen=%~2"
set "symlnk="
set "symlnkdir="
set "symlnkname="
set "orig="
pushd "%target%"
for /f "delims=" %%i in ('dir /a:l /b /s 2^>nul') do (
	set "symlnk=%%~i"
	set "symlnkdir=%%~dpsi"
	set "symlnkname=%%~nsi"
	for /f "tokens=2 delims=[]" %%i in ('dir /a:l /x "!symlnk!" ^| find "!symlnkname!" 2^>nul') do set "orig=!symlnkdir!%%~i"
	call:[MKlnk] "%linkgen%!symlnk:%target%=!" "!symlnk!" "" "!orig!" "!orig!"
)
popd & endlocal
goto :eof

:[MKlnk]
set "shortcut=%~1.lnk"
set "symlnk=%~2"

set "args=%~3"
set "workdir=%~dp4"
set "icon=%~fs5,0"
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(""%shortcut%""):b.TargetPath=""%symlnk%"":b.WorkingDirectory=""%workdir%"":b.IconLocation=""%icon%"":b.Save:close")
goto :eof





批处理创建快捷方式
==================

``` batch
set "SrcFile=%SystemRoot%\system32\shutdown.exe"
set "Args=-s -t 2"
set "LnkFile=关机.lnk"
set "IconPath=C:\1.ico"
call :CreateShort "%SrcFile%" "%Args%" "%LnkFile%" "%IconPath%"
goto :eof

::Arguments              目标程序参数
::Description            快捷方式备注
::FullName               返回快捷方式完整路径
::Hotkey                 快捷方式快捷键
::IconLocation           快捷方式图标，不设则使用默认图标
::TargetPath             目标
::WindowStyle            窗口启动状态
::WorkingDirectory       起始位置

:CreateShort
mshta VBScript:Execute("Set a=CreateObject(""WScript.Shell""):Set b=a.CreateShortcut(a.SpecialFolders(""DeskTop"") & ""\%~3""):b.TargetPath=""%~1"":b.WorkingDirectory=""%~dp1"":b.Arguments=""%~2"":b.IconLocation=""%~4"":b.Save:close")
```

參考
----

[批处理如何在桌面创建目标程序带参数的快捷方式？](http://www.bathome.net/thread-33196-1-1.html)  
[批处理创建快捷方式](https://peach.oschina.io/post/%E6%89%B9%E5%A4%84%E7%90%86_%E5%88%9B%E5%BB%BA%E5%BF%AB%E6%8D%B7%E6%96%B9%E5%BC%8F/)  
