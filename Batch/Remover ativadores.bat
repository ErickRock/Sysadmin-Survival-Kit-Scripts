echo off
:: Proteção contra Pirataria.
color 2
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

call :print Redefinindo ativacao. . .
SLMGR -cpky /f
SLMGR -upk /f
SLMGR -rilc /f
SLMGR -rearm /f

:: Encerrando.
call :print O procedimento foi completado com sucesso.
echo.Reinicie para aplicar as correcoes 
echo.Aperte alguma tecla para encerrar . . .
pause>nul
goto :eof