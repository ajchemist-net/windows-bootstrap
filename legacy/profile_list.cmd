@echo off
@cls
@setlocal EnableDelayedExpansion

@set DataDrive=D:
@set HKLMProfileList="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList"
@vol %DataDrive% || goto :NOT_FOUND

@echo === Make Debug data point ===
@set DebugDir=%DataDrive%\bootstrap
@set DebugPoint=%DebugDir%\ProfileList.reg
@mkdir %DebugDir%
if exist %DebugPoint% (
    goto :ALREADY_DONE
)
@echo.

@echo === ProfileList Current ===
@reg query %HKLMProfileList% /f "*" /d
@reg export %HKLMProfileList% %DebugPoint%
@echo.
rem reg query %HKLMProfileList%
rem reg query %HKLMProfileList% /s
rem reg query %HKLMProfileList% /f "Default"

@echo === ProfileList Modification ===
@reg add %HKLMProfileList% /f /v Default           /t REG_EXPAND_SZ /d %DataDrive%\Users\Default
@reg add %HKLMProfileList% /f /v ProfilesDirectory /t REG_EXPAND_SZ /d %DataDrive%\Users
@reg add %HKLMProfileList% /f /v ProgramData       /t REG_EXPAND_SZ /d %DataDrive%\ProgramData
@reg add %HKLMProfileList% /f /v Public            /t REG_EXPAND_SZ /d %DataDrive%\Users\Public
@echo.

@echo === ProfileList Changed ===
@reg query %HKLMProfileList% /f "*" /d
@echo.
goto :SUCCESS

:ALREADY_DONE
@echo ALREADY_DONE.
@timeout /t 6
goto :END

:NOT_FOUND
@echo DataDrive %DataDrive% not found.
@timeout /t 6
goto :END
rem pause

:SUCCESS
@echo === Robocopy ===
@rmdir /s /q %DataDrive%\Users       > NUL
@rmdir /s /q %DataDrive%\ProgramData > NUL
@mkdir %DataDrive%\Users             > NUL
@mkdir %DataDrive%\ProgramData       > NUL
@robocopy %SystemDrive%\Users       %DataDrive%\Users       /mt:10 /e /copyall /xj /r:0 /LOG^+:%DebugDir%\ProfileList.Users.robocopy.txt
@robocopy %SystemDrive%\ProgramData %DataDrive%\ProgramData /mt:10 /e /copyall /xj /r:0 /LOG^+:%DebugDir%\ProfileList.ProgramData.robocopy.txt
rem @rmdir /s /q %SystemDrive%\Users
rem @rmdir /s /q %SystemDrive%\ProgramData

:END
@endlocal
@echo on
