function calc.ReplaceMessage( msgIn )
	msgNew = nil
	local hasEquals = strfind( msgIn, "==" )
	if( hasEquals ) then
		msg = string.lower( msgIn )
		while msg and string.len( msg ) > 0 do
			val, msg = calc.Parse( msg )
			if val then
				if calc.functions[val] then
					calc.functions[val]()
				elseif tonumber(val) then
					table.insert( calc.stack, tonumber(val) )
				end
			end
		end
		local result = table.concat( calc.stack, " " )
		msgNew = string.gsub( msgIn, "==", "= "..result )
	end
	return( ( msgNew or msgIn ) )
end
function calc.SendChatMessage( msgIn, system, language, channel )
	calc.OriginalSendChatMessage( calc.ReplaceMessage( msgIn ), system, language, channel )
end
function calc.BNSendWhisper( id, msgIn )
	print( "BNSendWhisper( "..id..", "..msgIn.." )" )
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
end
