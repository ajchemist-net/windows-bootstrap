:_nvidia
@echo off
pushd %~dp0
setlocal enabledelayedexpansion
for /f %%a in ('dir /b /s nvidia\*.??_') do (
    set file=%%a
    expand -r !file!
    move /y !file:~0,-1! !file!
)
pause
exit
