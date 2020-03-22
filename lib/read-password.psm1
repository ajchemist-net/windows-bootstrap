Function Read-Password()
{
    $pwd1 = Read-Host "Passowrd" -AsSecureString
    $pwd2 = Read-Host "Re-enter Passowrd" -AsSecureString
    $pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd1))
    $pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pwd2))
    if ($pwd1_text -ceq $pwd2_text)
    {
        return $pwd1
    }
    else
    {
        Write-Error "Passwords differ"
    }
}
