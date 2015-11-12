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
function test.test_Mul_twoNegitive()
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
function test.test_specialFunctions()
	calc.Command( "2 5 3 2 3 4" )
	calc.Command( "AC" )
	assertEquals( 0, table.getn( calc.stack ) )
end

test.run()
