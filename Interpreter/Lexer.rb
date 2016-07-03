require 'Token'

class Lexer
  
  def initialize(text)
    #pos is an index into text    
    @pos = 0
    @text = text
    @currentChar = text[@pos]
  end
  
  def error
    raise 'Invalid Character'
  end
  
  # Advance pos pointer and set new currentChar
  def advance 
     
    @pos += 1
    if @pos > @text.length - 1
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
  def name
    result = ''
    while @currentChar != nil and @currentChar.match(/[A-Za-z0-9_]/) != nil
      result += @currentChar
      advance
    end
    return result
  end
  
  def peekForAssignment?
    # We look for an assignment
    # It has to be of the form: "name '='"
    # name = /[A-Za-z0-9_]/
    
    if @text[@pos..-1] =~ /\A\s*=/ 
      return true
    end
    return false
  end
  
  def string
    # returns a string literal
    result = "\""
    advance
    while  @currentChar != nil and @currentChar != "\""
      result += @currentChar
      advance
    end
    if @currentChar == "\""
      result += @currentChar
      advance
    elsif
      error
    end
    return result
  end
  
  def comment
    # returns a comment
    # a comment begins with '%' and ends at the end of the line
    result = '%'
    advance
    while @currentChar != "\n" and @currentChar != nil
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
    
    if @currentChar  == '%'
       comment
       if @currentChar.match(/\s/) != nil
                skipWhitespaces
       end
    end 
    
    if @currentChar.match(/[A-Za-z0-9_]/) != nil
      return Token.new(NAME, name)
    end
    
    if @currentChar  == "\""
      return Token.new(STRING, string)
    end
    
    if @currentChar == '{'
      advance
      return Token.new(OPENING_BRACE,'{')
    end
    
    if @currentChar == '}'
      advance
      return Token.new(CLOSING_BRACE,'}')
    end
    
    if @currentChar == '['
      advance
      return Token.new(OPENING_BRACKET,'[')
    end
    
    if @currentChar == ']'
      advance
      return Token.new(CLOSING_BRACKET,']')
    end
    
    if @currentChar == ':'
      advance
      return Token.new(COLON,':')
    end
    
    if @currentChar == '*'
      advance
      return Token.new(ASTERIX,'*')
    end
    
    if @currentChar == '='
      advance
      return Token.new(EQUALS,'=')
    end
    
    if @currentChar == ';'
      advance
      return Token.new(SEMICOLON,';')
    end
    
    if @currentChar == '^'
      advance
      return Token.new(CIRCUMFLEX,'^')
    end
    
    if @currentChar == '+'
       advance
       return Token.new(PLUS,'+')
    end
    if @currentChar == '('
       advance
       return Token.new(OPENING_PARANTHESIS,'(')
    end
    if @currentChar == ')'
       advance
       return Token.new(CLOSING_PARANTHESIS,')')
    end
    if @currentChar == '.'
       advance
       return Token.new(DOT,'.')
    end
    
    error
    
    return Token.new(EOF,'EOF')   
    
  end
end