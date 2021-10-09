# Automações

## Script de preventiva

### Limpando arquivos temporários

Pastas afetadas:

* C:\Windows\Temp
* C:\Windows\Prefetch
* C:\Documents and Settings*\Local Settings\Temp
* C:\Users*\Appdata\Local\Temp

# Introdução

Forma simples:

```pwsh
Set-Location “C:\Windows\Temp”
Remove-Item * -recurse -force

Set-Location “C:\Windows\Prefetch”
Remove-Item * -recurse -force

Set-Location “C:\Documents and Settings”
Remove-Item “.\*\Local Settings\temp\*” -recurse -force

Set-Location “C:\Users”
Remove-Item “.\*\Appdata\Local\Temp\*” -recurse -force
```

Fonte: [Clean TEMP files with Powershell](https://devblogs.microsoft.com/scripting/weekend-scripter-use-powershell-to-clean-out-temp-folders/?ranMID=46131&ranEAID=a1LgFw09t88&ranSiteID=a1LgFw09t88-XVaO9JTCnNATdAWS_hjXcA&epi=a1LgFw09t88-XVaO9JTCnNATdAWS_hjXcA&irgwc=1&OCID=AID2200057_aff_7806_1243925&tduid=(ir__r6zpu0cnqokf6ijc1wqdaho63v2xrvn6hma063g100)(7806)(1243925)(a1LgFw09t88-XVaO9JTCnNATdAWS_hjXcA)()&irclickid=_r6zpu0cnqokf6ijc1wqdaho63v2xrvn6hma063g100)


