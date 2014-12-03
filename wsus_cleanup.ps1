# E-post
$rundate = Get-Date -format "yyyy-MM-dd H:m";
$body = @()
$body += 'WSUS Cleanup Result - ' + $rundate
$body += '='*31

# Kör WSUS Server Cleanup Wizard som schemalagt jobb
[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration") | out-null
$wsus = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer();
$cleanupScope = new-object Microsoft.UpdateServices.Administration.CleanupScope;
$cleanupScope.DeclineSupersededUpdates = $true
$cleanupScope.DeclineExpiredUpdates = $true
$cleanupScope.CleanupObsoleteUpdates = $true
$cleanupScope.CompressUpdates = $true
#$cleanupScope.CleanupObsoleteComputers = $true
$cleanupScope.CleanupUnneededContentFiles = $true
$cleanupManager = $wsus.GetCleanupManager();
$body += $cleanupManager.PerformCleanup($cleanupScope) | Out-String

# Skicka output via e-post
$body = $body | Out-String
# Skicka resultatet
send-mailmessage -from "wsus@domain.se" -to "techsupport@domain.se" -subject "WSUS Server Cleanup" -body $body -SmtpServer "smtp.domain.se"
