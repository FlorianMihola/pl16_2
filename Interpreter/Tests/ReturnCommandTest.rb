require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

class ReturnCommandTest < Test::Unit::TestCase
  def test_returnCommand
      contents = File.read('test11')
      lexer = Lexer.new(contents)
      interpreter = Interpreter.new(lexer)
      createdBlock = interpreter.block()
      propertyList = PropertyList.new
      propertyList = createdBlock.visit(propertyList)
      propertyList.printList
      assert_equal('"test"',  propertyList.getItemByStringName("a").value.getItemByStringName("b").value.getItemByStringName("value").value)
    end
end