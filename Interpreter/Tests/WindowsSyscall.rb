require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

class WindowsSyscall < Test::Unit::TestCase
  def test_win_syscall
      contents = File.read('test14')
      lexer = Lexer.new(contents)
      interpreter = Interpreter.new(lexer)
      createdBlock = interpreter.block()
      propertyList = PropertyList.new
      propertyList = createdBlock.visit(propertyList)
      propertyList.printList
    end
    
  def test_win_syscall_simple
       contents = File.read('test15')
       lexer = Lexer.new(contents)
       interpreter = Interpreter.new(lexer)
       createdBlock = interpreter.block()
       propertyList = PropertyList.new
       propertyList = createdBlock.visit(propertyList)
       propertyList.printList
     end
end