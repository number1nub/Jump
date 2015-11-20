Args(argStr) {
	static regex := "(?<=[-|/])([a-zA-Z0-9]*)[ |:|=|""|']*([\w|.|@|?|#|$|`%|=|*|,|<|>|^|{|}|\[|\]|;|(|)|_|&|+| |:|!|~|\\]*)[""| |']*(.*)"
	count:=0, options:=[], argStr:=argStr.REReplace("(?:([^\s])-|(\s+)-(\s+))", "$1$2<dash>$3").REReplace("(?:([^\s])/|(\s+)/(\s+))", "$1$2<slash>$3")
	while (argStr) {
		count++
		argStr.Match(regex, data)
		value := data2.REReplace("<dash>", "-").REReplace("<slash>", "/")
		options[data1] := value ? value : 1
		argStr := data3
	}
	ErrorLevel := count
	return options
}