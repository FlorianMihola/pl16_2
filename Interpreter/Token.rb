# Token types
#
# EOF (end-of-file) token is used to indicate that
# there is no more input left for lexical analysis
STRING, PLUS, ASTERIX, CIRCUMFLEX, EQUALS, EOF,
OPENING_BRACE, CLOSING_BRACE, OPENING_PARANTHESIS,
CLOSING_PARANTHESIS, OPENING_BRACKET,CLOSING_BRACKET,
COLON, SEMICOLON, HASH, COMMA, DOT = 'STRING', 'PLUS', 
'ASTERIX', 'CIRCUMFLEX', 'EQUALS', 'EOF',
'OPENING_BRACE', 'CLOSING_BRACE', 'OPENING_PARANTHESIS',
'CLOSING_PARANTHESIS', 'OPENING_BRACKET','CLOSING_BRACKET',
'COLON', 'SEMICOLON', 'HASH', 'COMMA', 'DOT'


class Token
  attr_accessor :type
  attr_accessor :value
  
  def initialize(type, value)
    @type = type
    @value = value
  end
  
  def toString
    return "Format(" + @type + ", " + @value + ")" 
  end
  
end