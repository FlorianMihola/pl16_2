#       guard      ::=  expression ( '=' | '#' ) expression [ ',' guard ]
#Is implemented as a chain -> nextGuard is nil if it the current one is the last member of the chain
class Guard
  attr_accessor :expressionLeft
  #If true, stands for =, if false stands for differs
  attr_accessor :equals
  attr_accessor :expressionRight
  attr_accessor :nextGuard
  
  def initialize(expressionLeft, equals, expressionRight, nextGuard)
    @expressionLeft = expressionLeft
    @equals = equals
    @expressionRight = expressionRight
    @nextGuard = nextGuard
  end
end