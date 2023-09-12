$OutPath = (Split-Path -path $PSScriptRoot)
$ModuleName = (Split-Path -path $OutPath -Leaf)
$ModuleFile = Join-Path -Path $OutPath -ChildPath "$ModuleName.psd1"

New-NtnxApiFunction -ApiSet karbon -Method get -SubUrl "v1-alpha.1/k8s/clusters/`$KarbonName/node-pools" -AltNoun KarbonNodePool -Verbose
New-NtnxApiFunction -ApiSet karbon -Method get -SubUrl "/karbon/v1/k8s/clusters/`$NkeClusterName/ssh" -AltNoun NkeSshCredential -Verbose
New-NtnxApiFunction -ApiSet karbon -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/clusters/{name}/available-updates" -AltNoun NkeAvailableUpdate -Verbose
New-NtnxApiFunction -ApiSet karbon -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/clusters" -AltNoun NkeCluster -Verbose
New-NtnxApiFunction -ApiSet karbon -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/cluster/`$Uuid/k8s_upgrade" -AltNoun NkeClusterUpgrade -Verbose

# for each function created, get content and write to module file
$functions = Get-ChildItem -Path $OutPath -Filter *.ps1 -Recurse

foreach ($function in $functions) {
    Get-Content -Path $function.FullName | Add-Content -Path $ModuleFile 
    Write-Output "Export-ModuleMember $($function.BaseName)" | Add-Content -Path $ModuleFile
    #$functionContent | Out-File -FilePath $function.FullName -Force
}


### Add Docs build using PlatyPS
$DocsPath = Join-Path -Path $OutPath -ChildPath "docs"
Write-Verbose -Message "DocsPath: $DocsPath"
if (-not (Test-Path -Path $DocsPath)) {
    New-Item -Path $DocsPath -ItemType Directory
}

