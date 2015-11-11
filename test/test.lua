I'm working on master now.

This file will be changed in both branches.
And I will rebase working off of the new master commit.

function test.test_MSG_ADDONNAME()
	assertEquals( "Calc", CALC_MSG_ADDONNAME )
end
function test.test_MSG_VERSION()
	-- just make sure this is assigned
	assert( CALC_MSG_VERSION )
end
function test.test_MSG_AUTHOR()
	assert( CALC_MSG_AUTHOR )
end
