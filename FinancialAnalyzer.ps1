
class FinancialAnalyzer : CsvAnalyzer{

[object]$CsvFile
[int]$IndexSegment
[int]$IndexAdvertiser
[int]$IndexRevenue
[int]$IndexCalendarMonth
[String]$Currency
$ArrayData = @()
$FinalArray = @()
$SumArray=@()

FinancialAnalyzer($FilePath) : base($FilePath) {
	$this.FilePath = $FilePath
	$this.CsvFile = Get-Content $FilePath
	$this.HeaderIndexcheck()
	$this.FetchDataInHash()
	$this.FinancialCalculator()
	$this.FinancialSum()

}

[Array] GetFinalArray(){

return $this.FinalArray

}

[Array]GetSumArray(){
return $this.SumArray
}

HeaderIndexCheck(){
	$arrayString = @()
	$csvColumnNames = (Get-Content $this.FilePath | Select-Object -First 1)
	$csvString =$csvColumnNames.toCharArray()
	$a = ""
	foreach($letter in $csvString){
		if($letter -eq ";"){
			$arrayString += $a
			$a = ""			
			} else {
				$a = $a + $letter
			}
		}
	$i = 0
	while($i -le $arrayString.length){

	switch($arrayString[$i]){

		"Segment" {$this.IndexSegment = $i; break;}
		"Advertiser_Name" {$this.IndexAdvertiser = $i; break;}
		"Net_Media_Revenue" {$this.IndexRevenue = $i; break;}
		"Currency"{$this.Currency = $i;break;}
		 default {break;} 				
	}
	$i++
	}
		$this.IndexCalendarMonth = $i-1
		
	
	}



FetchDataInHash(){
	forEach($l in $this.CsvFile){
		$a = ""
		$RowAdvertiser=""
		$RowSegment=""
		$RowRevenue = ""
		$RowCalendarMonth = ""
		$RowCurrency = ""
		[int]$SemiNumber = 0
		$RowString = $l.toCharArray()
			####SentenceLoop
			forEach($letter in $RowString){	
				###If statement
				if ($letter -eq ";"){
						switch($SemiNumber){
						$this.IndexAdvertiser {$a.trim('"');$RowAdvertiser =$a; break;}
						$this.IndexSegment { $a.trim('"');$RowSegment = $a;break;}
						$this.IndexRevenue {$a.trim('"');$RowRevenue = $a; break;};
						$this.Currency {$a.trim('"');$RowCurrency = $a; break;}
						default {break;}
							}
						$SemiNumber++
						$a = ""
										
					}else{
						$a = $a+$letter
						}	
						if($SemiNumber -eq $this.IndexCalendarMonth) {$a.trim('"');$RowCalendarMonth = $a}				
						
					}
					$this.ArrayData += [PSCustomObject]@{
						Advertiser = $RowAdvertiser.trim('"')
						Segment = $RowSegment.trim('"')
						Revenue = ($RowRevenue.trim('"'))-as[int]
						CalendarMonth = $RowCalendarMonth.trim('"')
						Currency = $RowCurrency.trim('"')
						
						}			
					###End of the row loop
	}
}


FinancialCalculator(){
	
	forEach($k in $this.ArrayData){
		$Index=0
		if($this.FinalArray.Advertiser -contains $k.Advertiser){$Index = $this.FinalArray.indexof($k.Advertiser)}
		if(($this.FinalArray[$Index].Segment -ne $k.Segment) -or ($this.FinalArray[$Index].CalendarMonth -ne $k.CalendarMonth) -or ($this.FinalArray[$Index].Currency -ne $k.Currency)){
			
				$this.FinalArray += [PSCustomObject]@{
				Advertiser = $k.Advertiser
				Segment = $k.Segment
				Revenue = $k.Revenue
				CalendarMonth = $k.CalendarMonth
				Currency = $k.Currency
			}}else{

			write-host $k.Advertiser "is already in line"  $Index
				$this.FinalArray[$Index].Revenue += $k.Revenue

			}


		}			
}


FinancialSum(){
	
	forEach($k in $this.ArrayData){
		$Index=0
		if($this.SumArray.Advertiser -contains $k.Advertiser){
				$Index = $this.FinalArray.indexof($k.Advertiser)
				$this.SumArray[$Index].Revenue += $k.Revenue
					}else{
					$this.SumArray += [PSCustomObject]@{
						Advertiser = $k.Advertiser
						Revenue = $k.Revenue

							}

						}
	

				}


		}
			






###class closure
}
				

			
			
				    		
					

