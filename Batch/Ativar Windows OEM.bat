@echo off
::
================================================================================
:: NOME   : Ativar Windows 
:: AUTOR  : Ivo "Sir Ti_Rex" Dias
:: VERSAO : 2.0
::
================================================================================

:: Configurações de tela.
:mode

echo off
title Ativar Windows.
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
echo.Ativar Windows.
echo.
echo.%*
echo.

goto :eof
::
=================================================================================

:: Verificando permissão de Administrador.
::
=================================================================================
:permission
openfiles>nul 2>&1
 
if %errorlevel% EQU 0 goto terms
 
call :print Verique se executou o programa como Administrador.

echo.    Voce nao executou como Administrador.
echo.    Essa ferramenta nao vai ser efetiva sem isso.
echo.
echo.    Aperte com o botao direito e selecione Executar como Administrador.
echo.
echo.Aperte alguma tecla para continuar. . .
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
echo.    Nao eh possivel acentuar no CMD, em caso de outras duvidas sobre a aplicacao
echo.    enviar e-mail para IGD753@OUTLOOK.COM.BR com o assunto WinAtv
echo.

choice /c YN /n /m "Voce deseja continuar? (Sim[Y]/Nao[N]) "
if %errorlevel% EQU 1 goto MENU
if %errorlevel% EQU 2 goto Close
echo.
echo.Um erro ocorreu.
echo.
echo.Aperte alguma tecla para continuar . . .
pause>nul
goto :eof

:: Menu de ferramentas.
:: /*************************************************************************************/
:Menu
call :print Menu.

echo.     1. Ativar o Windows.
echo.     2. Localizar chave(Win 8 ou superior).
echo.     3. Encerrar.
echo.

set /p option=Escolha uma opcao: 

if %option% EQU 1 (
    call :ATV
) else if %option% EQU 2 (
    call :DPK
) else if %option% EQU 3 (
    goto Close
) else (
    echo.
    echo.Opcao invalida.
    echo.
    echo.Aperte alguma tecla para continuar . . .
    pause>nul
)

goto Menu
:: /*************************************************************************************/

::
=================================================================================

:: Ativar Win
:ATV
set /p CHAVE=Informe a chave do Windows(Formato XXXXX-XXXXX-XXXXX-XXXXX-XXXXX)
call :print Removendo ativacao anterior...
Slmgr.vbs -cpky
Net stop sppsvc 
CD C:\Windows\System32\SPP\Store\2.0
Ren Tokens.dat Tokens.old
slmgr.vbs -rilc
slmgr.vbs -upk

call :print Ativando...
slmgr.vbs -ipk %CHAVE% 
Net start sppsvc

  

:: Encerrando.
call :print O procedimento foi completado.
echo.Aperte alguma tecla para encerrar . . .
pause>nul
goto :eof

::Localizar chave DPK
:DPK
call :print Coletar chave:
echo. Vai ser aberta uma tela do Prompt de Comando
echo. Nela precisa utilizar dois comandos
echo. Eles estao disponiveis no arquivo Readme.
pause>nul
start cmd
echo.Verifique sua chave no arquivo CHAVE.txt na area de trabalho. 
echo.Aperte alguma tecla para encerrar . . .
pause>nul
goto :eof