
# Variables
$WazuhManager = "192.168.101.118"   # Replace with your Wazuh Manager IP
$AgentName = $env:COMPUTERNAME
$InstallerURL = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.12.0-1.msi"

# Download installer
Invoke-WebRequest -Uri $InstallerURL -OutFile "C:\Temp\wazuh-agent.msi"

# Install silently
Start-Process msiexec.exe -ArgumentList "/i C:\Temp\wazuh-agent.msi /qn WAZUH_MANAGER=$WazuhManager WAZUH_AGENT_NAME=$AgentName" -Wait

# Start and enable service
Start-Service WazuhSvc
Set-Service WazuhSvc -StartupType Automatic
