@echo off

call sys32\registry.cmd


if not "%1"=="" (
goto %1
)

if not "%act%"=="ok" (
cls
insertbmp.exe /p:"pic\sys\ctrl-panel.bmp" /x:0 /y:0 /z:100
call clean-api.bat

set msgt=ERR: W-OS update center
set msg1=you need to activate W-OS
set msg2=first before you can update W-OS!
set b1=ok
call api.bat
exit /b
)

cls


if .%WUP-autoexec%.==.true. (
del autoexec.cmd
)

:st

cls

insertbmp.exe /p:"pic\WUP\back.bmp" /x:0 /y:0 /z:100

call clean-api.bat

set msgt=W-OS update center
set msg1=Welcome!
set msg3=chose an option:
set exapi=ok
set b1=check
set b2=info
set b3=options

call api.bat

if "%preb%"=="b3" (
goto op
)

if "%preb%"=="b1" (
goto chk
)


if "%preb%"=="b2" (
goto inf
)
if "%preb%"=="ex" (
exit /b
)


goto st

:chk

echo set "wup.l.chk=%date%\%time:~0,5%">>sys32\registry.cmd

call clean-api.bat

set msgt=W-OS update center
set msg1=How do you want to install your
set msg2=W-OS update?
set b1=online
set b3=offline

call api.bat

if "%preb%"=="b1" (
goto online_chk
)

call api.bat

if not exist update.cmd (
	cls
	insertbmp.exe /p:"pic\WUP\back.bmp" /x:0 /y:0 /z:100
	call clean-api.bat
	set sound=error
	set msgt=W-OS update center
	set msg1=No updates\service packs found.
	set b1=ok
	call api.bat
	goto st
)

call update.cmd
call w-OS restart
exit /b

:inf

call clean-api.bat

set msgt=W-OS update center
set msg1=last check: %WUP.l.chk%
set msg2=last updated: %wup.l.up%
set msg4=version: %ver%
set b2=ok

call api.bat

cls

insertbmp.exe /p:"pic\WUP\H.bmp" /x:0 /y:0 /z:100
pause >nul

call sys32\sys\ver.cmd
goto st

:online_chk

call clean-api.bat

set msgt=W-OS update center
set msg1=searching...
set b4=disable
call api.bat

if exist update.zip (
del update.zip
)

aria2c https://github.com/UU-Co/W-OS-update/blob/main/update.zip?raw=true >nul

if not "%errorlevel%"=="0" (
goto down.fail
)

7z x update.zip -y >nul

set up.ver=0

call up_source\update.cmd ver_chk

if %up.ver% lss %ver:~0,4% (
goto fail
)

call up_source\update.cmd

exit /b

:fail

call clean-api.bat

set msgt=W-OS update center
set msg1=your system is already up to date!
set b2=ok
set sound=warn

call api.bat

goto st

:silent_CHK

if not "%act%"=="ok" (
exit /b
)

if "%autoup%"=="disable" (exit /b)

set "boot.str=checking for updates..."
set "boot.repeat=1"
call w-os boot.anim
cls
color 07
echo getting informations...
echo.
echo.
echo to disable 'checking for updates at start' go to the options menu in W-OS update.

if exist update.zip (
del update.zip
)

aria2c https://github.com/UU-Co/W-OS-update/blob/main/update.zip?raw=true >nul

7z x update.zip -y >nul

set up.ver=0

call up_source\update.cmd ver_chk

if %up.ver% lss %ver:~0,4% (
exit /b
)

if %up.ver% equ %ver:~0,4% (
exit /b
)

call clean-api.bat

set msgt=W-OS update check
set msg1=there is an update aviable!
set msg2=would you like to install it?
set b1=yes
set b3=no
set sound=warn

call api.bat

if "%preb%"=="b3" (
exit /b
)

call up_source\update.cmd

exit /b

:op

call clean-api.bat
call sys32\registry.cmd

set msgt=W-OS update center

if "%autoup%"=="ok" (
set msg1=checking for updates at logon: yes
) else (
set msg1=checking for updates at logon: no
)

set b1=toggle
set b2=ok


call api.bat

if "%preb%"=="b2" (
goto st
)


if "%autoup%"=="ok" (
echo set autoup=disable>>sys32\registry.cmd
) else (
echo set autoup=ok>>sys32\registry.cmd
)

goto op

:down.fail

call clean-api.bat

set msgt=W-OS update center
set msg1=could not download the update
set msg2=files...
set b2=ok
set sound=error
set pic=warn

call api.bat

goto st


