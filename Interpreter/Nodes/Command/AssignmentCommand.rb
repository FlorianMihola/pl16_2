require "PropertyList/PropertyList"

#[ { '*' } name '=' ] expression ';'          #(2)
#level is the amount of *
class AssignmentCommand
  attr_accessor :name
  attr_accessor :expression
  
  def initialize(name, expression)
    @name = name
    @expression = expression
  end
  def visit(propertyList)
    #TODO
    expressionEvaluatedPropertyList = expression.visit(propertyList)
    
    #TODO Handle nested name reference (*)
    propertyList.addPropertyList(name.name, expressionEvaluatedPropertyList)
    return nil
  end
end

#'[' guard ':' { command } ']'                  #(1)
class GuardedCommand
  attr_accessor :guard
  attr_accessor :command
  
  def initialize(guard, command)
    @guard = guard
    @command = command
  end
end

#'^' expression ';'                           #(3)  
class ReturnCommand
  attr_accessor :expression
  
  def initialize(expression)
    @expression = expression
  end
end