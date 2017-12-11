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
	if #calc.stack >= 2 then
		calc.Push( calc.Pop() + calc.Pop() )
	end
end
function calc.Sub()
	-- instead of poping 2 values to temp variables, this is done by
	-- adding the negative of the last number.
	-- 4 3 -  = 4 -3 +
	if #calc.stack >= 2 then
		calc.Push( (0 - calc.Pop() ) + calc.Pop() )
	end
end
function calc.Mul()
	if #calc.stack >= 2 then
		calc.Push( calc.Pop() * calc.Pop() )
	end
end
function calc.Div()
	-- division does need a temp variable for checking and calculation
	if #calc.stack >= 2 then
		local d = calc.Pop()
		if d == 0 then
			calc.Push( d )
			calc.Print("Cannot divide by zero.  Number pushed back on the stack.")
		else
			calc.Push( calc.Pop() / d )
		end
	end
end
function calc.oneOver()
	-- calc 1/x  (1/2 = 0.5)
	if #calc.stack >= 1 then
		calc.Push( 1 )
		calc.Swap()
		calc.Div()
	end
end
function calc.Percent()
	-- give the percent of a value
	-- "1000 10 %"  = "1000 10 100 / *"
	if #calc.stack >= 2 then
		local b = calc.Pop()
		local a = calc.Pop()
		calc.Push( a )
		calc.Push( a )
		calc.Push( b )
		calc.Push( 100 )
		calc.Div()
		calc.Mul()
	end
end
function calc.Sin()
	if #calc.stack >= 1 then
		local val = ( calc.useDegree and math.rad( calc.Pop() ) or calc.Pop() )
		calc.Push( math.sin( val ) )
	end
end
function calc.Asin()
	if #calc.stack >= 1 then
		local val = math.asin( calc.Pop() )
		-- val is in rad
		calc.Push( ( calc.useDegree and math.deg( val ) or val ) )
	end
end
function calc.Cos()
	if #calc.stack >= 1 then
		local val = ( calc.useDegree and math.rad( calc.Pop() ) or calc.Pop() )
		calc.Push( math.cos( val ) )
	end
end
function calc.Acos()
	if #calc.stack >= 1 then
		local val = math.acos( calc.Pop() )
		-- val is in rad
		calc.Push( ( calc.useDegree and math.deg( val ) or val ) )
	end
end
function calc.Tan()
	if #calc.stack >= 1 then
		local val = ( calc.useDegree and math.rad( calc.Pop() ) or calc.Pop() )
		calc.Push( math.tan( val ) )
	end
end
function calc.Atan()
	if #calc.stack >= 1 then
		local val = math.atan( calc.Pop() )
		calc.Push( ( calc.useDegree and math.deg( val ) or val ) )
	end
end
function calc.Power()
	-- the calculator button reads y^x.
	-- can I define a sqrt command that pushes 0.5 and calls ^?
	-- can I define a ^2 that pushes 2 and calls ^?
	if #calc.stack >= 2 then
		local toPower = calc.Pop()
		calc.Push( math.pow( calc.Pop(), toPower ) )
	end
end
function calc.Log()
	if #calc.stack >= 1 then
		calc.Push( math.log( calc.Pop() ) )
	end
end
function calc.Factorial()
	--  EH!  http://www.springerplus.com/content/pdf/2193-1801-3-658.pdf
	if #calc.stack >= 1 then
		local val = calc.Pop() * 1.0
		if val < 0 then calc.Push( math.huge )
		elseif val == 0 then calc.Push( 1 )
		else
			fac = 1
			for i=val,1,-1 do
				fac = fac * i
			end
			calc.Push( fac )
		end
	end
end
function calc.Swap()
	-- RPN should let you swap the most recent 2 values on the stack  X <=> Y
	local X = calc.Pop()
	local Y = calc.Pop()
	calc.Push( X )
	calc.Push( Y )
end
function calc.ToC()
	-- F 32 - 9 5 / /
	if #calc.stack >= 1 then
		calc.Push( 32 )
		calc.Sub()
		calc.Push( 9 )
		calc.Push( 5 )
		calc.Div()
		calc.Div()
	end
