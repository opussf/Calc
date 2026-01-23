function calc.ParseMessage( msgIn )
	if msgIn then
		local hasEquals = strfind( msgIn, "==" )
		if( hasEquals ) then
			msg = string.lower( msgIn )
			local stackCount = #calc.stack
			calc.ProcessLine( msg )

			-- add an expected extra value on the stack - means a stand alone calc
			stackCount = stackCount + 1
			-- use the stack size if it is smaller than the expected stack size
			stackCount = #calc.stack<stackCount and #calc.stack or stackCount
			-- set to nil if the stackCount is 0
			stackCount = stackCount>0 and stackCount or nil

			-- table.concat seems to have a 'bug?' where giving a starting index larger than the size of the array, or if the array is empty
			-- causes an error:  "invalid value (nil) at index 0 in table for 'concat'"
			local result = table.concat( calc.stack, " ", stackCount )
			return "Calc: = "..result
		end
	end
end
function calc.SendCalcResult( msgIn, system, language, channel )
	local calcMsg = calc.ParseMessage( msgIn )
	if calcMsg then
		C_ChatInfo.SendChatMessage( calcMsg, system, language, channel )
	end
end
function calc.BNSendWhisper( id, msgIn )
	calc.OriginalBNSendWhisper( id, calc.ReplaceMessage( msgIn ) )
end
function calc.OnLoad()
	CALC_Frame:RegisterEvent( "VARIABLES_LOADED" )
end
function calc.VARIABLES_LOADED()
	CALC_Frame:UnregisterEvent( "VARIABLES_LOADED" )
	-- Intercept chat events
	hooksecurefunc( C_ChatInfo, "SendChatMessage", calc.SendCalcResult )
end
