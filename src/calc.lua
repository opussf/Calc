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
function calc.Push( val )
	table.insert( calc.stack, val )
end
function calc.Pop()
	return table.remove( calc.stack )
end
function calc.ShowStack()
	calc.Print( table.concat( calc.stack, " " ) )
end

function calc.Add()
	if table.getn(calc.stack) >= 2 then
		calc.Push( calc.Pop() + calc.Pop() )
	end
end
function calc.Sub()
	-- instead of poping 2 values to temp variables, this is done by
	-- adding the negitive of the last number.
	-- 4 3 -  = 4 -3 +
	if table.getn(calc.stack) >= 2 then
		calc.Push( (0 - calc.Pop() ) + calc.Pop() )
	end
end
function calc.Mul()
	if table.getn(calc.stack) >= 2 then
		calc.Push( calc.Pop() * calc.Pop() )
	end
end
function calc.Div()
	-- division does need a temp variable for checking and calculation
	if table.getn(calc.stack) >= 2 then
		local d = calc.Pop()
		if d == 0 then
			calc.Push( d )
			calc.Print("Cannot divide by zero.  Number pushed back on the stack.")
		else
			calc.Push( calc.Pop() / d )
		end
	end
end
function calc.Sin()
	if table.getn(calc.stack) >= 1 then
		local val = ( calc.useDegree and ( calc.Pop() * ( math.pi / 180 ) ) or calc.Pop() )
		calc.Push( math.sin( val ) )
	end
end
function calc.Cos()
	if table.getn(calc.stack) >= 1 then
		local val = ( calc.useDegree and ( calc.Pop() * ( math.pi / 180 ) ) or calc.Pop() )
		calc.Push( math.cos( val ) )
	end
end
function calc.Tan()
	if table.getn(calc.stack) >= 1 then
		local val = ( calc.useDegree and ( calc.Pop() * ( math.pi / 180 ) ) or calc.Pop() )
		calc.Push( math.tan( val ) )
	end
end
function calc.Power()
	-- the calculator button reads y^x.
	-- can I define a sqrt command that pushes 0.5 and calls ^?
	-- can I define a ^2 that pushes 2 and calls ^?
	if table.getn(calc.stack) >= 2 then
		local toPower = calc.Pop()
		calc.Push( math.pow( calc.Pop(), toPower ) )
	end
end
function calc.Log()
	if table.getn(calc.stack) >= 1 then
		calc.Push( math.log( calc.Pop() ) )
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
	["pi"] = function() calc.Push( math.pi ) end,
	["e"] = function() calc.Push( math.exp(1) ) end,
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
