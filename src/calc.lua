#!/usr/bin/env lua

-- over-ride or define stubs for functions
strfind = string.find
strsub = string.sub


function GetAddOnMetadata( )
	return "@VERSION@"
end
SlashCmdList = {}

-- import the addon file
package.path = "/usr/local/bin/?.lua;'" .. package.path
require "c"

-- find ~/.calc
pathSeparator = string.sub( package.config, 1, 1 ) -- first character of this string (http://www.lua.org/manual/5.2/manual.html#pdf-package.config)
settingsFilePath = {
	os.getenv( "HOME" ),
	".calc"
}
settingsFile = table.concat( settingsFilePath, pathSeparator )
-- load ~/.calc
function DoFile( filename )
	local f, err = loadfile( filename )
	if f then
		return f()
	else
		calc_macros = {}
	end
end
DoFile( settingsFile )

-- remove the WowSpecific commands
WowSpecific = {"gold","silver","copper","health","hp",
		"power","haste","mastery","token","xp","xpmax"}
for _, fun in pairs(WowSpecific) do
	calc.functions[fun] = nil
end

-- over-ride some functions.
function calc.Print( msg )
	msg = "> "..msg;
	print( msg )
end

-- add a command to quit
calc.functions["quit"] = function() running=false end
calc.functions["exit"] = calc.functions["quit"]
calc.functions["q"] = calc.functions["quit"]
print("Calc (v@VERSION@)")

-- Start the calculator
running = true
while running do
	io.write( ("(%s)> "):format( calc.useDegree and "d" or "r" ) )
	val = io.read("*line")
	calc.Command( val )
end

-- save ~/.calc
file, err = io.open( settingsFile, "w" )
if err then
	print( err )
else
	file:write( "calc_macros = {\n" )
	for mName, mStr in pairs( calc_macros ) do
		file:write( string.format( "\t[\"%s\"] = \"%s\",\n", mName, mStr ) )
	end
	file:write( "}\n")
	io.close( file )
end