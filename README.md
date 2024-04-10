# Synopsis
Simple Powershell script that is copying video files from your laptop drive to your NAS directory.

# How the script works
* It finds the media files in your source directory.
* Maps network drives with your destination directories.
* Gets the file name without extention and removes any special characters from the file name.
* It checks whether the file is a movie file or tv show episode by checking if the file name contains "S01" phrase.
* If it does, it will remove everything after "S01", set the destination to tv show folder on your network drive.
* It checks whether the tv show destination already exists - if not, it will create it.
* Checks whether the "S01" subfolder exists in the new tv show destination folder - if not it will create it.
* Copy the file to the "S01" folder.
* When the file name doesn't contain "S01" it will remove everything from the file name after (and including) the year.
* Set the destination folder to the Movies directory and copy the file.
* At the end it will remove mapped drives and remove the file from the source directory.
