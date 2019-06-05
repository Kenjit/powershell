

class FileAnalyzerGUI{
	
	FileAnalyzerGUI(){


function Find-Folders {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.OpenFileDialog

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false
		
		return $browse.FileName
		
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                #Ends script
                return
            }
        }
    }
    
    $browse.Dispose()
} 

function Find-Folders2 {
    [Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $browse = New-Object System.Windows.Forms.FolderBrowserDialog

    $loop = $true
    while($loop)
    {
        if ($browse.ShowDialog() -eq "OK")
        {
        $loop = $false
		
		return $browse.SelectedPath 
		
        } else
        {
            $res = [System.Windows.Forms.MessageBox]::Show("You clicked Cancel. Would you like to try again or exit?", "Select a location", [System.Windows.Forms.MessageBoxButtons]::RetryCancel)
            if($res -eq "Cancel")
            {
                #Ends script
                return
            }
        }
    }
    
    $browse.Dispose()
} 







Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='File Analyzer'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true
$main_form.BackColor = "white"


$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Hi, this is a tool to automatically analyze, clean and process data"
$Label.Font = 'Arial, 12pt, style=Bold'
$Label.Location  = New-Object System.Drawing.Point(10,60)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)

$Label_2 = New-Object System.Windows.Forms.Label
$Label_2.Text = "Please select the file to clean:"
$Label_2.Font = 'Arial, 12pt, style=Regular'
$Label_2.Location  = New-Object System.Drawing.Point(10,100)
$Label_2.AutoSize = $true
$main_form.Controls.Add($Label_2)




$Button = New-Object System.Windows.Forms.Button
$Button.Width = 150
$Button.Height = 20
$Button.Location = New-Object System.Drawing.Point(10,130)
$Button.Text = "Select your file"
$main_form.controls.add($Button)


$LeaveButton = New-Object System.Windows.Forms.Button
$LeaveButton.Width = 150
$LeaveButton.Height = 20
$LeaveButton.Location = New-Object System.Drawing.Point(10,160)
$LeaveButton.Text = "Leave"
$main_form.controls.add($LeaveButton)

$ResultsTextBox = New-Object System.Windows.Forms.TextBox
$ResultsTextBoxAutoSize = $True
$ResultsTextBox.Location = New-Object System.Drawing.Size(10,270)
$ResultsTextBox.Size = New-Object System.Drawing.Size(600,600)

$ButtonSelectFolder = New-Object System.Windows.Forms.Button
$ButtonSelectFolder.Width = 150
$ButtonSelectFolder.Height = 20
$ButtonSelectFolder.Location = New-Object System.Drawing.Point(10,220)
$ButtonSelectFolder.text = "Select your folder"


$ButtonMainAnalysis = New-Object System.Windows.Forms.Button
$ButtonMainAnalysis.Width = 150
$ButtonMainAnalysis.Height = 20
$ButtonMainAnalysis.Location = New-Object System.Drawing.Point(10,190)
$ButtonMainAnalysis.text = "Proceed to the reports"
$global:Path
$ExportPath = ""

$Button.Add_Click(
	{    
		$a = Find-Folders
		$MainFile=[File]::new($a)
		$Button.Text = "Change your file"	
		$Label.Text = "You have selected the file" +  $MainFile.GetFileName() +  "`n" + "Path: " + $MainFile.GetFilePath()
		$global:Path = $MainFile.GetFilePath()
		$CsvCheck = [CsvAnalyzer]::new($global:Path)
		[String]$Logs = $CsvCheck.LogGetter()
		[String]$Format = $CsvCheck.FormatGetter()
		$ResultsTextBox.Text = $Logs + "`n" + "The format of the file is: " + $Format + "`n"
		$main_form.controls.add($ResultsTextBox)
		$main_form.controls.add($ButtonMainAnalysis)
			
        }
    		)


$ButtonMainAnalysis.Add_Click({$main_form.controls.add($ButtonSelectFolder); $main_form.controls.remove($ResultsTextBox)})

$ButtonSelectFolder.Add_Click(
			{

			[String]$Spacer =  "------------------------------------" 
			[String]$ExportPath = Find-Folders2
			write-host "the export path is:" $ExportPath
			write-host $global:Path "ok"?
			$FinancialAnalysis = [FinancialAnalyzer]::new($global:Path)
			$SumArray= $FinancialAnalysis.GetSumArray()
			$FinalArray= $FinancialAnalysis.GetFinalArray()
			$DuplicateAnalysis = [DistanceAnalyzer]::new($global:Path)
			if($DuplicateAnalysis.PotentialDupArray.Count -gt 0){
				$OutputDuplicates  = "We found 0 potential duplicate"
			}else{$OutputDuplicates = $DuplicateAnalysis.GetDup()}
			[String]$FilePlace =  $ExportPath + "\Report.txt"
			write-host $FilePlace
			 $SumArray + $FinalArray + $OutputDuplicates  | Out-File -LiteralPath $FilePlace
			 
			
			
			

			}
			   )



$LeaveButton.Add_click(
	{
		$main_form.dispose()

	}
			)


$main_form.ShowDialog()

}
}