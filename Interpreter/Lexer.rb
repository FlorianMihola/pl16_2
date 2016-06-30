require 'Token'

class Lexer
  def initialize(text)
    #pos is an index into text    
    @pos = 0
    @text = text
    @current_char = text[pos]
  end
  
  def error
    raise 'Invalid Character'
  end
  
  # Advance pos pointer and set new current_char
  def advance 
     
    @pos += 1
    if pos > text.length(text) - 1
      @current_char = nil
    else 
      @current_char = @text[@pos]
    end
   
  end
  
  def skipWhitespaces
    while @current_char != nil and @current_char.match(/\s/) != nil
      advance
    end
  end
  
  #Returns a string consumed from the input
  def string
    result = ''
    while @current_char != nil and @current_char.match(/[A-Za-z0-9_]/) != nil
      result += @current_char
      advance
    end
    return result
  end
  
  # Method for breaking a sentence apart into tokens.
  # One token a time.
  def getNextToken
    
    if @current_char.match(/\s/) != nil
          skipWhitespaces
    end
    
    if @current_char.match(/[A-Za-z0-9_]/) != nil
      return Token(STRING, string)
    end
    
    if @current_char == '{'
      return Token(OPENING_BRACE,'{')
    end
    
    if @current_char == '}'
      return Token(CLOSING_BRACE,'}')
    end
    
    if @current_char == '['
      return Token(OPENING_BRACKET,'[')
    end
    
    if @current_char == ']'
      return Token(CLOSING_BRACKET,']')
    end
    
    if @current_char == ':'
      return Token(COLON,':')
    end
    
    if @current_char == '*'
      return Token(ASTERIX,'*')
    end
    
    if @current_char == '='
      return Token(EQUALS,'=')
    end
    
    if @current_char == ';'
      return Token(SEMICOLON,';')
    end
    
    if @current_char == '^'
      return Token(CIRCUMFLEX,'^')
    end
    
    error
    
    return TOKEN(EOF,'EOF')   
    
  end
end