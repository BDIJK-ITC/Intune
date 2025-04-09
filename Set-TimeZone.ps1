# Ensure the location services are enabled on your Windows 11 device for this script to work.

# Function to get the device's location using Windows Location API
function Get-DeviceLocation {
    try {
        # Use the Windows.Devices.Geolocation API to get the location
        $geoLocator = New-Object -ComObject Windows.Devices.Geolocation.Geolocator
        $position = $geoLocator.GetGeopositionAsync().GetAwaiter().GetResult()
        
        $latitude = $position.Coordinate.Point.Position.Latitude
        $longitude = $position.Coordinate.Point.Position.Longitude

        return @{
            Latitude = $latitude
            Longitude = $longitude
        }
    } catch {
        Write-Host "Failed to retrieve device location. Ensure location services are enabled." -ForegroundColor Red
        return $null
    }
}

# Function to determine the time zone based on latitude and longitude
function Get-TimeZoneFromCoordinates {
    param (
        [double]$Latitude,
        [double]$Longitude
    )

    try {
        # Use an external API to determine the time zone (e.g., Google Time Zone API or similar)
        $apiKey = "YOUR_API_KEY" # Replace with your API key for a time zone service
        $url = "https://maps.googleapis.com/maps/api/timezone/json?location=$Latitude,$Longitude&timestamp=$(Get-Date -UFormat %s)&key=$apiKey"
        $response = Invoke-RestMethod -Uri $url -Method Get

        if ($response.status -eq "OK") {
            return $response.timeZoneId
        } else {
            Write-Host "Failed to determine time zone: $($response.errorMessage)" -ForegroundColor Red
            return $null
        }
    } catch {
        Write-Host "Error while fetching time zone: $_" -ForegroundColor Red
        return $null
    }
}

# Function to set the time zone
function Set-TimeZone {
    param (
        [string]$TimeZoneId
    )
    try {
        tzutil /s $TimeZoneId
        Write-Host "Time zone set to: $TimeZoneId" -ForegroundColor Green
    } catch {
        Write-Host "Failed to set time zone. Error: $_" -ForegroundColor Red
    }
}

# Main script
$deviceLocation = Get-DeviceLocation

if ($deviceLocation) {
    $latitude = $deviceLocation.Latitude
    $longitude = $deviceLocation.Longitude

    Write-Host "Device Location: Latitude=$latitude, Longitude=$longitude"

    $timeZoneId = Get-TimeZoneFromCoordinates -Latitude $latitude -Longitude $longitude

    if ($timeZoneId) {
        Set-TimeZone -TimeZoneId $timeZoneId
    } else {
        Write-Host "Could not determine the time zone." -ForegroundColor Red
    }
} else {
    Write-Host "Could not retrieve device location." -ForegroundColor Red
}