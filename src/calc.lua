CALC_MSG_ADDONNAME = "calc"
CALC_MSG_VERSION = GetAddOnMetadata("calc","Version")
CALC_MSG_AUTHOR = GetAddOnMetadata("calc", "Author")

COLOR_RED = "|cffff0000";
COLOR_GREEN = "|cff00ff00";
COLOR_BLUE = "|cff0000ff";
COLOR_PURPLE = "|cff700090";
COLOR_YELLOW = "|cffffff00";
COLOR_ORANGE = "|cffff6d00";
COLOR_GREY = "|cff808080";
COLOR_GOLD = "|cffcfb52b";
COLOR_NEON_BLUE = "|cff4d4dff";
COLOR_END = "|r";

calc = {}
calc.stack = {}
calc.useDegree = nil -- set this to true to use degrees

function calc.Print( msg, showName )
	-- print to the chat frame
	-- set showName to false to suppress the addon name printing
	if (showName == nil) or (showName) then
		msg = COLOR_RED..CALC_MSG_ADDONNAME.." ("..(calc.useDegree and "d" or "r")..")> "..COLOR_END..msg;
	end
	DEFAULT_CHAT_FRAME:AddMessage( msg );
end
function calc.ShowStack()
	calc.Print( table.concat( calc.stack, " " ) )
end

function calc.Add()
	if table.getn(calc.stack) >= 2 then
		table.insert( calc.stack, ( table.remove( calc.stack ) + table.remove( calc.stack ) ) )
	end
end
function calc.Sub()
	if table.getn(calc.stack) >= 2 then
		table.insert( calc.stack, ( (0 - table.remove( calc.stack ) ) + table.remove( calc.stack ) ) )
	end
end
function calc.Mul()
	if table.getn(calc.stack) >= 2 then
		table.insert( calc.stack, ( table.remove( calc.stack ) * table.remove( calc.stack ) ) )
	end
end
function calc.Div()
	if table.getn(calc.stack) >= 2 then
		local d = table.remove( calc.stack )
		if d == 0 then
			table.insert( calc.stack, d )
			calc.Print("Cannot divide by zero.  Number pushed back on the stack")
		else
			table.insert( calc.stack, ( table.remove( calc.stack ) / d ) )
		end
	end
end
function calc.Sin()
	if table.getn(calc.stack) >= 1 then
		local val = ( calc.useDegree and ( table.remove( calc.stack ) * ( math.pi / 180 ) ) or table.remove( calc.stack ) )
		table.insert( calc.stack, ( math.sin( val ) ) )
	end
end
function calc.Cos()
	if table.getn(calc.stack) >= 1 then
		local val = ( calc.useDegree and ( table.remove( calc.stack ) * ( math.pi / 180 ) ) or table.remove( calc.stack ) )
		table.insert( calc.stack, ( math.cos( val ) ) )
	end
end
function calc.Tan()
	if table.getn(calc.stack) >= 1 then
		local val = ( calc.useDegree and ( table.remove( calc.stack ) * ( math.pi / 180 ) ) or table.remove( calc.stack ) )
		table.insert( calc.stack, ( math.tan( val ) ) )
	end
end
function calc.Power()
	if table.getn(calc.stack) >= 2 then
		local toPower = table.remove( calc.stack )
		table.insert( calc.stack, ( math.pow( table.remove( calc.stack ), toPower ) ) )
	end
end
function calc.Log()
	if table.getn(calc.stack) >= 1 then
		table.insert( calc.stack, ( math.log( table.remove( calc.stack ) ) ) )
	end
end
calc.functions = {
	-- commands
	["ac"] = function() calc.stack={} end,
	["deg"] = function() calc.useDegree = true calc.Print("Set to use Degrees") end,
	["rad"] = function() calc.useDegree = nil calc.Print("Set to use Radians") end,
	-- functions
	["+"] = calc.Add,
	["-"] = calc.Sub,
	["*"] = calc.Mul,
	["/"] = calc.Div,
	["sin"] = calc.Sin,
	["cos"] = calc.Cos,
	["tan"] = calc.Tan,
	["^"] = calc.Power,
	["ln"] = calc.Log,
	-- constants
	["pi"] = function() table.insert( calc.stack, math.pi ) end,
	["e"] = function() table.insert( calc.stack, math.exp(1) ) end,
}

function calc.Parse( msg )
	if msg then
		local a, b, c = strfind( msg, "(%S+)" )  -- location, size, matched
		--print(string.format("msg: %s [] %s - %s - %s", msg, a, b, c ) )
		if a then -- found a number
			return c, strsub(msg, b+2)
		else
			return nil
		end
	end
end
function calc.Command( msg )
	while msg and string.len(msg) > 0 do
		msg = string.lower(msg)
		--print( msg, string.len(msg) )
		val, msg = calc.Parse( msg )
		if val then
			if calc.functions[val] then
				calc.functions[val]()
			elseif tonumber(val) then -- is a value
				table.insert( calc.stack, tonumber(val) )
			else
				print("?:"..val..":?")
			end
		end
		--print( val, msg )
	end
	calc.ShowStack()
end

SLASH_CALC1 = "/CALC"
SlashCmdList["CALC"] = calc.Command
