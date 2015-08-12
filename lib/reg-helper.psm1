function Import-Registry($reg) {
    # add reg file hander
    $reg = "Windows Registry Editor Version 5.00`r`n`r`n" + $reg

    # store, import and remove reg file
    $regfile = "$env:windir\Temp\registry.reg"
    $reg | Out-File $regfile
    Start-Process "regedit.exe" -ArgumentList ("/s", "$regfile") -Wait
    rm $regfile
}

function Takeown-Registry($key) {
    # TODO works only for LocalMachine for now
    $key = $key.substring(19)

    # set owner
    $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Windows Defender\Spynet", "ReadWriteSubTree", "TakeOwnership")
    $owner = [Security.Principal.NTAccount]"Administrators"
    $acl = $key.GetAccessControl()
    $acl.SetOwner($owner)
    $key.SetAccessControl($acl)

    # set FullControl
    $acl = $key.GetAccessControl()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule("Administrators", "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
}