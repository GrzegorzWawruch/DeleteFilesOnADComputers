New-Item -Path "C:\Users\$env:USERNAME\Desktop\logs.txt" -ItemType File -Force

cls

$ADComputers = Get-ADComputer -Filter * | Select-Object Name, Enabled | Out-GridView -OutputMode Multiple -Title 'AD-Computers' | Select-Object -ExpandProperty Name
try
{
    foreach($computer in $ADComputers)
    {
        $logs = Invoke-Command -ComputerName $computer -ScriptBlock {
            $FilePaths = @('C:\test\testowy.txt', 'C:\test\testowy2.txt')
            $logEntries = @()
            foreach($file in $FilePaths)
            {
                try
                {
                    $FileExist = Test-Path -Path $file
                    if(-not $FileExist)
                    {
                        $logEntries += "$file wasn't found on computer $env:COMPUTERNAME "
                    }
                    else
                    {
                        Remove-Item -Path $file -ErrorAction Stop
                        $logEntries += "$file was successfully removed on computer $env:COMPUTERNAME " 
                    }
                }
                catch
                {
                    $logEntries += "$file wasn't removed on computer $env:COMPUTERNAME, ERROR OCCURED"   
                }
            }
            return $logEntries
        }
        $logs | Out-File -FilePath "C:\Users\$env:USERNAME\Desktop\logs.txt" -Append
    }
    
    Write-Host "Deleted process was ended you can find log here: C:\Users\$env:USERNAME\Desktop\logs.txt "
}
catch
{
    Write-Host $_.Exception.Message
    Write-Host 'Error occured during deleted process'
}
