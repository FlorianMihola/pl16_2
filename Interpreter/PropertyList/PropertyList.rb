class PropertyList
  attr_accessor :properties
  #Holds the parental property list in order to allow bi-directional navigation through out the execution context (*)
  attr_accessor :parent
  
  def initialize
    @properties ||= Array.new
    @parent = nil
    addSyscall
    addSyscall2
  end
  
  def addSyscall
    singleItem = PropertyListSingleItem.new(Name.new(0,"syscall"), Syscall.new, Types::BLOCK)
    @properties.push(singleItem)
  end
  def addSyscall2
      singleItem = PropertyListSingleItem.new(Name.new(0,"syscall2"), Syscall2.new, Types::BLOCK)
      @properties.push(singleItem)
  end
  
  def addItem(name, value)
    singleItem = PropertyListSingleItem.new(name, value, Types::STRING)
    @properties.push(singleItem)
  end
  
  def addProperty(name, value)
      currentPropertyList = self
      #Find property - go amount of * up
      i = 0
      while i < name.level do
        currentPropertyList = currentPropertyList.parent
        i+=1
      end
      #Find property - look for property
      property = currentPropertyList.properties.find { |x| x.name.name == name.name}
      if property == nil
        singleItem = PropertyListSingleItem.new(name, value, Types::BLOCK)
        currentPropertyList.properties.push(singleItem)
      else  
        property.value = value
        property.type = Types::BLOCK
      end
    end
  
  def addPropertyList(name, propertyList)
    propertyList.parent = self
    currentPropertyList = propertyList
    #Find property - go amount of * up
    i = 0
    while i < name.level do
      currentPropertyList = currentPropertyList.parent
      i+=1
    end
    #Find property - look for property
    property = currentPropertyList.parent.properties.find { |x| x.name.name == name.name}
    if property == nil
      singleItem = PropertyListSingleItem.new(name, propertyList, Types::BLOCK)
      currentPropertyList.parent.properties.push(singleItem)
    else  
      property.value = propertyList
      property.type = Types::BLOCK
    end
  end
  
  def mergeWith(propertyList)
    mergedList ||= Array.new 
    @properties.each{ |x|
      if x.type == Types::STRING
        reflection = propertyList.getItem(x.name)
      else
        reflection = propertyList.getItem(x.name.name)
      end
      if reflection != nil
        if x.type == Types::STRING && reflection.type == Types::STRING
          newValue = x.value + reflection.value
          newValue.gsub!(/"/,'')
          newValue = '"' + newValue + '"'
          concatString = PropertyListSingleItem.new(x.name, newValue , Types::STRING)
          mergedList.push(concatString)
        
        else 
          mergedList.push(reflection)
        end
      
      else
        mergedList.push(x)
      end
    }
    propertyList.properties.each{ |x|
      if (mergedList.detect { |y| y.name == x.name } == nil)
        mergedList.push(x)
      end
    }
    @properties = mergedList
  end
  
  def replace!(propertyList)
    @properties = propertyList.properties
    @parent = propertyList.parent
  end
  
  def getItem(name)
    return @properties.find { |x| 
      if x.name.is_a? String 
        x.name == name  
      else
        x.name.name == name
      end
    }
  end
  
  def printList(depth = 0)
   @properties.each{ |x|
     i = 0
     while i < depth
       i+=1
       print '  '  
     end
     if x.type == Types::STRING
       puts 'Property: ' + x.name + ' = ' + x.value  
     else
       puts 'Property: ' + x.name.name + ' = {'
       x.value.printList(depth+1)
       i = 0
        while i < depth
          i+=1
          print '  '  
        end
       puts '}'
     end
   }
  end
end

#Encapsulates evaluated property
class PropertyListSingleItem
  attr_accessor :name
  attr_accessor :value
  attr_accessor :type
  
  def initialize(name, value, type)
    @name = name
    @value = value
    @type = type
  end
end

class Syscall
  
  def visit(propertyList)
    #get StringPropertyList
    item = propertyList.getItem($valueName)
    if item != nil
      #string = 'ruby ./'+item.value
      string = item.value
      string.gsub!(/\"/,'')
      code = system(string)
      if code == false
        se = StringExpression.new('"0"')
        code = PropertyList.new()
        code = se.visit(code)
      end
      if code == true
        se = StringExpression.new('"1"')
        code = PropertyList.new()
        code = se.visit(code)
      end
      return code
    else
      return StringExpression.new("\"\"")
    end
  end
  
  def printList(depth)
  end
end

class Syscall2
  
  def visit(propertyList)
    #get StringPropertyList
    item = propertyList.getItem($valueName)
    if item != nil
      #string = 'ruby ./'+item.value
      string = item.value
      string.gsub!(/\"/,'')
      code = `#{string}`
      code.tr!("\n",'')
      code = "\"" + code + "\""
      se = StringExpression.new(code)
      code = PropertyList.new()
      code = se.visit(code)
      return code
    else
      return StringExpression.new("\"\"")
    end
  end
  
  def printList(depth)
  end
end

module Types
  STRING = 1
  BLOCK = 2
end