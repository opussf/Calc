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
calc.functions["gold"] = nil
calc.functions["silver"] = nil
calc.functions["copper"] = nil
calc.functions["health"] = nil
calc.functions["hp"] = nil
calc.functions["power"] = nil

-- over-ride some functions.
function calc.Print( msg )
	msg = "("..(calc.useDegree and "d" or "r")..")> "..msg;
	print( msg )
end

-- add a command to quit
calc.functions["quit"] = function() running=false end
print("Calc (v@VERSION@)")

-- Start the game
running = true
while running do
	io.write("> ")
	val = io.read("*line")
	calc.Command( val )
end