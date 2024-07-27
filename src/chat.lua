function calc.ReplaceMessage( msgIn )
	msgNew = nil
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
		msgNew = string.gsub( msgIn, "==", "= "..result )
	end
	return( ( msgNew or msgIn ) )
end
function calc.SendChatMessage( msgIn, system, language, channel )
	calc.OriginalSendChatMessage( calc.ReplaceMessage( msgIn ), system, language, channel )
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
	calc.OriginalSendChatMessage = SendChatMessage
	SendChatMessage = calc.SendChatMessage
	calc.OriginalBNSendWhisper = BNSendWhisper
	BNSendWhisper = calc.BNSendWhisper
	-- hooksecurefunc( "SendChatMessage", calc.SendChatMessage )
end


-- hooksecurefunc(C_PetJournal, "SetPetLoadOutInfo", function(...) self:OnSetPetLoadOut(...) end)