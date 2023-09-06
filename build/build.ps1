$OutPath = (Split-Path -path $PSScriptRoot)
$ModuleName = (Split-Path -path $OutPath -Leaf)

New-NtnxApiFunction -ApiSet karbon -Method get -SubUrl "v1-alpha.1/k8s/clusters/`$KarbonName/node-pools" -AltNoun KarbonNodePool -Verbose
New-NtnxApiFunction -ApiSet karbon -Method get -SubUrl "/karbon/v1/k8s/clusters/`$NkeClusterName/ssh" -AltNoun NkeSshCredential -Verbose
New-NtnxApiFunction -ApiSet karbon -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/clusters/{name}/available-updates" -AltNoun NkeAvailableUpdate -Verbose
New-NtnxApiFunction -ApiSet karbon -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/clusters" -AltNoun NkeCluster -Verbose
New-NtnxApiFunction -ApiSet karbon -ApiVer "v1-beta.1" -Method get -SubUrl "k8s/cluster/{uuid}/k8s_upgrade" -AltNoun NkeClusterUpgrade -Verbose