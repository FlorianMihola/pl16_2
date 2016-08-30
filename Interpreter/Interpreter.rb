require 'Lexer'
require 'Nodes/Expression'
require 'Nodes/Command/AssignmentCommand'
require 'Nodes/Block'
require 'Nodes/Guard'
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
    #   -  { '*' } name 
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
    createdBlock = Block.new()
    values ||= Array.new
    # There might be multiple commands in a block
    while [OPENING_BRACKET, CIRCUMFLEX, ASTERIX,NAME].include? @currentToken.type or 
      checkForExpression? @currentToken.type 
      constructedCommand = command
      values.push(constructedCommand)
    end
    createdBlock.commands=(values)
    eat(CLOSING_BRACE)
    return createdBlock
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
      createdGuard = guard
      eat(COLON)
      # There might be multiple commands 
      createdCommands = Array.new
      while [OPENING_BRACKET, CIRCUMFLEX, ASTERIX,NAME].include? @currentToken.type or 
           checkForExpression? @currentToken.type 
           createdCommands.push(command)
      end
      eat(CLOSING_BRACKET)
      guardedCommand = GuardedCommand.new(createdGuard,createdCommands)
      return guardedCommand
          
    #(3)
    elsif @currentToken.type == CIRCUMFLEX
      eat(CIRCUMFLEX)
      createdExpression = expression
      eat(SEMICOLON)
      returnCommand = ReturnCommand.new(createdExpression)
      return returnCommand
    #(2) just else because also only simple expression is eligible here, simplifies a notation
    else
          
      createdName = nil
      if @lexer.peekForAssignment?
        level = 0
        while @currentToken.type == ASTERIX
           eat(ASTERIX)
           level += 1
        end
        createdName = Name.new(level, (@currentToken.value))
        eat(NAME)
        eat(EQUALS)
      end
      retValue = expression
      assignmentCommand = AssignmentCommand.new(createdName, retValue)
      eat(SEMICOLON)
      return assignmentCommand;
    end
    
  end
  
  def guard
    #
    #       guard      ::=  expression ( '=' | '#' ) expression [ ',' guard ]
    #
    
    expressionLeft = expression
    equals = false
    if @currentToken.type == EQUALS
      eat(EQUALS)
      equals = true
    else
      eat(HASH)
    end
    expressionRight = expression
    nextGuard = nil
    if @currentToken.type == COMMA
      eat(COMMA)
      nextGuard = guard
    end
    guard = Guard.new(expressionLeft, equals, expressionRight, nextGuard)
    return guard
  end
  
  def expression 
    #
    # expression ::= ( string_literal | block | { '*' } name | '(' expression ')' )
    #                 { '.' name } [ '+' expression ]
    #
  
    left = nil
    if @currentToken.type == STRING
      left = StringExpression.new(@currentToken.value)
      eat(STRING)
    elsif @currentToken.type == OPENING_BRACE
      left = block
    elsif @currentToken.type == ASTERIX or @currentToken.type == NAME
      level = 0
      while @currentToken.type == ASTERIX
         eat(ASTERIX)
         level += 1
      end
      left = Name.new(level, @currentToken.value)
      eat(NAME)
    elsif @currentToken.type == OPENING_PARANTHESIS
      eat(OPENING_PARANTHESIS)
      left = expression
      eat(CLOSING_PARANTHESIS)
    else
       error
    end
    
    
    propertyReferences = Array.new
    while @currentToken.type == DOT
      eat(DOT)
      propertyReferences.push(@currentToken.value)
      eat(NAME)
    end
    propertyReference = PropertyReference.new(propertyReferences)
    
    right = nil
    if @currentToken.type == PLUS
      eat(PLUS)
      right = expression
    end
    obj = Expression.new(left, propertyReference, right)
    return obj
  end
end
