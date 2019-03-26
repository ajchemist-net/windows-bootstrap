@echo off
cd /d %~dp0
for /f %%a in ('dir /b /s amd\*.??_') do (
    expand -r %%a
    del /q %%a
)
pause
exit
