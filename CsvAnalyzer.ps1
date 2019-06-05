

class CsvAnalyzer: File{

[int]$RowNumbers
[int]$ColumnNumbers
[boolean]$DelimitatorsOk
[object]$CsvFile
[boolean]$FileValidatedOk
[String]$LogDelimitators
[String]$Encoding


CsvAnalyzer($FilePath) : base ($FilePath) {
$this.RowNumbers = 12
$this.CsvFile = Get-Content $FilePath
$this.RowNumbers = $this.CsvFile.Length
$this.CheckValidity()
$this.GetFileEncoding()

}

[String]LogGetter(){

return $this.LogDelimitators

}

[String]FormatGetter(){

return $this.Encoding
}

#####This will just check we have the right number of columns everywhere

CheckValidity(){
	$i = 2
	[int]$SemiNumber = 0

	forEach($l in $this.CsvFile){	
		$rowString = $l.toCharArray()
		forEach($letter in $rowString){
			if ($letter -eq ";"){
			$SemiNumber +=1
			}
}			
		if($SemiNumber -ne 32 ){
			$this.LogDelimitators = $this.LogDelimitators + "\nWARNING: he number of delimitators does not seem correct at line: " + $i + ". Number of delimitators: " + $SemiNumber	
		}
		$SemiNumber = 0
		$i += 1		
		}	
		if([String]::IsNullOrEmpty($this.LogDelimitators)){
			$this.LogDelimitators = "There does not seem to be any issues with the delimitators and the number of columns." + "`n"
		}
		
		
		}

GetFileEncoding(){


    [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $this.FilePath

    if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
    { $this.Encoding =  "UTF8" }
    elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff)
    { $this.Encoding = "Unicode" }
    elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff)
    { $this.Encoding = "UTF32" }
    elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76)
    { $this.Encoding =  "UTF7"}
    else
    { $this.Encoding = "ASCII" }



}




}



