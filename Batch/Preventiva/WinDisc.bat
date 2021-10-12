@echo off
::
================================================================================
:: NOME   : Disco 100% 
:: AUTOR  : Erick Garcia Godoy
:: VERSAO : 1.0
::
================================================================================

:: Configura��es de tela.
:mode

echo off
title Corrigir Disco.
color 97

goto permission
::
=================================================================================

:: Escrever no alto da tela.
::
=================================================================================
:print
cls
echo.
echo.Corrigir Disco.
echo.
echo.%*
echo.

goto :eof
::
=================================================================================

:: Verificando permiss�o de Administrador.
::
=================================================================================
:permission
openfiles>nul 2>&1
 
if %errorlevel% EQU 0 goto terms
 
call :print Verique se executou o programa como Administrador.

echo.    Voce nao executou como Administrador.
echo.    Essa ferramenta nao será efetiva sem isso.
echo.
echo.    Pressione com o botao direito e selecione Executar como Administrador.
echo.
echo.Pressione alguma tecla para continuar. . .
pause>nul
goto :eof

::
=================================================================================

:: Termos.
::
=================================================================================
:terms
call :print Termos de uso.

echo.    Essa ferramenta modifica arquivos e o registro do sistema.
echo.    Nao nos responsabilizamos pelo uso da ferramenta, em caso de duvidas
echo.    seguir as orientacoes na pagina da Microsoft.
echo.    Voce eh livre para aprimorar esse codigo.
echo.

choice /c YN /n /m "Voce deseja continuar? (Sim[Y]/Nao[N]) "
if %errorlevel% EQU 1 goto RedWin
if %errorlevel% EQU 2 goto Close

echo.
echo.Um erro ocorreu.
echo.
echo.Pressione alguma tecla para continuar . . .
pause>nul
goto :eof

::
=================================================================================

:: Redefinir Win
:RedWin
call :print Parando servicos...
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc
Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"

sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)

sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)

call :print Renomeando pastas...
Ren %systemroot%\SoftwareDistribution SoftwareDistribution.bak
Ren %systemroot%\system32\catroot2 catroot2.bak

cd /d %windir%\system32

call :print Redefinindo DataStore...
esentutl /d %windir%\softwaredistribution\datastore\datastore.edb

call :print Removendo chaves do registro...
reg�delete�"HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"�/f�
reg�delete�"HKLM\COMPONENTS\PendingXmlIdentifier"�/f�
reg�delete�"HKLM\COMPONENTS\NextQueueEntryIndex"�/f�
reg�delete�"HKLM\COMPONENTS\AdvancedInstallersNeedResolving"�/f�

call :print Inserindo chaves do registro...
set�key=HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX�
call�:addReg�"%key%"�"IsConvergedUpdateStackEnabled"�"REG_DWORD"�"0"�
set�key=HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings�
call�:addReg�"%key%"�"UxOption"�"REG_DWORD"�"0"�
set�key=HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User�Shell�Folders�
call�:addReg�"%key%"�"AppData"�"REG_EXPAND_SZ"�"%USERPROFILE%\AppData\Roaming"�
set�key=HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\User�Shell�Folders�
call�:addReg�"%key%"�"AppData"�"REG_EXPAND_SZ"�"%USERPROFILE%\AppData\Roaming"�
set�key=HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\User�Shell�Folders�
call�:addReg�"%key%"�"AppData"�"REG_EXPAND_SZ"�"%USERPROFILE%\AppData\Roaming"�
set�key=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate�
call�:addReg�"%key%"�"AllowOSUpgrade"�"REG_DWORD"�"1"�
reg�add�"HKLM\SYSTEM\CurrentControlSet\Control\BackupRestore\FilesNotToBackup"�/f�
set�key=HKLM\Software\Microsoft\Windows\CurrentVersion\Internet�Settings\ZoneMap\Domains�
call�:addReg�"%key%\microsoft.com\update"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\microsoft.com\update"�"https"�"REG_DWORD"�"2"�
call�:addReg�"%key%\microsoft.com\windowsupdate"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\update.microsoft.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\update.microsoft.com"�"https"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windowsupdate.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windowsupdate.microsoft.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\download.microsoft.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windowsupdate.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windowsupdate.com"�"https"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windowsupdate.com\download"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windowsupdate.com\download"�"https"�"REG_DWORD"�"2"�
call�:addReg�"%key%\download.windowsupdate.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\download.windowsupdate.com"�"https"�"REG_DWORD"�"2"�
call�:addReg�"%key%\windows.com\wustat"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\wustat.windows.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\microsoft.com\ntservicepack"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\ntservicepack.microsoft.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\microsoft.com\ws"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\microsoft.com\ws"�"https"�"REG_DWORD"�"2"�
call�:addReg�"%key%\ws.microsoft.com"�"http"�"REG_DWORD"�"2"�
call�:addReg�"%key%\ws.microsoft.com"�"https"�"REG_DWORD"�"2"

call :print Instalando DLLs...
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

:: Removendo arquivos temporarios do Windows.
call :print Removendo arquivos temporarios do Windows . . .
cd /d %TEMP%
del /s /f /q *.*

call :print Ativando servicos...
netsh winsock reset
netsh winhttp reset proxy
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc

call :print Ativando remo��o de paginacao ao reiniciar...�
REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileATShutdown /t REG_DWORD /d 1 /f


call :print Verificacao de integridade...
sfc /scannow

:: Encerrando.
call :print O procedimento foi completado com sucesso.

echo.Pressione alguma tecla para encerrar . . .
pause>nul
goto :eof


