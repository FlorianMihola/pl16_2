#( string_literal | block | { '*' } name | '(' expression ')' ) { '.' name } [ '+' expression ]
#Expression evaluates to a particular string, it consists of left part, right part, whereas if 
#right part is nil, returns just the left part.
$valueName = "value"
class Expression
  attr_accessor :left
  #holds .name1.name2 ...
  attr_accessor :propertyReferences
  attr_accessor :right
  attr_accessor :reversed
  
  def initialize(left, propertyReferences, right)
    @left = left
    @propertyReferences = propertyReferences
    @right = right
    @reversed = false
  end
  
  def reverse!(lastExpression = nil)
    # Calculation should happen in this order A + B + C = (A+B) + C
    # Therefore reverse expressions (Currently: A + B + C = A + (B+C) )
    if @reversed == false
     if @right != nil
       tmp = @right
       if @left.is_a? Expression
         @right = @left.reverse!
       else
          @right = @left
       end
       @left = lastExpression
       @reversed = true
       return tmp.reverse!(self)       
     else
        @reversed = true
        if @left.is_a? Expression
            @right = @left.reverse!
        else
            @right = @left
         end
        @left = lastExpression
        return self
     end
    end
  end
  
  def visit(propertyList)
    #Check if @right is a Name
     if @right.is_a? Name
       noProperty = false
       #Solve reference
       currentPropertyList = propertyList
       i = 0
       while i < @right.level do
          currentPropertyList = currentPropertyList.parent
          i+=1
       end
       property = currentPropertyList.getItem(@right.name)
       if property == nil
         evaluatedRight = StringExpression.new("\"\"")
         noProperty = true
       end
       if noProperty == false
         @propertyReferences.referencedProperties.each { |p|
            if property.type == Types::STRING
              error
            end
            property = property.value.getItem(p)
            if property == nil
              evaluatedRight = StringExpression.new("\"\"")
              noProperty = true
              break
            end
          }
          if noProperty == false
            evaluatedRight = property.value
          end     
       end
     else
        evaluatedRight = @right
     end
     
     #Only right part of the assignment is present
     if (@left == nil)      
       if evaluatedRight.is_a? Block or evaluatedRight.is_a? PropertyList
           if evaluatedRight.is_a? Block
               #we need to store parent of the block 
               #otherwise recursive call of blocks would lead to false parent
               evaluatedRight.parent = propertyList
          end
          return evaluatedRight
       else
         evaluatedRight = evaluatedRight.visit(propertyList)    
         if evaluatedRight.is_a? Block
             #we need to store parent of the block 
             #otherwise recursive call of blocks would lead to false parent
             evaluatedRight.parent = propertyList
             return evaluatedRight
         end
         return resolveReference(evaluatedRight)
       end
     end
     evaluatedLeft = @left.visit(propertyList)
     if evaluatedLeft.is_a? Block
       evaluatedLeft = evaluatedLeft.visit(propertyList)
     end
     if evaluatedRight.is_a? Block
        evaluatedRight = evaluatedRight.visit(propertyList,evaluatedLeft)   
     else
       if !evaluatedRight.is_a? PropertyList
         evaluatedRight = evaluatedRight.visit(propertyList)
       end      
     end
     if evaluatedRight.is_a? Block
       evaluatedRight = evaluatedRight.visit(propertyList,evaluatedLeft)
     end 
     evaluatedRight = resolveReference(evaluatedRight)
     evaluatedLeft.mergeWith(evaluatedRight)
     return evaluatedLeft
  end
  
  def resolveReference(evaluatedRight)
    if !@right.is_a? Name
       property = nil
       #get the right property of the property list
       @propertyReferences.referencedProperties.each { |p|
         if property == nil
            property = evaluatedRight.getItem(p)
         else
            property = property.value.getItem(p)
         end        
         if property == nil
           evaluatedRight = StringExpression.new("\"\"")
           break
         end
       }
       if property != nil
         if !property.is_a? PropertyList
             #handle built in properties
             evaluatedRight = property.value.visit(evaluatedRight)
         else
            evaluatedRight = property.value
         end
       end
     end
     return evaluatedRight
  end
  
  def printList(depth)
    if @right != nil
        @right.printList(depth)
    end
    @propertyReferences.referencedProperties.each{|r| print "."+r}
    if @left != nil
        @left.printList(depth)
    end
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
  
  def printList(depth)
      print stringExpression
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
  
  def printList(depth)
    i = 0
    while i < level
      print '*'
      i+=1
    end
     print name
  end
end