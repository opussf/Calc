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
calc_macros = {}
calc_settings = {}
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
function calc.OneOver()
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
function calc.Log10()
	if #calc.stack >= 1 then
		calc.Push( math.log10( calc.Pop() ) )
	end
end
function calc.logy()
	-- calculate logy(x) from "x y logy"
	if #calc.stack >= 2 then
		ly = math.log( calc.Pop() )
		calc.Push( math.log( calc.Pop() ) / ly )
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
function calc.Ceil()
	if #calc.stack >= 1 then
		calc.Push( math.ceil( calc.Pop() ) )
	end
end
function calc.Floor()
	if #calc.stack >= 1 then
		calc.Push( math.floor( calc.Pop() ) )
	end
end
function calc.Round()
	if #calc.stack >= 1 then
		local X = calc.Pop()
		local _, frac = math.modf( X )
		if frac < 0.5 then
			calc.Push( math.floor( X ) )
		else -- >= 0.5
			calc.Push( math.ceil( X ) )
		end
	end
end
function calc.Farey()
	local limit = 10000   -- set this as an option at some point.
	if #calc.stack >= 1 then
		local val = calc.Pop()
		local isNeg = false
		if val < 0 then
			isNeg = true
			val = math.abs( val )
		end
		local whole = math.floor( val )
		local decimal = val - whole
		decimalStr = string.format( "%s", decimal )

		local numerator = { 0, 1 }
		local denominator = { 1, 1 }
		local mediant = 0
		if decimal == 0 then  -- Special case.  whole number becomes that number over 1.
			calc.Push( whole * ( isNeg and -1 or 1 ) )
			calc.Push( 1 )
			return
		end
		repeat  -- since the whole value is removed first,
			-- decrement the limit
			limit = limit - 1
			-- find the mediant
			numerator[3] = numerator[1] + numerator[2]
			denominator[3] = denominator[1] + denominator[2]
			mediant = numerator[3] / denominator[3]

			mediantStr = string.format( "%s", mediant )

			-- test which side of the mediant
			if( mediantStr == decimalStr ) then  -- use strings to test equals (float comparison  etc.....)
				calc.Push( ( numerator[3] + ( whole * denominator[3] ) ) * ( isNeg and -1 or 1 ) )
				calc.Push( denominator[3] )
				limit = 0
				return
			elseif decimal < mediant then  -- less than mediant, get rid of high value
				numerator[2] = numerator[3]
				denominator[2] = denominator[3]
			elseif decimal > mediant then  -- greater than mediant, get rid of low value
				numerator[1] = numerator[3]
				denominator[1] = denominator[3]
			end
		until( limit <= 0 )
		-- if it falls out, set the fraction as the origianl over 1
		calc.Push( val * ( isNeg and -1 or 1 ) )
		calc.Push( 1 )
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
	calc.Print("   mhelp - macro help", false)
	--calc.Print("   infix / rpn - set the calculator parsing mode", false )
end
function calc.FHelp()
	calc.Print("+ - * / % ^ ln ! pi e", false)
	calc.Print("sin cos tan asin acos atan", false)
	calc.Print("1/x toC toF", false)
	calc.Print("ceil floor round", false)
	calc.Print("///", false)
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
	calc.Print("token -- current token price, in gold", false)
end
function calc.MHelp()
	calc.Print("macro <macroName> <macro Contents> -- create or replace macro <macroName>", false)
	calc.Print("macro <macroName> -- show this macro", false)
	calc.Print("macro list -- show macros", false)
	calc.Print("macro del <macroName> -- delete <macroName>", false)
	calc.Print("<macroName> -- use macro", false)
