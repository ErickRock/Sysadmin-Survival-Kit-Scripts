# Verifica se os programas estao abertos
$Edge = Get-Process msedge -ErrorAction SilentlyContinue
$Teams = Get-Process teams -ErrorAction SilentlyContinue

# Edge
if ($Edge) {} 
else {   
    # E-mail Corporativo
    Start-Process -FilePath "msedge" -ArgumentList "https://outlook.office.com/mail/inbox"
}

# Teams
if ($Teams) {} 
else {   
    cmd /c "$env:LOCALAPPDATA\Microsoft\Teams\Update.exe" --processStart "Teams.exe"
}