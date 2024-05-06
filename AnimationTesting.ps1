$Script:Running      = $true
$Script:CurrentTime  = 0
$Script:DeltaTime    = 0
$Script:PreviousTime = [System.DateTime]::Now.Ticks / 1e7
$Script:PlayerX      = 0
$Script:PlayerXVel   = 0.75

Function Run-GameLogic {
    Param(
        [Parameter(Mandatory=$true)]
        [Double]$DeltaTime
    )

    Process {
        If($Script:PlayerX -LE 25.0) {
            $Script:PlayerX += ($Script:PlayerXVel * $DeltaTime)
        } Else {
            $Script:PlayerX = 0.0
        }

        Write-Host "Player X is currently $($Script:PlayerX)"
    }
}

While($Script:Running -EQ $true) {
    $Script:CurrentTime  = [System.DateTime]::Now.Ticks / 1e7
    $Script:DeltaTime    = $Script:CurrentTime - $Script:PreviousTime
    $Script:PreviousTime = $Script:CurrentTime

    Run-GameLogic -DeltaTime $Script:DeltaTime
}
