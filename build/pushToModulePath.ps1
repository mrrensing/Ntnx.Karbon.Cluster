param(
    [string]$localModulePath = "C:\_admin\PowerShell\modules"
)
$moduleName = split-path (split-path $PSScriptRoot -parent) -leaf
$fullLocalModulePath = "$localModulePath\$moduleName"

if (Test-Path -Path $fullLocalModulePath) {
    Remove-Item -Path $fullLocalModulePath -Recurse -Force
}
Copy-Item -Path "$(Split-Path $PSScriptRoot)\$moduleName" -Destination $localModulePath -Force -Recurse -Verbose