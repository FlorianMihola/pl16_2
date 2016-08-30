require "PropertyList/PropertyList"


class Block
  attr_accessor :commands
  def initialize
    @commands ||= Array.new
  end
  
  def visit(parent)
    propertyList = PropertyList.new()
    if (parent != nil)
      propertyList.parent = parent
    end
    @commands.each{ |x| 
      message = x.visit(propertyList)
      if message == "ReturnCommand"
        break;
      end
    }
    return propertyList
  end
  
  def printList(depth)
    i = 0
    while i < depth
       i+=1
       print '  '  
    end
    puts '{'
    @commands.each{ |x| 
      x.printList(depth+1) 
      print "\n"
    }
    i = 0
    while i < depth
       i+=1
       print '  '  
    end
    puts '}'
  end
end