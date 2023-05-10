$rootDir = "testDir" # Replace with the root directory path

$var1 = "kehitys" # Replace with the value of var1
$var2 = "DEV" # Replace with the value of var2

function FileExistsInDirectory($directory, $fileName) {
    $files = Get-ChildItem -LiteralPath $directory -File
    foreach ($file in $files) {
        if ($file.Name -eq $fileName) {
            return $true
        }
    }
    return $false
}

function CreateNewFile($directory, $fileName, $newFileName) {
    $filePath = Join-Path -Path $directory -ChildPath $fileName
    $newFilePath = Join-Path -Path $directory -ChildPath $newFileName
    $content = Get-Content $filePath -Raw
    $newContent = $content -replace $var1, $var2
    $newContent | Out-File -FilePath $newFilePath -Encoding UTF8
}

$subDirs = Get-ChildItem -LiteralPath $rootDir -Directory
foreach ($subDir in $subDirs) {
    $currentDir = Join-Path -Path $rootDir -ChildPath $subDir.Name

    $file1Exists = FileExistsInDirectory $currentDir "env.$var1"
    $file2Exists = FileExistsInDirectory $currentDir "appsettings.$var1.json"
    $file3Exists = FileExistsInDirectory $currentDir "AppConfig.$var1.json"

    if ($file1Exists -or $file2Exists -or $file3Exists) {
        if ($file1Exists) {
            $fileType = "env"
        } elseif ($file2Exists) {
            $fileType = "appsettings"
        } else {
            $fileType = "AppConfig"
        }

        $originalFileName = "$fileType.$var1.json"
        $newFileName = "$fileType.$var2.json"
        $newFileExists = FileExistsInDirectory $currentDir $newFileName

        if (-not $newFileExists) {
            CreateNewFile $currentDir $originalFileName $newFileName
            Write-Host "Created new file: $newFileName"
        }
    }
}
