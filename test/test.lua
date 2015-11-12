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
function test.test_Print()
	calc.Print( "msg" )
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


test.run()
