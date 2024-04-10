# Input vars
$Files = Get-ChildItem -Path E:\Downloads\Media -Include ('*.mkv', '*.mp4') -File -Recurse -ErrorAction SilentlyContinue | Sort LastWriteTime #| Select -Last 1
$DestMovie = "\\<your_nas_ip>\video\Films"
$DestTv = "\\<you_nas_ip>\video\TVShows"
$User = "bartekadm"
$Pswd = ConvertTo-SecureString "<your_pswd>" -AsPlainText -Force
$MyCreds = New-Object System.Management.Automation.PSCredential($User, $Pswd)

# Map drives
New-PSDrive -Name M -PSProvider FileSystem -Root $DestMovie -Credential $mycreds
New-PSDrive -Name T -PSProvider FileSystem -Root $DestTv -Credential $mycreds

# Get the file name without the extension
$FileName = [System.IO.Path]::GetFileNameWithoutExtension($Files)

# Remove any special characters from the file name
$FolderName = $FileName -replace '[^a-zA-Z0-9]',' '

# Check if the file name contains "S01"
if ($FileName -match "S01") {

    # If it does, remove everything after "S01"
    $FolderTvName = ($FolderName -split " S01")[0]

    # Set the destination to the Tv Shows folder
    $NewDestTV = "$DestTv\$folderTvName"

    # Check if the TV Show destination folder exists
    if (!(Test-Path $NewDestTv)) {

        # If it doesn't, create it
        New-Item -ItemType Directory -Path $NewDestTv | Out-Null
    }

    # Check if the "S01" subfolder exists in the new tv show destination folder
    $s01Folder = "$NewDestTv\S01"
    if (!(Test-Path $s01Folder)) {

        # If it doesn't, create it and copy the file to the "S01" subfolder
        New-Item -ItemType Directory -Path $s01Folder | Out-Null
        Copy-Item $Files $s01Folder

        } else {
                # Copy the file to the existing "S01" subfolder
                Copy-Item $Files $s01Folder
        }

} else {
    
    # Remove everything from the file name after and including year
    $FolderMvName = ($FolderName -split " \d{4}")[0]
    
    # Set the destination folder to the Movies folder
    $NewDestMovie = "$DestMovie\$FolderMvName"
    New-Item -ItemType Directory -Path $NewDestMovie | Out-Null
    Copy-Item $Files $NewDestMovie
}


# Remove mapped drives
Get-PSDrive M, T | Remove-PSDrive

# Remove files from source directory
Get-ChildItem -Path E:\Downloads\Media -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse
Exit
