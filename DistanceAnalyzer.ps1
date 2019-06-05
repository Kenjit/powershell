
class DistanceAnalyzer : FinancialAnalyzer{

[object]$CsvFile
[int]$IndexSegment
[int]$IndexAdvertiser
[int]$IndexRevenue
[int]$IndexCalendarMonth
[String]$Currency
$ArrayData = @()
$FinalArray = @()
$PotentialDupArray = @()

DistanceAnalyzer($FilePath): base($FilePath){

$this.HeaderIndexCheck()
$this.FetchDataInHash()
$this.FinancialCalculator()
$this.FinancialSum()
$this.DuplicateChecker()

}

[Array]GetDup(){

return $this.PotentialDupArray

}








DuplicateChecker(){



#####JaroWinklerDistance






function Get-JaroWinklerDistance {
   
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string] $String1,

        [Parameter(Position = 1)]
        [string] $String2,

       
        [Parameter()]
        [double] $WeightThreshold = 0.7,

       
        [Parameter()]
        [int] $NumChars = 4,

        
        [Parameter()]
        [Alias('Jaro')]
        [switch] $OnlyCalculateJaroDistance,

        
        [Parameter()]
        [switch] $CaseSensitive,

       
        [Parameter()]
        [switch] $NormalizeOutput
    )

    if (-not($CaseSensitive)) {
        $String1 = $String1.ToLowerInvariant()
        $String2 = $String2.ToLowerInvariant()
    }

    
    $searchRange = ([Math]::Max($String1.Length,$String2.Length) / 2) - 1

    $matched1 = New-Object 'Bool[]' $String1.Length
    $matched2 = New-Object 'Bool[]' $String2.Length


    $matchingCharacters = 0
    for ($i = 0; $i -lt $String1.Length; $i++) {
        $start = [Math]::Max(0,($i - $searchRange))
        $end = [Math]::Min(($i + $searchRange + 1), $String2.Length)
        for ($j = $start; $j -lt $end; $j++) {
            if ($matched2[$j]) { continue }
            if ($String1[$i] -cne $String2[$j]) { continue }
            $matched1[$i] = $true
            $matched2[$j] = $true
            $matchingCharacters++
            break
        }
    }
    if ($matchingCharacters -eq 0) { return 0.0 }

    # calculate transpositions
    $halfTransposed = 0
    $k = 0
    for ($i = 0; $i -lt $String1.Length; $i++) {
        if (-not($matched1[$i])) { continue }
        while (-not($matched2[$k])) { $k++ }
        if ($String1[$i] -cne $String2[$k]) { $halfTransposed++ }
        $k++
    }
    $transposed = $halfTransposed / 2

    [double]$jaroDistance = (($matchingCharacters / $String1.Length) + ($matchingCharacters / $String2.Length) + (($matchingCharacters - $transposed) / $matchingCharacters)) / 3

    if ($OnlyCalculateJaroDistance) {
        $output =  $jaroDistance
    }

    else {

        if ($jaroDistance -le $WeightThreshold) {
            $output =  $jaroDistance
        }

     
        else {
            $max = [Math]::Max($NumChars, ([Math]::Min($String1.Length,$String2.Length)))
            $position = 0
            while (($position -lt $max) -and ($String1[$position] -ceq $String2[$position])) { $position++ }
            if ($position -eq 0) {
                $output =  $jaroDistance
            }

            else {
                $output =  ($jaroDistance + ($position * 0.1 * (1.0 - $jaroDistance)))
            }

        }
    }

    if ($NormalizeOutput) {
        return (1 - $output)
    }

    else {
       return $output
    }
} 





forEach($i in $this.FinalArray){
[float]$Score= 0
	forEach($k in $this.SumArray){	
		$Score = Get-JaroWinklerDistance $i.Advertiser $k.Advertiser
		if($Score -le 0.3){

			$this.PotentialDupArray += [PSCustomObject]@{
					Name1 = $i.Advertiser
					Name2 = $k.Advertiser
					}
			

		}
	}

}






}

##Class closure
}




			
			
				    		
					

