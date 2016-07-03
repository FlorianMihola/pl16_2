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
      #debug
      puts 'Token: ' + @currentToken.toString + "\n"
      
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
    
    if [STRING, OPENING_BRACE, ASTERIX, OPENING_PARANTHESIS,NAME].include? tokenType
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
    while [OPENING_BRACKET, CIRCUMFLEX, ASTERIX,NAME].include? @currentToken.type or 
      checkForExpression? @currentToken.type 
      command
    end
    eat(CLOSING_BRACE)
   
  end
  
  def command
    #################################################################
    #
    #  command    ::=  '[' guard ':' { command } ']'                  #(1)
    #                 |  [ { '*' } name '=' ] expression ';'          #(2)
    #                 |  '^' expression ';'                           #(3)  
    #
    #########################################################
    
    #(1)
    if @currentToken.type == OPENING_BRACKET
  
      eat(OPENING_BRACKET)
      guard
      eat(COLON)
      # There might be multiple commands in a block
      while [OPENING_BRACKET, CIRCUMFLEX, ASTERIX,NAME].include? @currentToken.type or 
           checkForExpression? @currentToken.type 
           command
      end
      eat(CLOSING_BRACKET)
    
    #(3)
    elsif @currentToken.type == CIRCUMFLEX
      eat(CIRCUMFLEX)
      expression
      eat(SEMICOLON)
    
    #(2)
    elsif @currentToken.type == ASTERIX or @currentToken.type == NAME
      while @currentToken.type == ASTERIX
        eat(ASTERIX)
      end
      if @lexer.peekForAssignment?
        eat(NAME)
        eat(EQUALS)
      end
      expression
      eat(SEMICOLON)
    end
    
  end
  
  def guard
    #
    #       guard      ::=  expression ( '=' | '#' ) expression [ ',' guard ]
    #
    
    expression
    if @currentToken.type == EQUALS
      eat(EQUALS)
    else
      eat(HASH)
    end
    expression
    if @currentToken.type == COMMA
      eat(COMMA)
      guard
    end
  end
  
  def expression
    #
    # expression ::= ( string_literal | block | { '*' } name | '(' expression ')' )
    #                 { '.' name } [ '+' expression ]
    #
  
    if @currentToken.type == STRING
      eat(STRING)
    elsif @currentToken.type == OPENING_BRACE
      block
    elsif @currentToken.type == ASTERIX or @currentToken.type == NAME
      while @currentToken.type == ASTERIX
         eat(ASTERIX)
      end
      eat(NAME)
    elsif @currentToken.type == OPENING_PARANTHESIS
      eat(OPENING_PARANTHESIS)
      expression
      eat(CLOSING_PARANTHESIS)
    else
       error
    end
    
    while @currentToken.type == DOT
      eat(DOT)
      eat(NAME)
    end
    
    if @currentToken.type == PLUS
      eat(PLUS)
      expression
    end
  end
end
