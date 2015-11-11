#!/usr/bin/env lua

addonData = { ["Version"] = "1.0",
}

require "wowTest"

test.outFileName = "testOut.xml"

-- require the file to test
package.path = "../src/?.lua;'" .. package.path
require "calc"

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

test.run()
