require 'Lexer'
require 'Interpreter'

contents = File.read('test3')
lexer = Lexer.new(contents)
interpreter = Interpreter.new(lexer)
obj = interpreter.block()
print "asdf"