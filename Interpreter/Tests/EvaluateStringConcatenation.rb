require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

class EvaluateStringConcatenation < Test::Unit::TestCase
  
  def test_stringConcatenationEvaluatesIntoCorrectPropertyList
    contents = File.read('test5')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    assert_equal(1, createdBlock.commands.size)
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
    assert_equal(1, propertyList.properties.size)
  end
end