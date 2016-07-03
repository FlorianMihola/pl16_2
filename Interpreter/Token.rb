# Token types
#
# EOF (end-of-file) token is used to indicate that
# there is no more input left for lexical analysis
NAME, PLUS, ASTERIX, CIRCUMFLEX, EQUALS, EOF,
OPENING_BRACE, CLOSING_BRACE, OPENING_PARANTHESIS,
CLOSING_PARANTHESIS, OPENING_BRACKET,CLOSING_BRACKET,
COLON, SEMICOLON, HASH, COMMA, DOT, STRING, PERCENT = 'NAME', 'PLUS', 
'ASTERIX', 'CIRCUMFLEX', 'EQUALS', 'EOF',
'OPENING_BRACE', 'CLOSING_BRACE', 'OPENING_PARANTHESIS',
'CLOSING_PARANTHESIS', 'OPENING_BRACKET','CLOSING_BRACKET',
'COLON', 'SEMICOLON', 'HASH', 'COMMA', 'DOT', 'STRING', 'PERCENT'


class Token
  attr_accessor :type
  attr_accessor :value
  
  def initialize(type, value)
    @type = type
    @value = value
  end
  
  def toString
    return 'Format(' + @type + ', ' + @value + ')' 
  end
  
end