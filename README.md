JUMP LAUNCHER
=============
Jump Launcher is the ultimate "minimal" launcher & command utility that can be as simple or powerfully customized as you'd like. With as little as 2 strokes of the keyboard you can:

- Launch a file, folder, application, shortcut or any other file/web path
- Execute any Windows commands, run custom AutoHotkey commands, functions, scripts, etc.
- Use **Lookups** for ultimate flexibility and customization by prompting the user for an input value which is then used in the launched command


Global Settings
-------------------
Customizable settings that the user may modify to customize the appearance and default
behaviors of the application. Any missing, blank or invalid setting values will be ignored
and the default value (see below for details on all available settings) will be used.

Available Settings
* **DefaultBrowser** 	- Specify the browser path to be used in cases where a Lookup command
				  does not have a _path setting defined. Default is iexplore.exe.
* **FadeOnShow**		- Enable/disable the fade-in effect when showing the GUI. Enable fade-in
				  by setting to 1. If blank, omitted, invalid or 0, GUI displays instantly
* **FadeOnExit**		- Enable/disable the fade-out effect when closing the GUI. Enable fade-out
				  by setting to 1. If blank, omitted, invalid or 0, GUI closes instantly.
* **FadeSpeed** 		- Set the speed of the GUI fade-in/out using a value from 1 to 5 where
				  1 is slowest and 5 is fastest.
* **DClickAction**    - Indicate the action to be performed when the GUI is double-clicked by
				  specifying one of the following options: S (open the settings file),
				  E (edit the jump.ahk script) or R (reload jump.ahk script). The default
				  action is S (open settings).
* **BackColor**		- Set the GUI background color by specifying either a valid color name
				  (eg. Black) or an hex color code (eg. FF0000). The default is black.
* **TextColor**		- Set the text color by specifying either a valid color name (eg. Black)
				  or an hex color code (eg. FF0000). The default is aqua.
* **Font**            - Specify the text's font by specifying a valid font name. Default is Arial.

User Variables
--------------------
This section contains a user-defined list of variables that correspond to string
"replacement" values. The variables can then be used within any setting value entry using
the dereferencing syntax shown in the *how to use* section below.

#### Built-In Variables
These variables are available by default and are handled exactly the same as custom UserVars.
* **SETTINGS** - Replaced with the full path to the user's settings file
* **ME**       - Replaced with the full path to the user's Jump.ahk file

	> **NOTE:** Built-in variable names are reserved. entries named the same as a built-in are ignored

#### How To Use
Use a custom variable within a setting value by preceding its name with a dollar-sign, as
shown in the example below. The variable will be dereferenced (replaced with its value)
when the shortcut or lookup is launched.

#### Benefits Of Uservars
* UserVars greatly simplify the process of adding and managing setting entries by reducing
  the amount of unnecessary duplicate text
* Readability and organization of settings is greatly increased by using UserVars
* UserVars allow for the easy creation of dynamic/context-sensitive setting values, as shown
  in the example below

#### Example
	[UserVars]
	MDOCS = %USERPROFILE%\Documents
	PF = C:\Program Files
	 
	[ShortCuts]
	someFile = $MDOCS\myFile.exe
	myProg = $PF\SomeFolderName\something.exe

Shortcuts
---------
The user's list of shortcut entries. A shortcut entry consists of a trigger string
and a command; when a shortcut's trigger is entered, its corresponding command is passed
to the command line and executed. See the [shortcutSettings] section and the [UserVars]
section for more info on creating and customizing shortcuts.

#### Example
```
[shortcuts]
ie = C:\Program Files\Internet Explorer\iexplore.exe
```

Shortcut Settings
-----------------
Settings that define special behavior(s) of shortcut commands. All shortcut settings are
optional, therefore, this section isn't required to have entries and may be empty.

#### Available Shortcut Settings:
* **WA** - A window matching the specified title is activated (if found) instead of running the
	 shortcut command. The window title must be specified in an entry whose name is the
	 shortcut's name appended with "_Title".
* **IE** - Verifies that a directory exists before opening it, thus avoiding errors (i.e. a usb drive).
* **WD** - Runs the shortcut using the specified folder (specify using a "_workingDir" entry) as the
	 working directory. If "_workingDir" isn't specified, the program attempts to set one based
	 on the shortcut command's path.
* **BP** - Inserts the browser path specified in a "_Browser" entry in front of the shortcut.

#### Example
	[shortcuts]
	usb = G:\
	mydocs = C:\Users\MyUsername\Documents

	[shortcutSettings]
	usb = -ie
	mydocs = -wa
	mydocs_Title = C:\Windows

Lookups
--------------------
The user's list of lookup entries. A lookup entry consists of a trigger string (cannot
contain spaces), and a prompt string. When a lookup's trigger is entered, its corresponding
prompt string is displayed and the program waits for a second input from the user. See the
[lookupSettings] and [UserVars] sections for more info on creating and customizing lookups.

> **NOTE:** ALL PROMPT STRINGS MUST BE ENCLOSED IN QUOTES

#### Example
    [lookups]
    goog = "Search query: "
    map = "Address: "

Lookup Settings
--------------------
Settings that define the behavior of lookup commands. There are 2 settings available
for lookups: the "input" setting, which is REQUIRED, and the optional "path" setting. An
"input" setting value MUST be defined for each lookup entry within this section, and should
contain the placeholder text "[lookup]", which will be replaced with the user's input.

Specify a lookup's "input" setting by creating an entry with the same name as the lookup,
appended with "_input". Specify a lookup's "path" setting by creating an entry with "_path"
appended to the lookup's name. See the example below for clarification.

#### Available Lookup Settings
* **Input** -	Required setting that defines the argument passed to the command line when executed.
		The input setting value should contain the placeholder string "[lookup]", which will
		be replaced with the user's input on execution. Note that the entire input setting
		value will be enclosed in quotation marks, and, if defined appended to the "path"
		setting value, separated by a single space. This allows arguments that contain
		spaces to be passed without issues.
* **Path** -	(Optional) A path or command that will be executed when a lookup is launched. The
		the "input" setting value will be surrounded with quotes and appended to the "path"
		specified, separated by a single space.

#### Example
```
[lookups]
g = "Enter Search: "
d = "Word: "

[lookupSettings]
g_input = http://google.com/search?q=[lookup]
d_input = http://dictionary.com/browse/[lookup]
d_path = iexplore.exe
```

Internal Settings
-----------------
> **DON'T MESS WITH ANYTHING IN THIS SECTION!**

Settings and configurations in this section are created and modified internally by the
application and **SHOULD NOT BE MODIFIED DIRECTLY**.

