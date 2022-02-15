param([string]$server="", [string]$tableEnding="")
$query = Get-Content "$env:TEMP.\Scripts\ProcedureTruncateCruft.sql" -Raw
$continue = 0
try
{
    Invoke-Sqlcmd -ServerInstance $server -Database "AxDB" -Query $query -Verbose -ErrorAction SilentlyContinue
    $continue = 1
}
catch
{
    Write-Output "Failed to connect to $server"
}

if ($continue)
{
    $tableNameEndingArray = @()
    $tableNameEndingArray = $tableEnding.ToString().Split(',')

    $stop = 0
    do { 
        do {
            $retryCount = 0
            $stop = 0
            
            foreach($tableNameEnding in $tableNameEndingArray)
            {
                do
                {
                    try
                    {
                        Invoke-Sqlcmd -ServerInstance $Server -Database "AxDB" -QueryTimeout 120 -OutputSqlErrors $True -ConnectionTimeout 5 -ErrorAction Stop -Query "EXEC TruncateNoise $tableNameEnding" -Verbose
                        $stop = 1
                    }
                    catch
                    {
                        if ($retryCount -lt 3)
                        {
                            $retryCount += 1
                        }
                        else
                        {
                            Write-Output "Aborting because of time outs!"
                            $stop = 1
                        }
                    }
                } until ($stop)
            }
        } until($stop)
    } until ($stop)
}

pause