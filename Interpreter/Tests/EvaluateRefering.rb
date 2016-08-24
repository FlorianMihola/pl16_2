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
    assert_equal('"5"',  propertyList.getItemByStringName("i").value.getItemByStringName("value").value)
    assert_equal('"1"',  propertyList.getItemByStringName("program").value.getItemByStringName("a").value.getItemByStringName("value").value)
  end
  
  def test_resolveReferingInExpression
    contents = File.read('test8')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
    assert_equal('"9"',  propertyList.getItemByStringName("program").value.getItemByStringName("b").value.getItemByStringName("s").value.getItemByStringName("value").value)
  end
end