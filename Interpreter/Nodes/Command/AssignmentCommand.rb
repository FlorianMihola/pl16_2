require "PropertyList/PropertyList"

#[ { '*' } name '=' ] expression ';'          #(2)
#level is the amount of *
class AssignmentCommand
  attr_accessor :name
  attr_accessor :expression
  
  def initialize(name, expression)
    @name = name
    @expression = expression.reverse!
  end
  def visit(propertyList)
    expressionEvaluatedPropertyList = @expression.visit(propertyList)
    
    if name != nil
      if expressionEvaluatedPropertyList.is_a? Block
        propertyList.addProperty(name,expressionEvaluatedPropertyList)
      else
        propertyList.addPropertyList(name, expressionEvaluatedPropertyList)
      end  
    end
    return nil
  end
  
  def printList(depth)
    i = 0
    while i < depth
       i+=1
       print '  '  
    end
    if @name != nil
      print @name.name + ' = '
    end
    @expression.printList(depth)  
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
        message = nil
        @commands.each{ |x| 
              message = x.visit(propertyList)
              if message == "ReturnCommand"
                break;
              end
            }
        return message;
      end
  end
  
  def printList(depth)
      i = 0
      while i < depth
         i+=1
         print '  '  
      end
      @guard.printList(depth) 
      print ' : '
      @commands.each{|c| c.printList(depth)}
    end
end

#'^' expression ';'                           #(3)  
class ReturnCommand
  attr_accessor :expression
  
  def initialize(expression)
    @expression = expression.reverse!
  end
  
  def visit(propertyList)
    expressionEvaluatedPropertyList = expression.visit(propertyList)
    expressionEvaluatedPropertyList.parent = propertyList.parent
    propertyList.replace!(expressionEvaluatedPropertyList)
    return "ReturnCommand"
  end
  
  def printList(depth)
        i = 0
        while i < depth
           i+=1
           print '  '  
        end
        print '^ ' 
        @expression.printList(depth)
  end
end