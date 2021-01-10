#!/usr/bin/env lua

addonData = { ["Version"] = "1.0",
	["Author"] = "opussf",
}

require "wowTest"

test.outFileName = "testOut.xml"

ParseTOC( "../src/calc.toc" )

CALC_Frame = CreateFrame()
OriginalSendChatMessage = SendChatMessage
OriginalBNSendWhisper = BNSendWhisper

function test.before()
	calc.stack = {}
	calc.useDegree = nil
	calc.VARIABLES_LOADED()
	calc_macros={}
	calc_settings={}
end
function test.after()
	SendChatMessage = OriginalSendChatMessage
	BNSendWhisper = OriginalBNSendWhisper
end

function test.test_MSG_ADDONNAME()
	assert( CALC_MSG_ADDONNAME )
end
function test.test_MSG_VERSION()
	-- just make sure this is assigned
	assert( CALC_MSG_VERSION )
end
function test.test_MSG_AUTHOR()
	-- just make sure this is assigned
	assert( CALC_MSG_AUTHOR )
end
function test.test_Command()
	calc.Command()
end
function test.test_PutOnStack()
	calc.Command( "5" )
	assertEquals( 5, calc.stack[1] )
end
function test.test_PutTwoOnStack()
	calc.Command( "5" )
	calc.Command( "7" )
	assertEquals( 7, calc.stack[2] )
end
function test.test_PutTwoOnStack_oneLine()
	calc.Command( "5 7")
	assertEquals( 5, calc.stack[1] )
	assertEquals( 7, calc.stack[2] )
end
function test.test_PutThreeOnStack_oneLine()
	calc.Command( "4 2 5" )
	assertEquals( 5, calc.stack[3] )
end
function test.test_PutOnStack_negative()
	calc.Command( "-5" )
	assertEquals( -5, calc.stack[1] )
end
function test.test_PutOnStack_decimal()
	calc.Command( "0.5" )
	assertEquals( 0.5, calc.stack[1] )
end
function test.test_PutTwoOnStack_oneLine_negative()
	calc.Command( "-5 -7")
	assertEquals( -5, calc.stack[1] )
	assertEquals( -7, calc.stack[2] )
end
function test.test_Add_noValues()
	calc.Command( "+" )
end
function test.test_Add_oneValue()
	calc.Command( "5" )
	calc.Command( "+" )
	assertEquals( 5, calc.stack[1] )
end
function test.test_Add_oneValue_oneLine()
	calc.Command( "5 +" )
	assertEquals( 5, calc.stack[1] )
end
function test.test_Add_twoValues()
	calc.Command( "5" )
	calc.Command( "7" )
	calc.Command( "+" )
	assertEquals( 12, calc.stack[1] )
end
function test.test_Add_twoValues_oneLine()
	calc.Command( "5 7 +" )
	assertEquals( 12, calc.stack[1] )
end
function test.test_Add_firstNeg()
	calc.Command( "-5" )
	calc.Command( "7" )
	calc.Command( "+" )
	assertEquals( 2, calc.stack[1] )
end
function test.test_Add_firstNeg_oneLine()
	calc.Command( "-5 7 +" )
	assertEquals( 2, calc.stack[1] )
end
function test.test_Add_secondNeg()
	calc.Command( "5" )
	calc.Command( "-7" )
	calc.Command( "+" )
	assertEquals( -2, calc.stack[1] )
end
function test.test_Add_secondNeg_oneLine()
	calc.Command( "5 -7 +" )
	assertEquals( -2, calc.stack[1] )
end
function test.test_Sub_twoPositive()
	calc.Command( "5 7 -" )
	assertEquals( -2, calc.stack[1] )
end
function test.test_Sub_twoNeg()
	calc.Command( "-5 -7 -" )
	assertEquals( 2, calc.stack[1] )
end
function test.test_Mul_twoPositive()
	calc.Command( "2 5 *" )
	assertEquals( 10, calc.stack[1] )
