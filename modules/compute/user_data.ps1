<powershell>
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
New-Item -Path 'C:\inetpub\wwwroot\index.html' -ItemType File -Force -Value 'Hello from Windows IIS!'
Start-Service W3SVC
Add-Content -Path 'C:\inetpub\wwwroot\install.log' -Value "Installed on: $(Get-Date)"
</powershell>

