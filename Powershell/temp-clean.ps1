# Declarando varíavel contendo diversas pastas

$tempfolders = @( “C:\Windows\Temp\*”, “C:\Windows\Prefetch\*”,
“C:\Documents and Settings\*\Local Settings\temp\*”,
“C:\Users\*\Appdata\Local\Temp\*” )

# Executando a limpeza de forma recursiva na varável criada acima

Remove-Item $tempfolders -force -recurse


Send-MailMessage -From erickgarciagodoy@outlook.com -To erick@vtnorton.com -Subject 'Script Test' -Body 'Some important plain text!' -Credential (Get-Credential) -SmtpServer smtp-mail.outlook.com -Port 573 

<# É possível identar o código com quebra de linhas usando espaço + ` + shift + enter
Ou usando o código desejado entre @ e inserindo entre as aspas 
Exemplo:  #>
<# $mystring = @"
Bob
went
to town
to buy
a fat
pig.
"@ #>

<# Send-MailMessage -From 'User01 <user01@fabrikam.com>' `
-To 'User02 <user02@fabrikam.com>', `
'User03 <user03@fabrikam.com>' `
-Subject 'Sending the Attachment' `
-Body "Forgot to send the attachment. Sending now." `
-Attachments .\data.csv `
-Priority High `
-DeliveryNotificationOption OnSuccess, OnFailure -SmtpServer 'smtp.fabrikam.com' #>

