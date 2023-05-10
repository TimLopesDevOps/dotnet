$rootDir = "testDir" # Replace with the root directory path

$var1 = "kehitys" # Replace with the value of var1
$var2 = "DEV" # Replace with the value of var2

# Function to check if a file exists in a directory
function FileExistsInDirectory($directory, $fileName) {
    $files = Get-ChildItem -LiteralPath $directory -File
    foreach ($file in $files) {
        if ($file.Name -eq $fileName) {
            return $true
        }
    }
    return $false
}

# Function to create a new file by replacing a variable in the original file name
function CreateNewFile($directory, $fileName, $newFileName) {
    $filePath = Join-Path -Path $directory -ChildPath $fileName
    $newFilePath = Join-Path -Path $directory -ChildPath $newFileName
    $content = Get-Content $filePath -Raw
    $newContent = $content -replace $var1, $var2
    $newContent | Out-File -FilePath $newFilePath -Encoding UTF8
}

# Loop through subdirectories in the root directory
$subDirs = Get-ChildItem -LiteralPath $rootDir -Directory
foreach ($subDir in $subDirs) {
    $currentDir = Join-Path -Path $rootDir -ChildPath $subDir.Name

    # Check if the current subdirectory contains any of the initial files
    $file1Exists = FileExistsInDirectory $currentDir "env.$var1"
    $file2Exists = FileExistsInDirectory $currentDir "appsettings.$var1.json"
    $file3Exists = FileExistsInDirectory $currentDir "AppConfig.$var1.json"

    if ($file1Exists -or $file2Exists -or $file3Exists) {
        # Check if the same type of file with $var2 exists
        $fileType = if ($file1Exists) { "env" } elseif ($file2Exists) { "appsettings" } else { "AppConfig" }
        $newFileName = "$fileType.$var2.$fileType"
        $newFileExists = FileExistsInDirectory $currentDir $newFileName

        if (-not $newFileExists) {
            # Create a new file by copying the file with $var1 and replacing $var1 with $var2 in the name
            $originalFileName = "$fileType.$var1.$fileType"
            CreateNewFile $currentDir $originalFileName $newFileName
            Write-Host "Created new file: $newFileName"
        }
    }
}
