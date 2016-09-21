require "PropertyList/PropertyList"


class Block
  attr_accessor :commands
  attr_accessor :parent 
  def initialize
    @commands ||= Array.new
    @parent = nil
  end
  
  def visit(parent,arguments = nil)
    propertyList = PropertyList.new()
    if arguments != nil
      propertyList.mergeWith(arguments)
    end
    if (@parent != nil)
      propertyList.parent = @parent
    else
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