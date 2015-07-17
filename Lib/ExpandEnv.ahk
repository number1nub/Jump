
/*!
	Function: ExpandEnv(str)
		Convert all environment variables in str to their values.
	Parameters:
		str - String containing environment variables to be expanded.
	Returns:
		The passed string with all environment variables expanded to their values.
*/
ExpandEnv(str) {
   VarSetCapacity(dest, 2000)
   DllCall("ExpandEnvironmentStrings", "str", str, "str", dest, int, 1999, "Cdecl int")
   Return dest
}