end
calc.functions = {
	["help"] = calc.Help,
	["fhelp"] = calc.FHelp,
	["whelp"] = calc.WHelp,
	["mhelp"] = calc.MHelp,

	-- commands
	["deg"] = function() calc.useDegree = true calc.Print("Set to use Degrees") end,
	["rad"] = function() calc.useDegree = nil calc.Print("Set to use Radians") end,
	-- stack commands
	["ac"] = function() calc.stack={} end,
	["pop"] = calc.Pop,
	["swap"] = calc.Swap,
	["1/x"] = calc.OneOver,
	-- functions
	["+"] = calc.Add,
	["-"] = calc.Sub,
	["*"] = calc.Mul,
	["/"] = calc.Div,
	["1/x"] = calc.OneOver,
	["%"] = calc.Percent,
	["sin"] = calc.Sin,
	["cos"] = calc.Cos,
	["tan"] = calc.Tan,
	["asin"] = calc.Asin,
	["acos"] = calc.Acos,
	["atan"] = calc.Atan,
	["^"] = calc.Power,
	["ln"] = calc.Log,
	["log"] = calc.Log10,
	["logy"] = calc.Logy,
	["!"] = calc.Factorial,
	["ceil"] = calc.Ceil,
	["floor"] = calc.Floor,
	["round"] = calc.Round,
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
	["token"] = function() calc.Push( C_WowTokenPublic.GetCurrentMarketPrice() / 10000 or 0 ) end,

	-- Farey
	["///"] = calc.Farey,
--[[
	-- infix options
	["infix"] = function() calc_settings.useInfix = true; end,
	["rpn"] = function() calc_settings.useInfix = nil; end,
]]
}
------
-- Macro Code
------
function calc.MacroAdd( msg )
	local macroName, macroStr = calc.Parse( msg )
	if macroName then
		if not calc.functions[macroName] then
			calc_macros[macroName] = macroStr
		end
		calc.Print( ("Macro %s set to: %s"):format( macroName, macroStr ) )
	else
		calc.MacroList()
	end
end
function calc.MacroList( msg )
	for mName, mStr in pairs( calc_macros ) do
		calc.Print( (">%s: %s"):format( mName, mStr ), false )
	end
end
function calc.MacroDel( msg )
	local macroName = calc.Parse( msg )
	calc_macros[macroName] = nil
	calc.Print( ("Macro %s has been deleted."):format( macroName ) )
end
calc.macroFunctions = {
	["add"] = calc.MacroAdd,
	["list"] = calc.MacroList,
	["del"] = calc.MacroDel,
}
function calc.Macro( msgIn )
	local cmd, msg = calc.Parse( msgIn )
	if calc.macroFunctions[cmd] then
		calc.macroFunctions[cmd]( msg )
	else
		calc.macroFunctions.add( msgIn )
	end
