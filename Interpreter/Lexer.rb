require 'Token'

class Lexer
  def initialize(text)
    #pos is an index into text    
    @pos = 0
    @text = text
    @currentChar = text[pos]
  end
  
  def error
    raise 'Invalid Character'
  end
  
  # Advance pos pointer and set new currentChar
  def advance 
     
    @pos += 1
    if pos > text.length(text) - 1
      @currentChar = nil
    else 
      @currentChar = @text[@pos]
    end
   
  end
  
  def skipWhitespaces
    while @currentChar != nil and @currentChar.match(/\s/) != nil
      advance
    end
  end
  
  #Returns a string consumed from the input
  def string
    result = ''
    while @currentChar != nil and @currentChar.match(/[A-Za-z0-9_]/) != nil
      result += @currentChar
      advance
    end
    return result
  end
  
  # Method for breaking a sentence apart into tokens.
  # One token a time.
  def getNextToken
    
    if @currentChar.match(/\s/) != nil
          skipWhitespaces
    end
    
    if @currentChar.match(/[A-Za-z0-9_]/) != nil
      return Token(STRING, string)
    end
    
    if @currentChar == '{'
      return Token(OPENING_BRACE,'{')
    end
    
    if @currentChar == '}'
      return Token(CLOSING_BRACE,'}')
    end
    
    if @currentChar == '['
      return Token(OPENING_BRACKET,'[')
    end
    
    if @currentChar == ']'
      return Token(CLOSING_BRACKET,']')
    end
    
    if @currentChar == ':'
      return Token(COLON,':')
    end
    
    if @currentChar == '*'
      return Token(ASTERIX,'*')
    end
    
    if @currentChar == '='
      return Token(EQUALS,'=')
    end
    
    if @currentChar == ';'
      return Token(SEMICOLON,';')
    end
    
    if @currentChar == '^'
      return Token(CIRCUMFLEX,'^')
    end
    
    error
    
    return TOKEN(EOF,'EOF')   
    
  end
end