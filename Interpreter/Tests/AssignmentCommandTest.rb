require "test/unit"
require 'Lexer'
require 'Interpreter'

class AssignmentCommandTest < Test::Unit::TestCase
 
  def test_createBasicAssingmentCommandWithNameAndExpression
    contents = File.read('test')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    assert_equal(1, createdBlock.commands.size)
    assert_equal("max", createdBlock.commands[0].name.name)
    assert_equal(0, createdBlock.commands[0].name.level)
    assert_equal("\"5\"", createdBlock.commands[0].expression.left.stringExpression)
  end
  
  def test_createBasicAssingmentCommandWithNameAndExpressionAndReferenceLevel1
    contents = File.read('test2')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    assert_equal(1, createdBlock.commands.size)
    assert_equal("max", createdBlock.commands[0].name.name)
    assert_equal(1, createdBlock.commands[0].name.level)
    assert_equal("\"5\"", createdBlock.commands[0].expression.left.stringExpression)
  end
 
end
