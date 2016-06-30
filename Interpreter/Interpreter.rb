require 'Lexer'

class Interpreter 
  
  def initialize(lexer)
    @lexer = lexer
    @currentToken = lexer.getNextToken
  end
  
  def error
    raise 'Invalid syntax'
  end
  
  def eat(tokenType)
    # compare the current token type with the passed token
    # type and if they match then "eat" the current token
    # and assign the next token to the self.current_token,
    # otherwise raise an exception.
    
    if @currentToken.type == tokenType
      @currentToken =  @lexer.getNextToken
    else
      error
    end
  end
  
  def checkForExpression?(tokenType)
    # An expression can start with 
    #   -  string literal
    #   -  block ('{')
    #   -  { '*' } name(string literal) 
    #   -  '('
    
    if [STRING, OPENING_BRACE, ASTERIX, OPENING_PARANTHESIS].include? tokenType
          return true
    end
    
    return false
  end
  
  
  def block
    #########################################################
    #
    #  block      ::=  '{' { command } '}'
    #
    #  command    ::=  '[' guard ':' { command } ']'
    #                 |  [ { '*' } name '=' ] expression ';'
    #                 |  '^' expression ';'
    #
    #########################################################
    
    eat(OPENING_BRACE)
    # There might be multiple commands in a block
    while [OPENING_BRACKET,CIRCUMFLEX,ASTERIX,STRING].include? @currentToken.type or 
      checkForExpression? @currentToken.type 
      # Note that '+=' needs to be replaced with a valid way to handle the result of mulitple commands 
      result += command
    end
    eat(CLOSING_BRACE)
    
    return result
  end
  
end