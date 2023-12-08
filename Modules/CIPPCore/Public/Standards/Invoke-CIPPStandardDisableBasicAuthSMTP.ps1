function Invoke-DisableBasicAuthSMTP {
    <#
    .FUNCTIONALITY
    Internal
    #>
    param($Tenant, $Settings)
    If ($Settings.Remediate) {
        try {
            $Request = New-ExoRequest -tenantid $Tenant -cmdlet 'Set-TransportConfig' -cmdParams @{ SmtpClientAuthenticationDisabled = $true }
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Disabled SMTP Basic Authentication' -sev Info
        } catch {
            Write-LogMessage -API 'Standards' -tenant $tenant -message "Failed to disable SMTP Basic Authentication: $($_.exception.message)" -sev Error
        }
    }
    if ($Settings.Alert) {
        $CurrentInfo = New-ExoRequest -tenantid $Tenant -cmdlet 'Get-TransportConfig'
        if ($CurrentInfo.SmtpClientAuthenticationDisabled) {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'SMTP Basic Authentication is disabled' -sev Info
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'SMTP Basic Authentication is not disabled' -sev Alert
        }
    }
}