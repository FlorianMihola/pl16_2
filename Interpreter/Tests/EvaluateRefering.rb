require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"
class EvaluateRefering < Test::Unit::TestCase
  
  def test_setValueOfAReferredProperty
    contents = File.read('test7')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
   end
  
  def test_resolveReferingInExpression
    contents = File.read('test8')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
    end
end