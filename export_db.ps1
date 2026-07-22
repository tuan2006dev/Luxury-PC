[Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
$server = New-Object Microsoft.SqlServer.Management.Smo.Server("localhost")
$server.ConnectionContext.LoginSecure = $false
$server.ConnectionContext.Login = "tuan2006"
$server.ConnectionContext.Password = "24112004"
$server.ConnectionContext.Connect()

$db = $server.Databases["luxpcc"]

$scripter = New-Object Microsoft.SqlServer.Management.Smo.Scripter($server)
$scripter.Options.ScriptSchema = $true
$scripter.Options.ScriptData = $true
$scripter.Options.FileName = "c:\Users\tuan\Downloads\Luxury-PC\Luxury-PC\luxpcc_backup.sql"
$scripter.Options.AppendToFile = $false
$scripter.Options.WithDependencies = $true

$tables = @($db.Tables | Where-Object { -not $_.IsSystemObject })
$scripter.EnumScript($tables)

$server.ConnectionContext.Disconnect()
Write-Host "Export completed to luxpcc_backup.sql"
