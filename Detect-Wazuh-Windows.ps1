# Detection Script - Check if "ExampleApp" is installed
$installed = Get-ItemProperty Get-ItemProperty -Path "HKCU:\Software\Wazuh, Inc.\Wazuh Agent\"  -ErrorAction SilentlyContinue | Where-Object { $_.Install -eq "*1" }

if ($installed) { 
    Write-Output "Installed"
    exit 0  # App found
} else {
    exit 1  # App not found
}
