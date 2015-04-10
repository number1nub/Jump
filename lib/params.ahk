params(p) 
{
	p := RegExReplace(p , "([^\s])-", "$1<dash>")   ; change - to <dash> to avoid confusion
	regex = (?<=[-|/])([a-zA-Z0-9]*)[ |:|=|"]*([\w|.|@|?|#|$|`%|=|*|,|<|>|^|'|{|}|\[|\]|;|(|)|_|&|+| |:|!|~|/|\\]*)["| ]*(.*)
	
	count:=0
	options:=Object()
	
	while p != "" 
	{
		count++
		
		RegExMatch(p,regex,data) 
		
		name := data1
		value := data2
		value := RegExReplace(value , "<dash>", "-")   ; change <dash> back to -        
				
		if (value = "") {
			options[name] := 1
		} else {
			options[name] := value
		}
		
		p := data3
	}
	ErrorLevel := count 
	Return options
}