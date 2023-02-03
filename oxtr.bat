@echo off
set Version=1
setlocal EnableDelayedExpansion

curl -g -k -L -# -o "%tmp%\update.bat" "https://raw.githubusercontent.com/UnLovedCookie/EchoX/main/Files/lightVersion" 2>&1
call "%tmp%\update.bat"
if "%Version%" lss "!update!" (cls
curl -L -o "%~s0" "https://github.com/reative/Oxygen/blob/main/oxtr.bat" 2>&1
call "%~s0"
)

:Optimize
Reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d 1 /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d 1 /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "DisableHHDEP" /t REG_DWORD /d 1 /f
Reg add "HKLM\Software\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f
Reg add "HKLM\Software\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f
Reg add "HKLM\Software\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f
call :ControlSet "Control\Session Manager\kernel" "DisableExceptionChainValidation" "1"
call :ControlSet "Control\Session Manager\kernel" "KernelSEHOPEnabled" "0"
call :ControlSet "Control\Session Manager\Memory Management" "EnableCfg" "0"
call :ControlSet "Control\Session Manager" "ProtectionMode" "0"
call :ControlSet "Control\Power" "HibernateEnabled" "0"
powercfg /h off
fsutil behavior set memoryusage 2
fsutil behavior set mftzone 2
call :ControlSet "Services\GpuEnergyDrv" "Start" "4"

exit /b

:ControlSet
Reg add "HKLM\System\CurrentControlSet\%~1" /v "%~2" /t REG_DWORD /d "%~3" /f
Reg add "HKLM\System\ControlSet001\%~1" /v "%~2" /t REG_DWORD /d "%~3" /f
Reg add "HKLM\System\ControlSet002\%~1" /v "%~2" /t REG_DWORD /d "%~3" /f
goto:EOF

:CurrentControlSet
set ControlSet=%1
Reg add !ControlSet! /v "%~2" /t REG_DWORD /d "%~3" /f
Reg add !ControlSet:CurrentControlSet=ControlSet001! /v "%~2" /t REG_DWORD /d "%~3" /f
Reg add !ControlSet:CurrentControlSet=ControlSet002! /v "%~2" /t REG_DWORD /d "%~3" /f
goto:EOF
