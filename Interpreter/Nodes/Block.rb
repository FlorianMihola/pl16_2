require "PropertyList/PropertyList"


class Block
  attr_accessor :commands
  def initialize
    commands ||= Array.new
  end
  
  def visit(parent)
    propertyList = PropertyList.new()
    if (parent != nil)
      propertyList.parent = parent
    end
    @commands.each{ |x| x.visit(propertyList)}
    return propertyList
  end
end