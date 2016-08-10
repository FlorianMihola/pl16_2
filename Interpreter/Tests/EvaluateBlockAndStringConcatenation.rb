require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

class EvaluateBlockAndStringConcatenation  < Test::Unit::TestCase
  
  def test_blockAndStringConcatenationPropertyList
      contents = File.read('test6')
      lexer = Lexer.new(contents)
      interpreter = Interpreter.new(lexer)
      createdBlock = interpreter.block()
      assert_equal(1, createdBlock.commands.size)
      propertyList = createdBlock.visit(nil)
      assert_equal(1, propertyList.properties.size)
    end
end