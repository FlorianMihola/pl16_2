#( string_literal | block | { '*' } name | '(' expression ')' ) { '.' name } [ '+' expression ]
#Expression evaluates to a particular string, it consists of left part, right part, whereas if 
#right part is nil, returns just the left part.
$valueName = "value"
class Expression
  attr_accessor :left
  #holds .name1.name2 ...
  attr_accessor :propertyReferences
  attr_accessor :right
  
  def initialize(left, propertyReferences, right)
    @left = left
    @propertyReferences = propertyReferences
    @right = right
  end
  
  #Evaluates an expression
  #TODO Consider a context! Each visits need a context because of e.g. propert reference .asdf.asdf.asdf ...
  def visit(propertyList)
    
    #Check if left is a Name
    if @left.is_a? Name
      #Solve reference
      currentPropertyList = propertyList
      i = 0
      while i < @left.level do
         currentPropertyList = currentPropertyList.parent
         i+=1
      end
      property = currentPropertyList.getItemByStringName(@left.name)
      if property == nil
        error
      end
      @propertyReferences.referencedProperties.each{|p|
          if property.type == Types::STRING
            error
          end
          property = property.value.getItemByStringName(p)
          if property == nil
            error
          end
        }
      return property.value
    end
    
    #Only left part of the assignment is present
    if (@right == nil)
      evaluatedLeftExpression = @left.visit(propertyList)
      return evaluatedLeftExpression
      #TODO Handle the property reference somehow for the .syscall here
    end
    evaluatedLeft = @left.visit(propertyList)
    evaluatedRight = @right.visit(propertyList)
    evaluatedLeft.mergeWith(evaluatedRight)
    return evaluatedLeft
    
    #TODO include property reference lookup here!
#    if left == nil
#      raise 'Invalid expression, left part is compulsory'
#    end
#    if right != nil
#      return left.visit + right.visit
#    end
#    return left.visit()
  end
end

#holds .name.name2.name3 kind of syntax
class PropertyReference
  #holds the array of properites
  attr_accessor :referencedProperties
  def initialize(referencedProperties)
    @referencedProperties = referencedProperties
  end
end

#string_literal
class StringExpression
  
  attr_accessor :stringExpression
  
  def initialize(stringExpression)
    @stringExpression = stringExpression
  end
  
  def visit(propertyList)
    createdPropertyList = PropertyList.new
    createdPropertyList.addItem($valueName, @stringExpression)
    return createdPropertyList
  end
end

#{ '*' } name 
class Name
  #holds the amount of * before the name itself
  attr_accessor :level
  attr_accessor :name
  
  def initialize(level, name)
    @level = level
    @name = name
  end
end