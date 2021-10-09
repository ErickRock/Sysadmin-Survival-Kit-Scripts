@ECHO OFF
:: NOME   : Reparo completo do Windows 
:: AUTOR  : Erick Garcia Godoy
:: VERSAO : Enterprise Release Slim
title Reparo completo do Windows
color 2
DISM.exe /Online /Cleanup-image /Scanhealth
Dism.exe /Online /Cleanup-Image /CheckHealth
Dism.exe /Online /Cleanup-Image /SpSuperseded
Dism.exe /Online /Cleanup-Image /startComponentCleanup
DISM.exe /Online /Cleanup-image /Restorehealth
sfc /scannow
chkdsk /r /f
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc
Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"
Del c:\windows\SoftwareDistribution /f
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
cd /d %windir%\system32
esentutl /d %windir%\softwaredistribution\datastore\datastore.edb
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f 
reg delete "HKLM\COMPONENTS\PendingXmlIdentifier" /f 
reg delete "HKLM\COMPONENTS\NextQueueEntryIndex" /f 
reg delete "HKLM\COMPONENTS\AdvancedInstallersNeedResolving" /f 
del %TEMP%\*.* /s /f /q *.*
call :print Protegendo o computador contra Softwares ilicitos . . .
taskkill /f /im KMSPico.exe /t
taskkill /f /im AutoKMS.exe /t
if exist "%ProgramFiles%\KMSpico" (
    takeown /f "%ProgramFiles%\KMSpico"
    attrib -r -s -h /s /d "%ProgramFiles%\KMSpico"
    rmdir /s /q "%ProgramFiles%\KMSpico"
) else if exist "C:\Windows\AutoKMS" (
    takeown /f "C:\Windows\AutoKMS"
    attrib -r -s -h /s /d "C:\Windows\AutoKMS"
    rmdir /s /q "C:\Windows\AutoKMS"
)
if exist "C:\Windows\KMSPico" (
    takeown /f "C:\Windows\KMSPico"
    attrib -r -s -h /s /d "C:\Windows\KMSPico"
    rmdir /s /q "C:\Windows\KMSPico"
) else if exist "C:\Windows\System32\Tasks\AutoKMS" (
    takeown /f "C:\Windows\System32\Tasks\AutoKMS"
    attrib -r -s -h /s /d "C:\Windows\System32\Tasks\AutoKMS"
    rmdir /s /q "C:\Windows\System32\Tasks\AutoKMS"
)
ipconfig /release
ipconfig /renew
ipconfig /flushdns
Netsh winsock reset
nbtstat -rr 
net localgroup administradores localservice /add
fsutil resource setautoreset true C:\
netsh int ip reset resetlog.txt  
netsh winsock reset all
netsh int 6to4 reset all
Netsh int ip reset all
netsh int ipv4 reset all
netsh int ipv6 reset all
netsh int httpstunnel reset all
netsh int isatap reset all
netsh int portproxy reset all
netsh int tcp reset all
netsh int teredo reset all
sc config wuauserv start= auto
sc config bits start= auto
sc config DcomLaunch start =auto
set key=HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX 
call :addReg "%key%" "IsConvergedUpdateStackEnabled" "REG_DWORD" "0" 
set key=HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings 
call :addReg "%key%" "UxOption" "REG_DWORD" "0" 
set key=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders 
call :addReg "%key%" "AppData" "REG_EXPAND_SZ" "%USERPROFILE%\AppData\Roaming" 
set key=HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders 
call :addReg "%key%" "AppData" "REG_EXPAND_SZ" "%USERPROFILE%\AppData\Roaming" 
set key=HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders 
call :addReg "%key%" "AppData" "REG_EXPAND_SZ" "%USERPROFILE%\AppData\Roaming" 
set key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate 
call :addReg "%key%" "AllowOSUpgrade" "REG_DWORD" "1" 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\BackupRestore\FilesNotToBackup" /f 
set key=HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains 
call :addReg "%key%\microsoft.com\update" "http" "REG_DWORD" "2" 
call :addReg "%key%\microsoft.com\update" "https" "REG_DWORD" "2" 
call :addReg "%key%\microsoft.com\windowsupdate" "http" "REG_DWORD" "2" 
call :addReg "%key%\update.microsoft.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\update.microsoft.com" "https" "REG_DWORD" "2" 
call :addReg "%key%\windowsupdate.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\windowsupdate.microsoft.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\download.microsoft.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\windowsupdate.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\windowsupdate.com" "https" "REG_DWORD" "2" 
call :addReg "%key%\windowsupdate.com\download" "http" "REG_DWORD" "2" 
call :addReg "%key%\windowsupdate.com\download" "https" "REG_DWORD" "2" 
call :addReg "%key%\download.windowsupdate.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\download.windowsupdate.com" "https" "REG_DWORD" "2" 
call :addReg "%key%\windows.com\wustat" "http" "REG_DWORD" "2" 
call :addReg "%key%\wustat.windows.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\microsoft.com\ntservicepack" "http" "REG_DWORD" "2" 
call :addReg "%key%\ntservicepack.microsoft.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\microsoft.com\ws" "http" "REG_DWORD" "2" 
call :addReg "%key%\microsoft.com\ws" "https" "REG_DWORD" "2" 
call :addReg "%key%\ws.microsoft.com" "http" "REG_DWORD" "2" 
call :addReg "%key%\ws.microsoft.com" "https" "REG_DWORD" "2"
regsvr32.exe atl.dll /s
regsvr32.exe urlmon.dll /s
regsvr32.exe mshtml.dll /s
regsvr32.exe shdocvw.dll /s
regsvr32.exe browseui.dll /s
regsvr32.exe jscript.dll /s
regsvr32.exe vbscript.dll /s
regsvr32.exe scrrun.dll /s
regsvr32.exe msxml.dll /s
regsvr32.exe msxml3.dll /s
regsvr32.exe msxml6.dll /s
regsvr32.exe actxprxy.dll /s
regsvr32.exe softpub.dll /s
regsvr32.exe wintrust.dll /s
regsvr32.exe dssenh.dll /s
regsvr32.exe rsaenh.dll /s
regsvr32.exe gpkcsp.dll /s
regsvr32.exe sccbase.dll /s
regsvr32.exe slbcsp.dll /s
regsvr32.exe cryptdlg.dll /s
regsvr32.exe oleaut32.dll /s
regsvr32.exe ole32.dll /s
regsvr32.exe shell32.dll /s
regsvr32.exe initpki.dll /s
regsvr32.exe wuapi.dll /s
regsvr32.exe wuaueng.dll /s
regsvr32.exe wuaueng1.dll /s
regsvr32.exe wucltui.dll /s
regsvr32.exe wups.dll /s
regsvr32.exe wups2.dll /s
regsvr32.exe wuweb.dll /s
regsvr32.exe qmgr.dll /s
regsvr32.exe qmgrprxy.dll /s
regsvr32.exe wucltux.dll /s
regsvr32.exe muweb.dll /s
regsvr32.exe wuwebv.dll /s
netsh winsock reset
netsh winhttp reset proxy
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc