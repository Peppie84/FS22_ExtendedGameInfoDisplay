#
# Use this script to generate a zip file to upload to farmingsimulators modhub
#
$modDirectory = Split-Path -Path $pwd -Leaf
$modName = "$modDirectory";
$modDescFileName = "$modDirectory/modDesc.xml"
$testRunnerLogPath = ".\.testrunner\"
$readmeFilePath = "README.md"

$xmlData = [xml] (Get-Content $modDescFileName -Encoding UTF8)
$currentVersion = $xmlData.modDesc.version

$newVersion = read-host -Prompt "Please enter a new version (like: a.b.c.d). Current Version is: $currentVersion "
if (([string]::IsNullOrEmpty($newVersion)))
{
    $newVersion = "$currentVersion"
}

# Write new moddesc version
$xmlData = [xml] (Get-Content $modDescFileName -Encoding UTF8)
$xmlData.modDesc.version = "$newVersion"

$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
$xmlStreamWriter = New-Object System.IO.StreamWriter($modDescFileName, $false, $utf8WithoutBom)

$xmlData.Save( $xmlStreamWriter )
$xmlStreamWriter.Close()

# Write new readme version
((Get-Content -path $readmeFilePath -Raw) -replace "Modhub-v$currentVersion","Modhub-v$newVersion") | Set-Content -NoNewline -Path $readmeFilePath


# Make test run (add testrunner path to your environment path)
New-Item -ItemType Directory -Force -Path "$testRunnerLogPath"
TestRunner_public --logPath "$testRunnerLogPath" --outputPath "$testRunnerLogPath" --noPause "$modDirectory\"

# Make zip file
Compress-Archive -Force -Path "$modDirectory\*" -DestinationPath "$modName.zip"
