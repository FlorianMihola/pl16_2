require "test/unit"
require 'Lexer'
require 'Interpreter'

class GuardTest < Test::Unit::TestCase
 
  def test_processSimpleGuard
    contents = File.read('test3')
    lexer = Lexer.new(contents)
    interpreter = Interpreter.new(lexer)
    createdBlock = interpreter.block()
    assert_equal(7, createdBlock.commands.size)
    
    assert_equal("max", createdBlock.commands[0].name.name)
    assert_equal("\"5\"", createdBlock.commands[0].expression.left.stringExpression)
    assert_equal("min", createdBlock.commands[1].name.name)
    assert_equal("\"3\"", createdBlock.commands[1].expression.left.stringExpression)
    
    assert_equal("max", createdBlock.commands[2].guard.expressionLeft.left.name)
    assert_equal("min", createdBlock.commands[2].guard.expressionRight.left.name)
    assert_equal("a", createdBlock.commands[2].command.expression.left.commands[0].name.name)
    test = createdBlock.commands[2].command.expression.left.commands[0].expression
    assert_equal("\"2\"", createdBlock.commands[2].command.expression.left.commands[0].expression.left.stringExpression)
  end
 
end
