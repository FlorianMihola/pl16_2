require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

class PropertyListEvaluationTest < Test::Unit::TestCase
  
  def test_evaluateBlockPropertyList
    contents = File.read('test4')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    assert_equal(2, createdBlock.commands.size)
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
    assert_equal(2, propertyList.properties.size)
  end
end