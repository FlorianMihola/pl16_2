$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))

require 'Lexer'
require 'Interpreter'
require "PropertyList/PropertyList"

contents = File.read(ARGV[0])
lexer = Lexer.new(contents)
interpreter = Interpreter.new(lexer)
createdBlock = interpreter.block()
propertyList = PropertyList.new
propertyList = createdBlock.visit(propertyList)