function List-Disks {
    Write-Host "." -NoNewline
    'list disk' | diskpart |
        Where-Object { $_ -match 'disk (\d+)\s+online\s+\d+ .?b\s+\d+ [gm]b' } |
        ForEach-Object { $matches[1] }
}

function List-Partitions($disk) {
    Write-Host "." -NoNewline
    "select disk $disk", "list partition" | diskpart |
        Where-Object { $_ -match 'partition (\d+)' } |
        ForEach-Object { $matches[1] }
}

function Extend-Partition($disk, $part) {
    Write-Host "." -NoNewline
    "select disk $disk","select partition $part","extend" | diskpart | Out-Null
}
function Is-Numeric ($Value) {
    return $Value -match "^[\d\.]+$"
}
Write-Host "Disk expansion"  -F White

#
# Windows Recovery Partition is in the way to be able to Extend the main partition so we remove it.
$RecoveryPartitionID = ((Get-Partition -DiskNumber ((Get-Disk).Number) | Where-Object {$_.Type -eq 'Recovery'}).PartitionNumber)
if(Is-Numeric($RecoveryPartitionID)) { Remove-Partition -DiskNumber ((Get-Disk).Number) -PartitionNumber $RecoveryPartitionID -PassThru -Confirm:$false }
$RecoveryPartitionID = ((Get-Partition -DiskNumber ((Get-Disk).Number) | Where-Object {$_.Type -eq 'Unknown'}).PartitionNumber)
if(Is-Numeric($RecoveryPartitionID)) { Remove-Partition -DiskNumber ((Get-Disk).Number) -PartitionNumber $RecoveryPartitionID -PassThru -Confirm:$false }


List-Disks | ForEach-Object {
    $disk = $_
    List-Partitions $disk | ForEach-Object {
        Extend-Partition $disk $_
    }
}
Write-Host ". Done"
