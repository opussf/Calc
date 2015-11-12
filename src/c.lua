#!/usr/bin/env lua

-- over-ride or define stubs for functions
strfind = string.find
strsub = string.sub

-- Define those from the WoW API
function GetAddOnMetadata( )
	return "@VERSION@"
end
SlashCmdList = {}

-- import the addon file
require "calc"

-- over-ride some functions.
function calc.Print( msg )
	msg = "("..(calc.useDegree and "d" or "r")..")> "..msg;
	print( msg )
end

-- Start the game
running = true
while running do
	io.write("> ")
	val = io.read("*line")
	calc.Command( val )
end