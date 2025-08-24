function Get-GoogleDriveFile {
    param([string]$fileId, [string]$fileName)
    
    # First get the confirmation token
    $url = "https://drive.google.com/uc?export=download&id=$fileId"
    $response = Invoke-WebRequest -Uri $url -SessionVariable googleDriveSession
    
    # Extract the confirmation token
    $token = $response.Content | Select-String -Pattern "confirm=([0-9a-zA-Z]+)" -AllMatches | 
             ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value }
    
    if ($token) {
        # Download the file with the token
        $url = "https://drive.google.com/uc?export=download&confirm=$token&id=$fileId"
        Invoke-WebRequest -Uri $url -WebSession $googleDriveSession -OutFile $fileName
    } else {
        # If no token found, try direct download
        Invoke-WebRequest -Uri $url -OutFile $fileName
    }
}

# Download SMB Signal parser
Write-Host 'Downloading SMB Signal parser...'
Get-GoogleDriveFile -fileId '1z2R5EfNEMJ55oGx_kMOde6JGYpK7KZIg' -fileName $args[0]

# Download tesseract
Write-Host 'Downloading tesseract-portable...'
Get-GoogleDriveFile -fileId '1ODIU6A-hh20bYpxorXyfRmqfUUd-wcSy' -fileName $args[1]