end
function calc.ToF()
	-- C 9 5 / * 32 +
	if #calc.stack >= 1 then
		calc.Push( 9 )
		calc.Push( 5 )
		calc.Div()
		calc.Mul()
		calc.Push( 32 )
		calc.Add()
	end
end

function calc.Help()
	calc.Print(CALC_MSG_ADDONNAME.." v"..CALC_MSG_VERSION, false)
	calc.Print("is a RPN calculator. Where '5 2 -' subtracts 2 from 5.", false)
	calc.Print("   AC   - clear the stack", false)
	calc.Print("   deg / rad  - change to degrees or radians for trig functions.", false)
	calc.Print("   pop  - remove last value on stack", false)
	calc.Print("   swap - swap last 2 values", false)
	calc.Print("   fhelp - list of functions", false)
	calc.Print("   whelp - list of variables from WoW", false)
end
function calc.FHelp()
	calc.Print("+ - * / % ^ ln ! pi e", false)
	calc.Print("sin cos tan asin acos atan", false)
	calc.Print("1/x")
end
function calc.WHelp()
	calc.Print("gold silver copper -- current money in those units", false)
	calc.Print("health hp -- current health", false)
	calc.Print("power -- max rage / mana / power", false)
	calc.Print("haste mastery -- your current values", false)
	calc.Print("conquest cp -- conquest points", false)
	calc.Print("honor -- honor points", false)
	calc.Print("justice jp -- justice points", false)
	calc.Print("valor vp -- valor points", false)
end
calc.functions = {
	["help"] = calc.Help,
	["fhelp"] = calc.FHelp,
	["whelp"] = calc.WHelp,

	-- commands
	["ac"] = function() calc.stack={} end,
	["deg"] = function() calc.useDegree = true calc.Print("Set to use Degrees") end,
	["rad"] = function() calc.useDegree = nil calc.Print("Set to use Radians") end,
	["pop"] = calc.Pop,
	["swap"] = calc.Swap,
	["1/x"] = calc.oneOver,
	-- functions
	["+"] = calc.Add,
	["-"] = calc.Sub,
	["*"] = calc.Mul,
	["/"] = calc.Div,
	["%"] = calc.Percent,
	["sin"] = calc.Sin,
	["cos"] = calc.Cos,
	["tan"] = calc.Tan,
	["asin"] = calc.Asin,
	["acos"] = calc.Acos,
	["atan"] = calc.Atan,
	["^"] = calc.Power,
	["ln"] = calc.Log,
	["!"] = calc.Factorial,
	-- constants
	["pi"] = function() calc.Push( math.pi ) end,
	["e"] = function() calc.Push( math.exp(1) ) end,
	-- tempConversions
	["toc"] = calc.ToC,
	["tof"] = calc.ToF,
	-- wowVariables
	["gold"] = function() table.insert( calc.stack, GetMoney() / 10000 ) end,
	["silver"] = function() table.insert( calc.stack, GetMoney() / 100 ) end,
	["copper"] = function() table.insert( calc.stack, GetMoney() ) end,
	["health"] = function() calc.Push( UnitHealthMax('player') ) end,
	["hp"] = function() calc.Push( UnitHealthMax('player') ) end,
	["power"] = function() calc.Push( UnitPowerMax('player') ) end,
	["haste"] = function() calc.Push( GetHaste() ) end,
	["mastery"] = function() calc.Push( GetMastery() ) end,
	["conquest"] = function() calc.Push( select(2, GetCurrencyInfo(390) ) or 0 ) end,
	["cp"] = function() calc.Push( select(2, GetCurrencyInfo(390) ) or 0 ) end,
	["honor"] = function() calc.Push( select(2, GetCurrencyInfo(392) ) or 0 ) end,
	["justice"] = function() calc.Push( select(2, GetCurrencyInfo(395) ) or 0 ) end,
	["jp"] = function() calc.Push( select(2, GetCurrencyInfo(395) ) or 0 ) end,
	["valor"] = function() calc.Push( select(2, GetCurrencyInfo(396) ) or 0 ) end,
	["vp"] = function() calc.Push( select(2, GetCurrencyInfo(396) ) or 0 ) end,
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
