require "test/unit"
require 'Lexer'
require 'Interpreter'

class GuardTest < Test::Unit::TestCase
 
  def test_processSimpleGuard
    contents = File.read('test3')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    
  end
  
  def test_evaluateSimpleGuard
    contents = File.read('test9')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
  end
  
  
  def test_evaluateComplexGuard
    contents = File.read('test10')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    propertyList = PropertyList.new
    propertyList = createdBlock.visit(propertyList)
    propertyList.printList
  end
 
end
