#!/usr/bin/env python

""" Write this in Python...
Just cause
"""

import math
class RPNCalc( object ):
	stack = []

	def __init__( self ):
		self.cmdKeys = self.commands.keys()

	def __str__( self ):
		return " ".join( map( lambda x: str(x), self.stack ) )

	def parseLine( self, lineIn ):
		""" Takes a line to parse
		Returns a string representation of the stack
		"""
		arrayIn = lineIn.split()
		for a in arrayIn:
			if a in self.cmdKeys:
				# call the function that is referenced in self.commands
				self.commands[a]( self )
			else:
				try:
					a = float(a)
					self.stack.append( a )
				except:
					print "Eh? '", a, "' is not a known command."
		return self.__str__()

	def add( self ):
		"""pop 2 values from the stack,
		push the sum back on the stack.
		"""
		if len( self.stack ) >= 2:
			self.stack.append( self.stack.pop() + self.stack.pop() )

	def sub( self ):
		"""pop 2 values from the stack,
		push the difference back on the stack.
		"""
		if len( self.stack ) >= 2:
			y = self.stack.pop()
			x = self.stack.pop()
			self.stack.append( x - y )

	def mul( self ):
		"""pop 2 values from the stack,
		push the product back on the stack.
		"""
		if len( self.stack ) >= 2:
			self.stack.append( self.stack.pop() * self.stack.pop() )

	def div( self ):
		"""pop 2 values from the stack,
		push the quotient back on the stack.
		"""
		if len( self.stack ) >= 2:
			y = self.stack.pop()
			if ( y == 0 ):
				print "cannot divide by 0.  Returning stack to previous state."
				self.stack.append( y )
			else:
				x = self.stack.pop()
				self.stack.append( x / y )

	def power( self ):
		"""pop 2 values from the stack,
		push the [-2] ** [-1] back on the stack
		"""
		if len( self.stack ) >= 2:
			y = self.stack.pop()
			x = self.stack.pop()
			self.stack.append( pow( x, y ))

	def swap( self ):
		"""swap the last 2 values on the stack"""
		if len( self.stack ) >= 2:
			y = self.stack.pop()
			x = self.stack.pop()
			self.stack.extend( [ y, x ] )

	def pop( self ):
		"""pop the last value off of the stack and discard"""
		if len( self.stack ) >= 1:
			self.stack.pop()

	def clear( self ):
		"""Clear the stack"""
		self.stack = []

	def pi( self ):
		"""Push pi onto the stack"""
		self.stack.append( math.pi )

	def e( self ):
		"""Push e onto the stack"""
		self.stack.append( math.e )

	def percent( self ):
		""" give the percent of a value
		1000 10 % = 1000 1000 10 100 / *
		"""
		if len( self.stack ) >= 2:
			y = self.stack.pop()
			x = self.stack.pop()
			self.stack.extend( [x, x, y, 100])
			self.parseLine( "/ *" )

	# This is at the end to be able to reference functions.
	commands = {
		"+": add,
		"-": sub,
		"*": mul,
		"/": div,
		"^": power,
		"swap": swap,
		"pop": pop,
		"ac": clear,
		"pi": pi,
		"e": e,
		"%": percent,
	}

if __name__ == "__main__":
	calc = RPNCalc()
	run = True

	while( run ):
		lineIn = raw_input( ">" )
		print calc.parseLine( lineIn )
