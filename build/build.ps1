param(
    $OutPath = (Split-Path -path $PSScriptRoot),
    $ModuleName = (Split-Path -path $OutPath -Leaf),
    $ModuleFile = (Join-Path -Path $OutPath -ChildPath "$ModuleName.psd1")
)

$publicFunctionsPath = Join-Path -Path $OutPath -ChildPath $ModuleName -AdditionalChildPath "Public"


# Create Module Manifest
#New-ModuleManifest

# Create Module File
New-Item -Path $ModuleFile -ItemType File -Force

$funcArgs = @{
    OutPath = $publicFunctionsPath
    ApiSet = "karbon"
    Verbose = $true
}

New-NtnxApiFunction @funcArgs -ApiVer "v1-alpha.1"  -Method get -SubUrl "k8s/clusters/`$NkeClusterName/node-pools" -AltNoun NkeNodePool
New-NtnxApiFunction @funcArgs -ApiVer "v1" -Method get -SubUrl "/karbon/v1/k8s/clusters/`$NkeClusterName/ssh" -AltNoun NkeSshCredential
New-NtnxApiFunction @funcArgs -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/clusters/`$Name/available-updates" -AltNoun NkeAvailableUpdate
New-NtnxApiFunction @funcArgs -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/clusters" -AltNoun NkeCluster
New-NtnxApiFunction @funcArgs -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/cluster/`$Uuid/k8s_upgrade" -AltNoun NkeClusterUpgrade

# for each function created, get content and write to module file
$publicFunctions = Get-ChildItem -Path $publicFunctionsPath -Filter *.ps1 -Recurse

foreach ($function in $publicFunctions) {
    Get-Content -Path $function.FullName | Add-Content -Path $ModuleFile
    Write-Output "`n Export-ModuleMember $($function.BaseName) `n" | Add-Content -Path $ModuleFile
    #$functionContent | Out-File -FilePath $function.FullName -Force
}


### Add Docs build using PlatyPS
$DocsPath = Join-Path -Path $OutPath -ChildPath "docs"
Write-Verbose -Message "DocsPath: $DocsPath"
if (-not (Test-Path -Path $DocsPath)) {
    New-Item -Path $DocsPath -ItemType Directory
}

