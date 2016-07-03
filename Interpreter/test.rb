require 'Lexer'
require 'Interpreter'

contents = File.read('test')
lexer = Lexer.new(contents)
interpreter = Interpreter.new(lexer)
interpreter.block()