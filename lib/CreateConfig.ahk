CreateConfig(fPath) {
	cfgTemplate =
	(LTrim
	;---------------------------------------------------------------------------------------------------
	; 	GLOBAL SETTINGS
	;		Customizable settings that the user may modify to customize the appearance and default
	;		behaviors of the application. Any missing, blank or invalid setting values will be ignored
	;		and the default value (see below for details on all available settings) will be used.
	;
	; 	AVAILABLE SETTINGS
	;		DefaultBrowser 	- Specify the browser path to be used in cases where a Lookup command
	;						  does not have a _path setting defined.
	;						  Default: iexplore.exe.
	;		FadeOnShow		- Set to 1 to enable fade-in effect when GUI is shown (FadeSpeed option
	;						  customizes this effect).
	;						  Default: 1
	;		FadeOnExit		- Set to 1 to enable fade-out effect when GUI is closing (FadeSpeed option
	;						  customizes this effect).
	;						  Default: 1
	;		FadeSpeed 		- Sets the speed factor at which the GUI will fade in/out using a value
	;						  from 1 to 5 where 1=slowest and 5=fastest.
	;						  Default: 2
	;		Transparency	- Set the GUI's degree of transparency using a value from 0 to 255 where
	;						  0=invisible and 255=opaque/normal.
	;						  Default: 210
	;		BackColor		- Set the GUI background color by specifying either a valid color name
	;						  (eg. Black) or an hex color code (eg. FF0000).
	;						  Default: Yellow
	;		TextColor		- Set the text color by specifying either a valid color name (eg. Black)
	;						  or an hex color code (eg. FF0000).
	;						  Default: Red
	;		Font            - Specify the text's font by specifying a valid font name.
	;						  Default: Arial
	;		DClickAction    - Set the action that will be performed when the GUI is double-clicked by
	;						  specifying either 'S' (open the settings file), 'E' (edit the Jump.ahk script)
	;						  or 'R' (reload the Jump.ahk script).
	;						  Default: S
	;		NoInputAction   - Set the action that will be performed if a blank input is submitted by
	;						  specifying either 'S' (open the settings file), 'E' (edit the Jump.ahk script)
	;						  or 'L' (repeat the last command). When the 'L' option is enabled, this
	;						  feature provides a convinient way to quickly re-launch the last command
	;						  by simply displaying the GUI and pressing <Space> or <Enter>.
	;						  Default: L
	;---------------------------------------------------------------------------------------------------
	[GlobalSettings]
	DefaultBrowser = iexplore.exe
	FadeOnShow     = 1
	FadeOnExit     = 1
	FadeSpeed      = 2
	Transparency   = 210
	BackColor      = Yellow
	TextColor      = Red
	Font           = Arial
	DClickAction   = S
	NoInputAction  = L


	;---------------------------------------------------------------------------------------------------
	;	USER VARIABLES
	;		This section contains a user-defined list of variable names that correspond to string
	;		"replacement" values. The variables can then be used within other setting values by
	;		 preceding its name with a dollar-sign ($VarName). Upon execution of a command, any UserVars
	;		 are replaced with their string replacement values defined in this section.
	;
	;	BUILT-IN VARIABLES
	;		SETTINGS - Replaced with the full path to the user's settings file
	;		ME       - Replaced with the full path to the user's Jump.ahk file
	;
	;		These variables are available by default and are handled exactly like custom UserVars.
	;		Note that built-in variable names are reserved and **CANNOT** be used as a UserVar name.
	;
	;	BENEFITS OF USERVARS
	;		* UserVars greatly simplify the process of adding and managing setting entries by reducing
	;		  the amount of unnecessary duplicate text
	;		* Readability and organization of settings is greatly increased by using UserVars
	;		* UserVars allow for the easy creation of dynamic/context-sensitive setting values, as shown
	;		  in the example below
	;
	;	EXAMPLE
	;		> [UserVars]
	;		> PF = C:\Program Files
	;		>  
	;		> [ShortCuts]
	;		> myProg = $PF\SomeFolderName\something.exe
	;---------------------------------------------------------------------------------------------------
	[UserVars]
	PF       = C:\Program Files
	PF86     = C:\Program Files (x86)
	MDOCS    = %USERPROFILE%\Documents


	;---------------------------------------------------------------------------------------------------
	;	SHORTCUTS
	;		The user's list of shortcut entries. A shortcut entry consists of a trigger string
	;		and a command; when a shortcut's trigger is entered, its corresponding command is passed
	;		to the command line and executed. See the [shortcutSettings] section and the [UserVars]
	;		section for more info on creating and customizing shortcuts.
	;
	;	EXAMPLE
	;		> [shortcuts]
	;		> ie = C:\Program Files\Internet Explorer\iexplore.exe
	;---------------------------------------------------------------------------------------------------
	[shortcuts]
	cal         = http://calendar.google.com
	cmd         = %COMSPEC%
	edit        = *edit $ME
	env         = %WINDIR%\System32\SystemPropertiesAdvanced.exe
	gm          = http://www.gmail.com
	n           = notepad
	reg         = regedit
	s           = $SETTINGS
	settings    = $SETTINGS
	

	;---------------------------------------------------------------------------------------------------
	;	SHORTCUT SETTINGS
	;		Settings that define special behavior(s) of shortcut commands. All shortcut settings are
	;		optional, therefore, this section isn't required to have entries and may be empty.
	;		
	;	AVAILABLE SHORTCUT SETTINGS:
	;		WA - A window matching the specified title is activated (if found) instead of running the
	;			 shortcut command. The window title must be specified in an entry whose name is the
	;			 shortcut's name appended with "_Title".
	;		IE - Verifies that a directory exists before opening it, thus avoiding errors (i.e. a usb drive).
	;		WD - Runs the shortcut using the specified folder (specify using a "_workingDir" entry) as the
	;			 working directory. If "_workingDir" isn't specified, the program attempts to set one based
	;			 on the shortcut command's path.
	;		BP - Inserts the browser path specified in a "_Browser" entry in front of the shortcut.
	;
	;	EXAMPLE
	;		> [shortcuts]
	;		> portableDoc = G:\Folder on UsbDrive\Some File.docx
	;		> myfile      = C:\Users\MyUsername\Documents
	;		> 
	;		> [shortcutSettings]
	;		> portableDoc  = -ie
	;		> mydocs       = -wa
	;		> mydocs_Title = C:\Windows
	;---------------------------------------------------------------------------------------------------
	[shortcutSettings]
	settings       = -wa
	settings_Title = Settings.ini


	;---------------------------------------------------------------------------------------------------
	;	LOOKUPS
	;		The user's list of lookup entries. A lookup entry consists of a trigger string (cannot
	;		contain spaces), and a prompt string. When a lookup's trigger is entered, its corresponding
	;		prompt string is displayed and the program waits for a second input from the user. See the
	;		[lookupSettings] and [UserVars] sections for more info on creating and customizing lookups.
	;
	;		**NOTE: ALL PROMPT STRINGS MUST BE ENCLOSED IN QUOTES**
	;
	;	EXAMPLE
	;		> [lookups]
	;		> goog = "Search query: "
	;		> map = "Address: "
	;---------------------------------------------------------------------------------------------------
	[lookups]
	d     = "Define: "
	e     = "Explore: "
	g     = "Search: "
	go    = "URL: "
	kill  = "Process: "
	map   = "GoogleMaps "
	yt    = "YouTube: "


	;---------------------------------------------------------------------------------------------------
	;	LOOKUP SETTINGS
	;		Settings that define the behavior of lookup commands. There are 2 settings available
	;		for lookups: the "input" setting, which is REQUIRED, and the optional "path" setting. An
	;		"input" setting value MUST be defined for each lookup entry within this section, and should
	;		contain the placeholder text "[lookup]", which will be replaced with the user's input.
	;
	;		Specify a lookup's "input" setting by creating an entry with the same name as the lookup,
	;		appended with "_input". Specify a lookup's "path" setting by creating an entry with "_path"
	;		appended to the lookup's name. See the example below for clarification.
	;
	;	AVAILABLE LOOKUP SETTINGS
	;		Input -	Required setting that defines the argument passed to the command line when executed.
	;				The input setting value should contain the placeholder string "[lookup]", which will
	;				be replaced with the user's input on execution. Note that the entire input setting
	;				value will be enclosed in quotation marks, and, if defined appended to the "path"
	;				setting value, separated by a single space. This allows arguments that contain
	;				spaces to be passed without issues.
	;		Path -	(Optional) A path or command that will be executed when a lookup is launched. The
	;				the "input" setting value will be surrounded with quotes and appended to the "path"
	;				specified, separated by a single space.
	;
	;	EXAMPLE
	;		> [lookups]
	;		> g = "Enter Search: "
	;		> d = "Word: "
	;		> 
	;		> [lookupSettings]
	;		> g_input = http://google.com/search?q=[lookup]
	;		> d_input = http://dictionary.com/browse/[lookup]
	;		> d_path = iexplore.exe
	;---------------------------------------------------------------------------------------------------
	[lookupSettings]
	d_input       = http://www.dictionary.com/browse/[lookup]
	e_input       = [lookup]
	e_path        = explorer
	g_input       = http://google.com/search?q=[lookup]
	go_input      = [lookup]
	kill_input    = [lookup]*
	kill_path     = taskkill.exe /F /IM
	map_input     = http://maps.google.com/maps?q=[lookup]&hl=en
	yt_input      = http://www.youtube.com/results?search_query=[lookup]


	;---------------------------------------------------------------------------------------------------
	;	INTERNAL SETTINGS
	;		**DON'T MESS WITH ANYTHING IN THIS SECTION!**
	;
	;		Settings and configurations in this section are created and modified internally by the
	;		application and **SHOULD NOT BE MODIFIED DIRECTLY**.
	;---------------------------------------------------------------------------------------------------
	[InternalSettings]
	LastInput=settings
	LastType=S
	)
	
	try {
		SplitPath, fPath, fName, fDir
		IfExist, %fPath%
			FileDelete, %fPath%
		sleep 100
		IfNotExist, %fDir%
		{
			FileCreateDir, %fDir%
			sleep 100
		}
		FileAppend, %cfgTemplate%, %fPath%
		sleep 100		
	}
	catch e
	{
		throw e
	}
}