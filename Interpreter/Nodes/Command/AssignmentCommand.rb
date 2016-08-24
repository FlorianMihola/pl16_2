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
    #check if there is actually an assignment
    if name != nil
      propertyList.addPropertyList(name, expressionEvaluatedPropertyList)
    end  
    return nil
  end
end

#'[' guard ':' { command } ']'                  #(1)
class GuardedCommand
  attr_accessor :guard
  attr_accessor :commands
  
  def initialize(guard, commands)
    @guard = guard
    @commands = commands
  end
  
  def visit(propertyList)
      #check if guard is satisfied
      if @guard.guard?(propertyList)
        @commands.each{ |c| c.visit(propertyList)}
      end
      return nil
  end
end

#'^' expression ';'                           #(3)  
class ReturnCommand
  attr_accessor :expression
  
  def initialize(expression)
    @expression = expression
  end
  
  def visit(propertyList)
    expressionEvaluatedPropertyList = expression.visit(propertyList)
    expressionEvaluatedPropertyList.parent = propertyList.parent
    propertyList.replace!(expressionEvaluatedPropertyList)
  end
end