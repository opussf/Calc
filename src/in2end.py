#!/usr/bin/env python

class In2end( object ):
	""" This takes an infix equation, and makes an endfix (RPN) representation of it.
	It is an attempt to implement Edsger Dijkstra's method.
	https://en.wikipedia.org/wiki/Shunting-yard_algorithm
	http://scriptasylum.com/tutorials/infix_postfix/algorithms/infix-postfix/
	"""

	result = []
	opStack = []

	# ( precidence, associativty - 1=left, 2=right)
	operators = {"+": (2,1), "-": (2,1), "*": (3,1), "/": (3,1), "^": (4,2)}
	integers=["0","1","2","3","4","5","6","7","8","9"]

	def __init__( self ):
		pass

	def __str__( self ):
		return " ".join( map( lambda x: str(x), self.result ) )

	def moveFromOpStack( self ):
		self.result.append( self.opStack.pop() )

	def parse( self, lineIn ):
		"""Takes a string"""
		#print "parse: %s" % (lineIn,)
		# clear self
		self.result = []
		self.opStack = []

		value = None
		for c in lineIn:
			if c in self.integers:
				c = int(c)
				if value:
					value = (value * 10) + c
				else:
					value = c
				#print value
			elif c in self.operators.keys():
				# this is an operator, push value to the result stack, and reset
				if value:
					self.result.append( value )
					value = None
				# push the operator to the opStack (test this first)
				while( len( self.opStack ) ):
					if self.opStack[-1] == "(":
						break
					elif (self.operators[c][1]==1 and self.operators[c][0] <= self.operators[self.opStack[-1]][0]) \
							or (self.operators[c][1]==2 and self.operators[c][0] < self.operators[self.opStack[-1]][0]):
						self.moveFromOpStack()
					else:
						break
				self.opStack.append( c )
				#print "New stack: %s" % (" ".join(self.opStack),)
			elif c == "(":
				self.opStack.append( c )
			elif c == ")":
				if value:
					self.result.append( value )
					value = None
				while( c != "(" ):
					self.moveFromOpStack()
					if len(self.opStack) > 0:
						c = self.opStack[-1]
					else:
						break
				self.opStack.pop()
			else:
				pass
		# If the value has a value, push it into the stack
		if value:
			self.result.append( value )
		while( len(self.opStack) ):
			self.moveFromOpStack()

def main():
	con = In2end()
	running = true
	while( running ):
		line = input(">")
		con.parse( line )
		print( con )
		running = line

if __name__ == "__main__":
	import unittest
	class ShuntingTest( unittest.TestCase ):
		def setUp( self ):
			self.con = In2end()
		def tearDown( self ):
			self.con = None
		def test_empty( self ):
			self.con.parse( "" )
			self.assertEquals( "", str(self.con) )
		def test_simpleAdd( self ):
			self.con.parse( "56+ 5" )
			self.assertEquals( "56 5 +", str(self.con) )
		def test_simpleSub( self ):
			self.con.parse( "5-5" )
			self.assertEquals( "5 5 -", str(self.con) )
		def test_simpleMul( self ):
			self.con.parse( "5*5" )
			self.assertEquals( "5 5 *", str(self.con) )
		def test_simpleDiv( self ):
			self.con.parse( "5/5" )
			self.assertEquals( "5 5 /", str(self.con) )
		def test_mulBeforeAdd( self ):
			self.con.parse( "6*6+5" )
			self.assertEquals( "6 6 * 5 +", str(self.con) )
		def test_addBeforeMul( self ):
			self.con.parse( "5+6*6" )
			self.assertEquals( "5 6 6 * +", str(self.con) )
		def test_mixed_01( self ):
			self.con.parse( "1+2*3-4" )
			self.assertEquals( "1 2 3 * + 4 -", str(self.con) )
		def test_mixedWithParen_01( self ):
			self.con.parse( "3+4*(2-1)" )
			self.assertEquals( "3 4 2 1 - * +", str(self.con) )
		def test_mixedWithParen_02( self ):
			self.con.parse( "(6*(6+5)) * 12 / 3")
			self.assertEquals( "6 6 5 + * 12 * 3 /", str(self.con) )
		def test_mixedWithParen_03( self ):
			self.con.parse( "((3+2)*5)-2" )
			self.assertEquals( "3 2 + 5 * 2 -", str(self.con) )
		def test_mixedWithParen_04( self ):
			self.con.parse( "(4+8)*(6-5)/((3-2)*(2+2))" )
			self.assertEquals( "4 8 + 6 5 - * 3 2 - 2 2 + * /", str(self.con) )
		def test_mixedWithParen_05( self ):
			self.con.parse( "(4+8)*((6-5)/((3-2)*(2+2)))" )
			self.assertEquals( "4 8 + 6 5 - 3 2 - 2 2 + * / *", str(self.con) )
		def test_mixedWithPowers_01( self ):
			self.con.parse( "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3" )
			self.assertEquals( "3 4 2 * 1 5 - 2 3 ^ ^ / +", str(self.con) )
		def test_mixedWithPowers_02( self ):
			self.con.parse( "(3-5)^2+6" )
			self.assertEquals( "3 5 - 2 ^ 6 +", str(self.con) )
		def test_mixed_02( self ):
			self.con.parse( "2*3-4/5" )
			self.assertEquals( "2 3 * 4 5 / -", str(self.con) )
		def test_mixed_03( self ):
			self.con.parse( "(5+3)*12/3" )
			self.assertEquals( "5 3 + 12 * 3 /", str(self.con) )
		def test_mixed_04( self ):
			self.con.parse( "(300+23)*(43-21)/(84+7)")
			self.assertEquals( "300 23 + 43 21 - * 84 7 + /", str(self.con) )
		def test_mixed_05( self ):
			self.con.parse( "1/1 + 1/2 + 1/3 + 1/4 + 1/5 + 1/6 + 1/7 + 1/8 + 1/9")
			self.assertEquals( "", str(self.con) )

	-- unittest.main()
	main()
