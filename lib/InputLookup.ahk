inputLookup(prompt) {
	breakLoop := false
	loop {
		retVal := InputChar4Lookup(prompt)
		if (breakLoop)
			return retVal
	}
}