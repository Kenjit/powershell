
#################################
#	Class File		#                             
#################################




class File{

[string]$FileName
[string]$FilePath
[string]$FileExtension

File($FilePath){
$this.FileName = Split-Path $FilePath -leaf
$this.FileExtension= (Split-Path -Path $FilePath -Leaf).Split(".")[-1];
$this.FilePath = $FilePath
}


[String]GetFileName(){

	return $this.FileName
}
[String]GetFilePath(){
	return $this.FilePath
}

[String]GetFileExtension(){
	return $this.FileExtension
}

}