#!/usr/bin/env lua

addonData = { ["Version"] = "1.0",
	["Author"] = "opussf",
}

require "wowTest"

test.outFileName = "testOut.xml"

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "calc"

function test.before()
	calc.stack = {}
	calc.useDegree = nil
end

function test.test_MSG_ADDONNAME()
	assert( CALC_MSG_ADDONNAME )
end
function test.test_MSG_VERSION()
	-- just make sure this is assigned
	assert( CALC_MSG_VERSION )
end
function test.test_MSG_AUTHOR()
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
	assertEquals( 0, table.getn( calc.stack ) )
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
	assertEquals( 0, table.getn( calc.stack ) )
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
function test.test_wowCurrency_honor()
	myCurrencies[392] = 12
	calc.Command( "honor" )
	assertEquals( 12, calc.stack[1] )
end
function test.test_wowCurrency_conquest()
	myCurrencies[390] = 10
	calc.Command( "conquest" )
	assertEquals( 10, calc.stack[1] )
end
function test.test_wowVariable_cp()
	myCurrencies[390] = 10
	calc.Command( "cp" )
	assertEquals( 10, calc.stack[1] )
end
function test.test_wowCurrency_justice()
	myCurrencies[395] = 15
	calc.Command( "justice" )
	assertEquals( 15, calc.stack[1] )
end
function test.test_wowCurrency_jp()
	myCurrencies[395] = 15
	calc.Command( "jp" )
	assertEquals( 15, calc.stack[1] )
end
function test.test_wowCurrency_valor()
	myCurrencies[396] = 16
	calc.Command( "valor" )
	assertEquals( 16, calc.stack[1] )
end
function test.test_wowCurrency_vp()
	myCurrencies[396] = 16
	calc.Command( "vp" )
	assertEquals( 16, calc.stack[1] )
end
-- 1.2 tests
function test.test_Fac_noVals()
	calc.Command( "!" )
	assertEquals( 0, table.getn( calc.stack ) )
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
	assertEquals( 0, table.getn( calc.stack ) )
end
function test.test_Pop_oneVal_02()
	calc.Command( "5 pop" )
	assertEquals( 0, table.getn( calc.stack ) )
end
function test.test_Pop_noVal()
	calc.Command( "pop" )
	assertEquals( 0, table.getn( calc.stack ) )
end
function test.test_Pop_twoVal()
	calc.Command( "5 3 pop" )
	assertEquals( 1, table.getn( calc.stack ) )
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

test.run()
