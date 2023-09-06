function _nkeSshAccess {
  param(
      [parameter(Mandatory = $true)]
      [string]
      $PrivateKey,

      [parameter(Mandatory = $true)]
      [string]
      $UserCert,

      $Tag="KARBON",
      
      $ClusterIuid='238de91a-5f8e-45d4-7dc8-3b82a7f1e3c1',
      
      [switch]$save_cert,

      [switch]$file_copy

  )

  process {

    # Private Key
    if($null -eq $cluster_uuid) {
        $private_key_file = "$env:temp\${tag}_user"
    }
    else{
        $private_key_file = "$env:temp\${tag}_user_${cluster_uuid}"
    }
    $private_key | Out-File $private_key_file
    Set-ItemProperty -Path $private_key_file -Name IsReadOnly -Value $true

    #Initialising the cert file path
    if($null -eq $cluster_uuid) {
      $cert_file = "$env:temp\${tag}_user-cert.pub"
    }
    else{
      $cert_file = "$env:temp\${tag}_user_${cluster_uuid}-cert.pub"
    }
      # Creating Cert file #
      $user_cert | Out-File $cert_file #
      Set-ItemProperty -Path $cert_file -Name IsReadOnly -Value $true #

  if ($save_cert) { #
      exit 0 #
  } 
  else { #
      $vm_ip = Read-Host "Enter $tag VM IP" #
  } #
   
  else { #
    $vm_ip = $args[0] 
    $args = $args[1..($args.Length-1)] #

    if ($file_copy) {
      $src = $args
      $dst = $args
    } 
    else { #
      $cmd = $args #
    } #
  } #


    Write-Output "================== $vm_ip ==================" #

    if ($file_copy) {
      scp -i $private_key_file $src "nutanix@$($vm_ip):$($dst)"  #
    } else { #
      ssh -i $private_key_file "nutanix@$vm_ip" "$cmd" #
    }

  } 


  clean {
    if ($save_cert -ne $true) { #
      Remove-Item $private_key_file -Force
      Remove-Item $cert_file -Force
    }      
  }
}