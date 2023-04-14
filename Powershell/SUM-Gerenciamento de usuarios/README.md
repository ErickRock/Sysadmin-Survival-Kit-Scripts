# SUM
 Sistema de gerenciamento de usuarios, criado para facilitar o processo de admissão e desligamento

## Como importar um modulo de Powershell? 
Dentro do Powershell, utilize os comandos:
``` Powershell
Set-ExecutionPolicy Bypass -force # Atribui a permissao
$modulo = "caminhoModulo\nomeModulo.psm1" # Define o caminho do modulo
Unblock-File -Path $modulo # Desbloqueia o arquivo
Import-Module $modulo -Force # Carrega o modulo
```


## Admissao 
* **Objetivo:**<br>
Automatizar o processo de admissão, focando na parte de gerenciamento dentro do AD e do portal do Office.
* **Como funciona?**<br>
Foi pensado como um conjunto de funções dentro de um modulo, em especial, temos uma função responsável pela criação dos usuários dentro do AD e que cria um arquivo com as informações para o licenciamento do Office, assunto tratado por outro script. <br>
Para funcionar, essa função principal recebe como parâmetros, informações sobre o usuário que vai ser criado, sendo todas de caráter obrigatório: 
 1. Primeiro Nome
 2. Sobrenome Completo
 3. Sobrenome para uso no e-mail (mantendo o formato nome.sobrenome)
 4. Usuário de referencia
 5. Tipo de contrato do usuário 
 6. Cargo
 7. Área <br>
Com essas informações, o usuário é criado no AD, com todas as configurações informadas no manual de criação de usuários. Ao final do procedimento, são gerados registros dentro de pastas estabelecidas no código. 
* **Como utilizar?**<br>
Dentro do Powershell, ou de um script dele, inicialmente, é preciso importar o modulo. 
Depois disso, basta chamar a função “NovoUsuario” seguida dos parâmetros, na mesma ordem informada no item anterior. 


## AdmissaoGUI
* **Objetivo:**<br>
Ser uma interface gráfica para o uso da função de admissão.
* **Como funciona?**<br>
Desenha uma interface baseada em Windows Forms para o uso da função, com uma tela de retorno para os registros. 
* **Como utilizar?**<br> 
Execute o script no Powershell

## Desligamento
* **Objetivo:**<br>
Automatizar o processo de desligamento de colaboradores 
* **Como funciona?**<br>
Recebe o usuário, faz os procedimentos relacionados ao AD que constam no manual de desligamento, conecta no portal do Office e remove todas as licenças que o usuário tem atribuídas e verifica qual o numero do Jabber, caso ele utilize, que está vinculado. 
* **Como utilizar?**<br>
Dentro do Powershell, ou de um script dele, inicialmente, é preciso importar o modulo. <br>
Depois disso, basta chamar a função “DesligarUsuario” seguida do usuário, no modelo nome.sobrenome.

## DesligamentoGUI
* **Objetivo:**<br>
Ser uma interface gráfica para o uso da função de desligamento.
* **Como funciona?**<br>
Desenha uma interface baseada em Windows Forms para o uso da função, com uma tela de retorno para os registros. 
* **Como utilizar?**<br> 
Execute o script no Powershell

## LicenciamentoOffice
* **Objetivo:**<br>
Automatizar o processo de atribuição de licenciamento.
* **Como funciona?**<br>
Recebe como parâmetro, um arquivo gerado no dia pelo script de admissão, fazendo um tratamento nele para receber o nome, o email e o nível hierárquico do usuário criado. <br>
Com isso, faz a atribuição da licença de acordo com o nível.
* **Como utilizar?**<br>
Execute o script no Powershell
