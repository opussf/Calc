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

-- remove the WowSpecific commands
WowSpecific = {"gold","silver","copper","health","hp",
		"power","haste","mastery","honor","conquest",
		"cp","valor","vp","justice","jp","token"}
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
