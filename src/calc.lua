#!/usr/bin/env lua

-- over-ride or define stubs for functions
strfind = string.find
strsub = string.sub


function GetAddOnMetadata( )
	return "@VERSION@"
end
SlashCmdList = {}

-- import the addon file
require "calc"

-- remove the WowSpecific commands
WowSpecific = {"gold","silver","copper","health","hp","power","haste","mastery","honor","conquest","cp","valor","vp","justice","jp"}
for _, fun in pairs(WowSpecific) do
	calc.functions[fun] = nil
end

-- over-ride some functions.
function calc.Print( msg )
	msg = "("..(calc.useDegree and "d" or "r")..")> "..msg;
	print( msg )
end

-- add a command to quit
calc.functions["quit"] = function() running=false end
calc.functions["exit"] = calc.functions["quit"]
print("Calc (v@VERSION@)")

-- Start the game
running = true
while running do
	io.write("> ")
	val = io.read("*line")
	calc.Command( val )
end