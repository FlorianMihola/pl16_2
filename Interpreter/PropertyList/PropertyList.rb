class PropertyList
  attr_accessor :properties
  #Holds the parental property list in order to allow bi-directional navigation through out the execution context (*)
  attr_accessor :parent
  
  def initialize
    @properties ||= Array.new
    @parent = nil
  end
  
  def addItem(name, value)
    singleItem = PropertyListSingleItem.new(name, value, Types::STRING)
    @properties.push(singleItem)
  end
  
  def addPropertyList(name, propertyList)
    propertyList.parent = self
    singleItem = PropertyListSingleItem.new(name, propertyList, Types::BLOCK)
    @properties.push(singleItem)
  end
  
  def mergeWith(propertyList)
    mergedList ||= Array.new 
    @properties.each{ |x|
      reflection = propertyList.getItem(x.name)
      if reflection != nil
        if x.type == Types::STRING && reflection.type == Types::STRING
          concatString = PropertyListSingleItem.new(x.name, x.value + reflection.value, Types::STRING)
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
  
  def getItem(name)
    return @properties.detect { |x| x.name == name}
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

module Types
  STRING = 1
  BLOCK = 2
end