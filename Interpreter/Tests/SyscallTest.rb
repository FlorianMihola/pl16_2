require "test/unit"
require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

class SyscallTest < Test::Unit::TestCase
  def test_syscall
      contents = File.read('test13')
      lexer = Lexer.new(contents)
      interpreter = Interpreter.new(lexer)
      createdBlock = interpreter.block()
      propertyList = PropertyList.new
      propertyList = createdBlock.visit(propertyList)
      propertyList.printList
    end
end