end
function test.test_Mul_twoNegative()
	calc.Command( "-2 -5 *" )
	assertEquals( 10, calc.stack[1] )
end
function test.test_Div_integer()
	calc.Command( "14 2 /")
	assertEquals( 7, calc.stack[1] )
end
function test.test_Div_decimal()
	calc.Command( "1 2 /")
	assertEquals( 0.5, calc.stack[1] )
end
function test.test_Div_byZero()
	calc.Command( "1 0 /")
	assertEquals( 0, calc.stack[2] )
end
function test.test_Div_ZeroBy()
	calc.Command( "0 1 /")
	assertEquals( 0, calc.stack[1] )
end
function test.test_Deg_setsFlag()
	calc.Command( "deg" )
	assert( calc.useDegree )
end
function test.test_Sin_simple_01()
	calc.Command( "0 sin")
	assertEquals( 0, calc.stack[1] )
end
function test.test_Sin_simple_03()
	calc.Command( "deg 30 sin 0.5 +")
	assertEquals( 1, calc.stack[1] )
end
function test.test_Sin_simple_04()
	calc.Command( "deg 30 SIN 0.5 +")
	assertEquals( 1, calc.stack[1] )
end
function test.test_Sin_noVals()
	calc.Command( "sIn" )
	assertEquals( 0, #calc.stack )
end
function test.test_Cos_simple_01()
	calc.Command( "pi cos" )
	assertEquals( -1, calc.stack[1] )
end
function test.test_Tan_simple_01()
	calc.Command( "deg 45 tan 1 +" )
	assertEquals( 2, calc.stack[1] ) -- deg 45 tan ends up as 1, but 1 ~= 1 for some reason.
end
function test.test_power_squared_2()
	calc.Command( "2 2 ^" )
	assertEquals( 4, calc.stack[1] )
end
function test.test_power_cubed_3()
	calc.Command( "3 3 ^" )
	assertEquals( 27, calc.stack[1] )
end
function test.test_power_zero()
	calc.Command( "100 0 ^" )
	assertEquals( 1, calc.stack[1] )
end
function test.test_complicated_01()
	calc.Command( "4 2 5 * + 1 3 2 * + /" )
	assertEquals( 2, calc.stack[1] )
end
function test.test_complicated_02()
	calc.Command( "2 5 * 4 + 3 2 * 1 + /" )
	assertEquals( 2, calc.stack[1] )
end
function test.test_complicated_03()
	calc.Command( "7   10   5   /   +   6   2   *   + " )
	assertEquals( 21, calc.stack[1] )
end
function test.test_complicated_04()
	calc.Command( "deg 5 8 2 15 * sin * + 2 45 tan + /" )
	assertEquals( 3, calc.stack[1] )
end
function test.test_complicated_05()
	calc.Command( "deg 3 e 2 ^ ln * 8 60 cos * + 3 4 0.5 ^ * 1 - /" )
	assertEquals( 2, calc.stack[1] )
end
function test.test_complicated_06()
	calc.Command( "1.2 2 ^ .5 2 ^ + .5 ^")
	assertEquals( 1.3, calc.stack[1] )
end
function test.test_variables_pi()
	calc.Command( "pi" )
	assert( calc.stack[1] > 3.141 )
	assert( calc.stack[1] < 3.142 )
	assertEquals( math.pi, calc.stack[1] )
end
function test.test_variables_e()
	calc.Command( "e" )
	assert( calc.stack[1] > 2.718 )
	assert( calc.stack[1] < 2.719 )
	assertEquals( math.exp(1), calc.stack[1] )
end
function test.test_specialFunctions_AC()
	calc.Command( "2 5 3 2 3 4" )
	calc.Command( "AC" )
	assertEquals( 0, #calc.stack )
end
function test.test_specialFunctions_AC_inTheMiddle()
	calc.Command( "2 3 AC 42 69 + + +" )
	assertEquals( 111, calc.stack[1] )
end
-- 1.1 tests
function test.test_wowVariable_gold()
	myCopper = 123456
	calc.Command( "gold" )
	assertEquals( 12.3456, calc.stack[1] )
end
function test.test_wowVariable_silver()
	myCopper = 123456
	calc.Command( "silver" )
	assertEquals( 1234.56, calc.stack[1] )
end
function test.test_wowVariable_copper()
	myCopper = 123456
	calc.Command( "copper" )
	assertEquals( 123456, calc.stack[1] )
end
function test.test_wowVariable_health()
	calc.Command( "health" )
	assertEquals( 123456, calc.stack[1] )
end
function test.test_wowVariable_hp()
	calc.Command( "hp" )
	assertEquals( 123456, calc.stack[1] )
end
function test.test_wowVariable_power()
	calc.Command( "power" )
	assertEquals( 12345, calc.stack[1] )
end
function test.test_wowVariable_haste()
	calc.Command( "haste" )
	assertEquals( 15.42345, calc.stack[1] )
end
function test.test_wowVariable_mastery()
	calc.Command( "mastery" )
	assertEquals( 21.3572, calc.stack[1] )
end
function test.test_wowVariable_xp()
	calc.Command( "xp" )
	assertEquals( 100, calc.stack[1] )
end
function test.test_wowVariable_xpMax()
	calc.Command( "xpMax" )
	assertEquals( 1000, calc.stack[1] )
end
-- 1.2 tests
function test.test_Fac_noVals()
	calc.Command( "!" )
	assertEquals( 0, #calc.stack )
end
function test.test_Fac_negative()
	calc.Command( "-1 !" )
	assertEquals( math.huge, calc.stack[1] )
end
function test_test_Fac_zero()
	calc.Command( "0 !" )
	assertEquals( 1, calc.stack[1] )
end
function test.test_Fac_one()
	calc.Command( "1 !" )
	assertEquals( 1, calc.stack[1] )
end
function test.test_Fac_three()
	calc.Command( "3 !" )
	assertEquals( 6, calc.stack[1] )
end
function test.test_Fac_five()
	calc.Command( "5 !" )
	assertEquals( 120, calc.stack[1] )
end
function test.test_Fac_69()
	calc.Command( "120 !" )
	assertTrue( calc.stack[1] > 6.689502913449e+198 )
	assertTrue( calc.stack[1] < 6.6895029134492e+198 )
end
function test.test_Pop_oneVal_01()
	calc.Command( "5" )
	calc.Command( "pop" )
	assertEquals( 0, #calc.stack )
end
function test.test_Pop_oneVal_02()
	calc.Command( "5 pop" )
	assertEquals( 0, #calc.stack )
end
function test.test_Pop_noVal()
	calc.Command( "pop" )
	assertEquals( 0, #calc.stack )
end
function test.test_Pop_twoVal()
	calc.Command( "5 3 pop" )
	assertEquals( 1, #calc.stack )
	assertEquals( 5, calc.stack[1] )
end
function test.test_Swap_oneVal()
	calc.Command( "3 swap" )
	assertEquals( 3, calc.stack[1] )
end
function test.test_Swap_twoVals()
	calc.Command( "5 3 swap" )
	assertEquals( 3, calc.stack[1] )
end
function test.test_Swap_threeVals()
	calc.Command( "1 2 3 swap" )
	assertEquals( 3, calc.stack[2] )
	assertEquals( 2, calc.stack[3] )
end
-- 1.3 tests
function test.test_asin()
	calc.Command( "0 asin" )
	assertEquals( 0, calc.stack[1] )
end
function test.test_asin_deg()
	calc.Command( "deg 1 asin" )
	assertEquals( 90, calc.stack[1] )  -- 30 != 30  the value from asin and the conversion changes the return value.
end
function test.test_asin_2()
	calc.Command( "2 asin")
	local x = calc.stack[1]
	assert( x ~= x )  -- true if x is nan    nan is not equal to itself
end
function test.test_acos()
	calc.Command( "1 acos" )
	assertEquals( 0, calc.stack[1] )
end
function test.test_acos_deg()
	calc.Command( "deg 0 acos" )
	assertEquals( 90, calc.stack[1] ) -- 60 != 60  the value from acos and the conversion changes the return value.
end
function test.test_acos_2()
	calc.Command( "2 acos" )
	local x = calc.stack[1]
	assert( x ~= x )  -- true if x is nan    nan is not equal to itself
end
function test.test_atan()
	calc.Command( "0.8 atan" )
	assertEquals( 0.6747, math.floor(calc.stack[1] * 10000) / 10000 )
end
function test.test_atan_deg()
	calc.Command( "deg 0.8 atan" )
	assertEquals( 38.6598, math.floor(calc.stack[1] * 10000) / 10000 )
end
function test.test_percent()
	calc.Command( "1000 10 %" )
	assertEquals( 100, calc.stack[2] )
end
function test.test_percent_2()
	calc.Command( "1000 1 %" )
	assertEquals( 10, calc.stack[2] )
end
function test.test_percent_3()
	calc.Command( "1000 2 %" )
	assertEquals( 20, calc.stack[2] )
end
function test.test_percent_plus()
	calc.Command( "1000 2 % +" )
	assertEquals( 1020, calc.stack[1] )
end
function test.test_oneOver()
	calc.Command( "2 1/x" )
	assertEquals( 0.5, calc.Pop() )
end
function test.test_oneOver2()
	calc.Command( "0.5 1/x" )
	assertEquals( 2, calc.Pop() )
end
function test.test_oneOver3()
	calc.Command( "1 1/x" )
	assertEquals( 1, calc.Pop() )
end
-- temperature functions
function test.test_toC_bodyTemp()
	-- the expected values are 'rounded' versions of the actual.  Use ceiling to 'fix' this.
	calc.Command( "98.6 toC" )
	assertEquals( 37, math.ceil( calc.stack[1] ) )
end
function test.test_toC_waterFreeze()
	calc.Command( "32 toC" )
	assertEquals( 0, calc.Pop() )
end
function test.test_toC_dryIce()
	calc.Command( "-109.3 toC" )
	assertEquals( -78.5, calc.Pop() )
end
function test.test_toF_bodyTemp()
	-- the actual value needs to be 'adjusted' to the truncated expected.
	calc.Command( "37 toF" )
	assertEquals( 98.6, math.floor( calc.Pop() * 10 ) / 10 )
end
function test.test_toF_waterFreeze()
	calc.Command( "0 toF" )
	assertEquals( 32, calc.Pop() )
end
function test.test_toF_dryIce()
	-- the actual value needs to be 'adjusted' to the truncated expected.
	calc.Command( "-78.5 toF" )
	assertEquals( -109.3, math.floor( calc.Pop() * 10 ) / 10 )
end
function test.test_toC_moltenLead()
	calc.Command( "621.5 toC" )
	assertEquals( 327.5, calc.Pop() )
end
function test.test_toF_moltenLead()
	calc.Command( "327.5 toF" )
	assertEquals( 621.5, calc.Pop() )
end
function test.test_toF_sameValue()
	calc.Command( "-40 toF" )
	assertEquals( -40, calc.Pop() )
end
function test.test_toC_sameValue()
	calc.Command( "-40 toC" )
	assertEquals( -40, calc.Pop() )
end
function test.test_toC_noValue()
	calc.Command( "toC" )
	assertEquals( 0, #calc.stack )
end
function test.test_toF_noValue()
	calc.Command( "toF" )
	assertEquals( 0, #calc.stack )
end
------------------
-- Chat
------------------
function test.test_SendChatMessage_01()
	calc.SendChatMessage( "10 ==", "GUILD", "language", "channel" )
	assertEquals( "10 = 10", chatLog[#chatLog].msg )
	assertEquals( "GUILD", chatLog[#chatLog].chatType )
end
function test.test_SendChatMessage_02()
	calc.SendChatMessage( "As we can see: 10 20 + ==", "GUILD", "language", "channel" )
	assertEquals( "As we can see: 10 20 + = 30", chatLog[#chatLog].msg )
end
function test.test_SendChatMessage_03()
	calc.SendChatMessage( "10 20 +", "GUILD", "language", "channel" )
	assertEquals( "10 20 +", chatLog[#chatLog].msg )
end
function test.test_SendChatMessage_04()
	calc.SendChatMessage( "No numbers here.", "GUILD", "language", "channel" )
	assertEquals( "No numbers here.", chatLog[#chatLog].msg )
end
function test.test_SendChatMessage_05()
	calc.SendChatMessage( "10 30 ==", "GUILD", "language", "channel" )
	assertEquals( "10 30 = 10 30", chatLog[#chatLog].msg )
end
function test.test_SendChatMessage_06()
	-- the 'extra' space at the end is to test that it is preserved.  This is intentional
	calc.Command( "16 toF" )
	calc.SendChatMessage( "toc == ", "GUILD", "language", "channel" )
	assertEquals( "toc = 16.0 ", chatLog[#chatLog].msg )
end
function test.test_SendChatMessage_07()
	calc.SendChatMessage( "10 30 ==", "GUILD", "language", "channel" )
	calc.SendChatMessage( "+ ==", "GUILD", "language", "channel" )
	assertEquals( "+ = 40", chatLog[#chatLog].msg )
end
------------------
-- token function
------------------
function test.test_Token_01()
	calc.Command( "token" )
	assertEquals( 12.3456, calc.Pop() )
end
------------------
-- BNSendWhisper
------------------
function test.test_ReplaceMessage_01()
	assertEquals( "2 5 * = 10", calc.ReplaceMessage( "2 5 * ==" ) )
end
function test.test_BNSendWhisper_01()
	--print( #chatLog )
	calc.BNSendWhisper( 10, "10 ==" )
	--print( #chatLog )
	assertEquals( "10 = 10", chatLog[#chatLog].msg )
end
------------------
-- Ceiling, Floor, and Round
------------------
function test.test_Ceil_00()
	calc.Command( "ceil" )
end
function test.test_Ceil_01()
	calc.Command( "0.4 ceil" )
	assertEquals( 1, calc.Pop() , "Should round up to 1" )
end
function test.test_Ceil_02()
	calc.Command( "43.23 ceil" )
	assertEquals( 44, calc.Pop() )
end
function test.test_Ceil_03()
	calc.Command( "106 toC ceil" )
	assertEquals( 42, calc.Pop() )
end
function test.test_Ceil_04()
	calc.Command( "10 1.5 ceil /" )
	assertEquals( 5, calc.Pop() )
end
function test.test_Floor_00()
	calc.Command( "floor" )
end
function test.test_Floor_01()
	calc.Command( "0.6 floor" )
	assertEquals( 0, calc.Pop(), "Should round down to 0" )
end
function test.test_Floor_02()
	calc.Command( "43.23 floor" )
	assertEquals( 43, calc.Pop() )
end
function test.test_Floor_03()
	calc.Command( "106 toC floor" )
	assertEquals( 41, calc.Pop() )
end
function test.test_Floor_04()
	calc.Command( "10 1.5 floor /" )
	assertEquals( 10, calc.Pop() )
end
function test.test_Round_00()
	calc.Command( "round" )
end
function test.test_Round_01()
	calc.Command( "0.4 round" )
	assertEquals( 0, calc.Pop() )
end
function test.test_Round_02()
	calc.Command( "0.5 round" )
	assertEquals( 1, calc.Pop() )
end
------------------
-- Macros
------------------
function test.test_Macro_doesNotPerformMacroOnAssignment()
	calc.Command( "macro tMacro 5000000 token / ceil" )
	assertEquals( 0, #calc.stack )
end
function test.test_Macro_performsMacro()
	calc.Command( "macro tMacro2 5000000 token / ceil" )
	calc.Command( "tMacro2" )
	assertEquals( 405003, calc.Pop() )
end
function test.test_Macro_add_command_01()
	calc.Command( "macro tMacro3 50 2 ^" )
	assertEquals( "50 2 ^", calc_macros.tmacro3 )
	assertEquals( 0, #calc.stack )
end
function test.test_Macro_add_function_01()
	calc.MacroAdd( "m1 5 15 /" )
	assertEquals( "5 15 /", calc_macros.m1 )
	assertEquals( 0, #calc.stack )
end
function test.test_Macro_add_replace_01()
	calc_macros = { ["m4"] = "42 6 /" }
	calc.Command( "macro m4 15 5 -" )
	assertEquals( "15 5 -", calc_macros.m4 )
	assertEquals( 0, #calc.stack )
end
function test.test_Macro_add_useFunctionNameShouldFail()
	calc.Command( "macro pi 13 87 /")
	assertIsNil( calc_macros["pi"] )
end
function test.test_Macro_del_function_01()
	calc_macros = { ["m2"] = "5000000 pi /" }
	calc.MacroDel( "m2" )
	assertIsNil( calc_macros["m2"] )
end
function test.test_Macro_del_command_simple()
	calc_macros = { ["m2"] = "5000000 pi /" }
	calc.Command( "macro del m2" )
	assertIsNil( calc_macros["m2"] )
end
function test.test_Macro_del_command_withExtra()
	calc_macros = { ["m2"] = "5000000 pi /" }
	calc.Command( "macro del m2 6 3 *" )
	assertIsNil( calc_macros["m2"] )
	assertEquals( 0, #calc.stack )
end
function test.test_Macro_list_function_01()
	calc_macros = { ["m3"] = "42 6 /" }
	calc.MacroList()
end
function test.test_Macro_list_command_01()
	calc_macros = { ["m3"] = "42 6 /" }
	calc.Command( "macro list m3" )
end
function test.test_Macro_empty()
	calc.Command( "macro" )
end
---- Infix
--[[
function test.test_Infix_setInfixMode()
	calc.Command( "infix" )
	assertTrue( calc_settings.useInfix )
end
function test.notest_Infix_setBackToRPN()
	calc_settings.useInfix = true
	calc.Command( "rpn" )
	assertIsNil( calc_settings.useInfix )
end
]]
function test.test_Infix_inlineSimple()
	calc.Command( "(2+3)" )
	assertEquals( 5, calc.Pop() )
end
function test.test_Infix_inlineComplex()
	calc.Command( "(2+3*2)" )  -- should be 8, not 10  2 + 6 = 8
	assertEquals( 8, calc.Pop() )
end
function test.test_Infix_inlineIncomplete()
	calc.Command( "(2+3*2" )  -- I'm really not sure what to do here....???  Maybe assume closing ) because of EOL?
	assertEquals( 8, calc.Pop() )
end
function test.test_Infix_inlineIncomplete_spaces()
	calc.Command( "( 2 + 3 * 2 " )
	assertEquals( 8, calc.Pop() )
end
function test.test_Infix_inlineComplex_grouped()
	calc.Command( "((2+3)*2)" )  -- 5 * 2 = 10
	assertEquals( 10, calc.Pop() )
end
function test.test_Infix_inlineComplex_manygroups()
	calc.Command( "(4+8)*((6-5)/((3-2)*(2+2)))" )
	assertEquals( 3, calc.Pop() )
end
function test.notest_Infix_useInfixMode_simple()
	calc.Command( "infix" )
	calc.Command( "2+3" )
	assertEquals( 5, calc.Pop() )
end
function test.notest_Infix_useInfixMode_spaces()
	calc.Command( "infix" )
	calc.Command( "2 + 3" )
	assertEquals( 5, calc.Pop() )
end
function test.test_Infix_inlineComplex_decimal()
	calc.Command( "( 2.0 + 3.0 * 2.0 )" )
	assertEquals( 8, calc.Pop() )
end
function test.test_Infix_inlineSimple_decimal()
	calc.Command( "( .2 + .3 )" )
	assertEquals( .5, calc.Pop() )
end
function test.test_Infix_inlineSimple_decimal_longer()
	calc.Command( " ( .12345 + 0.4321 )" )
	assertEquals( .55555, calc.Pop() )
end
function test.test_Infix_inline_variables_pi()
	calc.Command( "( pi )" )
	assert( calc.stack[1] > 3.141 )
	assert( calc.stack[1] < 3.142 )
	assertEquals( math.pi, calc.stack[1] )
end
function test.test_Infix_inline_multiply_pi_first()
	calc.Command( "( pi * 2 )" )
	assert( calc.stack[1] > 6.283, "remaining value:"..calc.stack[1] )
	assert( calc.stack[1] < 6.284, "DAMN" )
	assertEquals( math.pi*2, calc.stack[1] )
end
function test.test_Infix_inline_variables_e()
	calc.Command( "(e)" )
	assert( calc.stack[1] > 2.718 )
	assert( calc.stack[1] < 2.719 )
	assertEquals( math.exp(1), calc.stack[1] )
end
function test.test_Infix_inline_variables_gold()
	myCopper = 123456
	calc.Command( "(gold)" )
	assertEquals( 12.3456, calc.Pop() )
end
function test.test_Infix_inlineComplex_percent()
	calc.Command( "(20 + 5 % )" )   -- 20 5 % +
	assertEquals( 21, calc.Pop() )
end
function test.notest_Infix_inline_doubleNeg()
	calc.Command( "(20 - -5) 20 -5 -" )
	assertEquals( 25, calc.Pop() )
	assertEquals( 25, calc.Pop() )
end
function test.test_Infix_inline_useZero_first()
	calc.Command( "( 0 + 17 )" )
	assertEquals( 17, calc.Pop() )
end
function test.test_Infix_inline_useZero_second()
	calc.Command( "( 42 - 0 )" )
	assertEquals( 42, calc.Pop() )
end
function test.test_Infix_inline_empty()
	-- regression test.  Used to cause a stackoverflow.
	calc.Command( "()" )
	assertEquals( 0, #calc.stack )
end
function test.test_Infix_inline_factorial()
	calc.Command( "( 5 ! )" )
	assertEquals( 120, calc.Pop() )
end
function test.test_Infix_inlinemixed_extraValuesOnStack()
	calc.Command( "(20 +5) 1 2 3" )
	assertEquals( 4, #calc.stack )
end
function test.test_Infix_inlinemixed_nested_extraValuesOnStack()
	calc.Command( "((4+8)*((6-5)/((3-2)*(2+2)))) 15 42 17 92" )
	assertEquals( 5, #calc.stack )
	assertEquals( 3, calc.stack[1] )
end
function test.test_Infix_inlinemixed_nested_extraValuesOnStack_withSpaces()
	calc.Command( "( ( 4 + 8 ) * ( ( 6 - 5 ) / ( ( 3 - 2 ) * ( 2 + 2 ) ) ) ) 15 42 17 92" )
	assertEquals( 5, #calc.stack )
	assertEquals( 3, calc.stack[1] )
end
-- chatcontrol
function test.test_Chatcontrol_showAValue()
	calc.SendChatMessage( "9 ==", "GUILD", "language", "channel" )
	assertEquals( "9 = 9", chatLog[#chatLog].msg )
end
function test.test_Chatcontrol_hasOtherValues()
	calc.Command( "pi" )
	calc.SendChatMessage( "8 ==", "GUILD", "language", "channel" )
	assertEquals( "8 = 8", chatLog[#chatLog].msg )
end
function test.test_Chatcontrol_consumesStack_showsValue()
	calc.Command( "42" )
	calc.SendChatMessage( "7 + ==" )
	assertEquals( "7 + = 49", chatLog[#chatLog].msg )
end
function test.test_Chatcontrol_nothingOnStack()
	-- admit it...  it is going to happen...
	calc.Command( "AC" )
	calc.SendChatMessage( "==" )
	assertEquals( "= ", chatLog[#chatLog].msg )
end
function test.test_Chatcontrol_showLastValue()
	calc.Command( "96" )
	calc.SendChatMessage( "==" )
	assertEquals( "= 96", chatLog[#chatLog].msg )
end
function test.test_Chatcontrol_addingExtraToTheStack()
	calc.Command( "5 !" )
	calc.SendChatMessage( "4 8 + 6 5 ==" )
	assertEquals( "4 8 + 6 5 = 12 6 5", chatLog[#chatLog].msg )
end
function test.test_Chatcontrol_workThrough()
	-- this might be the classic work through with someone...
	calc.SendChatMessage( "Finding the area of a triangle with a base of 15 in and a height of 4 in ==" )
	assertEquals( "Finding the area of a triangle with a base of 15 in and a height of 4 in = 15 4", chatLog[#chatLog].msg )
	calc.SendChatMessage( "we first * the base by the height ==" )
	assertEquals( "we first * the base by the height = 60", chatLog[#chatLog].msg )
	calc.SendChatMessage( "and divide by 2 / giving == square in" )
	assertEquals( "and divide by 2 / giving = 30.0 square in", chatLog[#chatLog].msg )
end
-------------------
-- Farey
-------------------
function test.test_Farey_NoNumbers()
	calc.Command( "///" )
end
function test.test_Farey_OneHalf()
	calc.Command( "1 2 / ///" )
	assertEquals( 2, #calc.stack )
	assertEquals( 1, calc.stack[1] )
	assertEquals( 2, calc.stack[2] )
end
function test.test_Farey_WholeNumber()
	calc.Command( "15 ///" )
	assertEquals( 2, #calc.stack )
	assertEquals( 15, calc.stack[1] )
	assertEquals( 1, calc.stack[2] )
end
function test.test_Farey_LargeDecimal()
	calc.Command( "15.2 ///" )
	assertEquals( 2, #calc.stack )
	assertEquals( 76, calc.stack[1] )
	assertEquals( 5, calc.stack[2] )
end
function test.test_Farey_LargeDecimalNeg()
	calc.Command( "-15.2 ///" )
	assertEquals( 2, #calc.stack )
	assertEquals( -76, calc.stack[1] )
	assertEquals( 5, calc.stack[2] )
end
function test.test_Farey_SpecialTest()
	-- too large for the limit, return a value over 1
	calc.Command( "11 6 ^ 13 / ///" )
	assertEquals( 2, #calc.stack )
	assertEquals( 1, calc.stack[2] )
end
-------------------
-- mass
-------------------
function test.test_Mass_KGtoLB()
	calc.Command( "1 kgtolb" )
	assertEquals( 1, #calc.stack )
	assertEquals( 2.20462, calc.stack[1] )
end
function test.test_Mass_LGtoKG()
	calc.Command( "1 lbtokg 10000000 * round" )
	assertEquals( 1, #calc.stack )
	assertEquals( 4535929, calc.stack[1] )
end
function test.test_Mass_KGtoLBtoKG()
	calc.Command( "1 kgtolb lbtokg" )
	assertEquals( 1, #calc.stack )
	assertEquals( 1, calc.stack[1] )
end
function test.test_Mass_LBtoKGtoLB()
	calc.Command( "1 lbtokg kgtolb" )
	assertEquals( 1, #calc.stack )
	assertEquals( 1, calc.stack[1] )
end
-----
function test.test_LOGY_2()
	calc.Command( "10000000 2 logy" )
	assertEquals( 1, #calc.stack )
end


test.run()