end
------
-- End Macro Code
------
------
-- infix code
------
function calc.In2end( txtIn )
	-- parse an infix statement.  Push the data to the stack in rpn mode.
	-- return text that is not parseable
	-- set 'incomplete' flag is I think there should be more?
	--print( "START: "..txtIn )
	local result = {}
	local opstack = {}

	-- ( precidence, associativty - 1=left, 2=right)
	local operators = {["+"] = {2,1}, ["-"] = {2,1}, ["*"] = {3,1}, ["/"] = {3,1}, ["^"] = {4,2}, ["%"] = {4,2}, ["!"] = {4,2} }


	local txtOut = {}
	value = {}
	txtIn:gsub(".", function( c )
		--print( "PROCESS: >"..c.."<" )
		v = tonumber(c)
		if( v or c == "." ) then  -- is a number.  append to value or create
			--print( "VALUE:"..c)
			value[#value+1] = c
		elseif operators[c] then -- this is an operator
			--print( "OPERATOR:>"..c.."<" )
			if #txtOut>0 then -- there is SOMETHING in the txtOut queue.....
				--print( "TXTOUT: "..table.concat( txtOut ) )
				calc.ProcessLine( table.concat( txtOut ) )
				--print( "STACK>"..table.concat( calc.stack, " " ) )
				txtOut = {}
			end
			if #value>0 then -- if value is set, push the value to the stack and reset
				result[#result+1] = tonumber( table.concat( value ) )
				value = {}
			end
			while( #opstack > 0 ) do
				-- print( "opstack: "..table.concat( opstack, " " ) )
				-- print( (#opstack)..":"..opstack[#opstack] )
				if( opstack[#opstack] == "(" ) then
					break
				elseif( ( operators[c][2] == 1 and operators[c][1] <= operators[opstack[#opstack]][1] ) or
						( operators[c][2] == 2 and operators[c][1] <  operators[opstack[#opstack]][1] ) ) then
					table.insert( result, table.remove( opstack ) ) -- move an operator from the opstack to the result stack
				else
					break
				end
			end
			opstack[#opstack+1] = c
		elseif( c == "(" ) then  -- open paren, save the paren
			opstack[#opstack+1] = c
		elseif( c == ")" ) then  -- close paren, do some processing
			if #value>0 then  -- save the value if set.
				result[#result+1] = tonumber( table.concat( value ) )
				value = {}
			end
			c = opstack[#opstack]
			while( c ~= "(" ) do
				table.insert( result, table.remove( opstack ) ) -- move an operator from the opstack to the result stack
				if( #opstack > 0 ) then
					c = opstack[#opstack]
				else
					break
				end
			end
			table.remove( opstack )
		elseif( c == " " ) then
			if #value>0 then  -- save a value (no spaces in numbers)
				result[#result+1] = tonumber( table.concat( value ) )
				value = {}
			end
		elseif( c ~= " " ) then
			--print( "txtOut: "..table.concat( txtOut ).. "+"..c )
			txtOut[#txtOut+1] = c
		end
	end)
	if( #value>0 ) then  -- left over value, push it to the result stack
		result[#result+1] = tonumber( table.concat( value ) )
	end
	while( #opstack > 0 ) do
		table.insert( result, table.remove( opstack ) ) -- move an operator from the opstack to the result stack
	end

	--print( "END result:"..table.concat( result, " " ) )
	-- process each item in here
	for _,msg in ipairs( result ) do
		--print( "do:"..msg)
		calc.ProcessLine( msg )
	end


	--print( "END result:"..table.concat( result, " " ) )
	--print( "END txtOut:"..table.concat( txtOut, "" ) )
	if #txtOut>0 then -- there is SOMETHING in the txtOut queue.....
		calc.ProcessLine( table.concat( txtOut ) )
		--print( "STACK>"..table.concat( calc.stack, " " ) )
		txtOut = {}
	end
	return table.concat( txtOut, " " )


end
------
-- end infix code
------

function calc.Parse( msg )
	if msg then
		local a, b, c = strfind( msg, "(%S+)" )  -- location, size, matched
		if a then -- found a number
			return c, strsub(msg, b+2)
		else
			return nil
		end
	end
end
function calc.ProcessLine( msg, showErrors )
	while msg and string.len(msg) > 0 do
		msg = string.lower(msg)
		val, msg = calc.Parse( msg )

		--print( "val:"..val.." :"..( val:sub(1,1)=="(" and "true" or "false").." :"..msg )
		if val and val:sub(1,1) == "(" then
			--print( "Found possible INLINE" )
			if not string.match( val..""..msg, "[)]" ) then
				--print( "incomplete: "..val..msg )
				msg = msg .. ")"
			end
			val = val .. msg
			msg = ""
		end
		--print( "val:"..val.." msg:"..msg )
		if val then
			if calc.functions[val] then
				calc.functions[val]()
			elseif string.find( val, "%b()" ) then
				--print( "FOUND: "..val )
				calc.In2end( val )
			elseif tonumber(val) then -- is a value
				table.insert( calc.stack, tonumber(val) )
			elseif calc_macros[val] then
				calc.ProcessLine( calc_macros[val] )
			elseif val == "macro" then
				calc.Macro( msg )
				break
			elseif showErrors then
				print("?:"..val..":?")
			end
		end
	end
end
function calc.Command( msg )
	calc.ProcessLine( msg, true )
	calc.ShowStack()
end

SLASH_CALC1 = "/CALC"
SLASH_CALC2 = "/RPN"
SlashCmdList["CALC"] = calc.Command
