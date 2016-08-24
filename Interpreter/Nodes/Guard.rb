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
  
  #Checks the guard and returns true or false as result
  def guard?(propertyList)
    evaluatedLeftPropertyList = @expressionLeft.visit(propertyList)
    evaluatedRightPropertyList = @expressionRight.visit(propertyList)
    if evaluatedLeftPropertyList.getItemByStringName("value").value ==
      evaluatedRightPropertyList.getItemByStringName("value").value
      if @equals
        if @nextGuard != nil
          return @nextGuard.guard?(propertyList)
        end
      else
        return false
      end
    else
      if @equals
        return false 
      else
        if @nextGuard != nil
          return @nextGuard.guard?(propertyList)
        end
      end
    end
    return true
  end
end