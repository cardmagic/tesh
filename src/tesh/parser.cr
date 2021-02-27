require "./ast"
require "./lexer"
require "./token"

module Tesh
  class ParseError < Exception; end

  class Parser
    @lexer : Lexer
    @cur_token : Token
    @peek_token : Token

    def initialize(@lexer)
      @errors = [] of String
      @cur_token = Token.new(Token::ILLEGAL, "")
      @peek_token = Token.new(Token::ILLEGAL, "")
      # Read two token, so @cur_token and @peek_token are both set
      next_token
      next_token
    end

    def cur_token
      @cur_token
    end

    def peek_token
      @peek_token
    end

    def errors
      @errors
    end

    def next_token
      @cur_token = @peek_token
      @peek_token = @lexer.next_token
    end

    def cur_token_is?(token_type)
      cur_token.type == token_type
    end

    def peek_token_is?(token_type)
      peek_token.type == token_type
    end

    def expect_peek(token_type)
      if peek_token_is?(token_type)
        next_token
        true
      else
        peek_error(token_type)
        false
      end
    end

    def peek_error(token_type)
      @errors << "Expected next token to be #{token_type} but got #{peek_token.type} instead"
    end

    def parse_program
      program = Program.new

      while cur_token.type != Token::EOF
        if stmt = parse_statement
          program << stmt
        end
        next_token
      end

      program
    end

    def parse_statement
      case cur_token.type
      when Token::EXPORT
        parse_export_statement
      else
        nil
      end
    end

    def parse_export_statement
      stmt = ExportStatement.new(cur_token)
      return nil unless expect_peek(Token::IDENT)
      stmt.name = Identifier.new(cur_token, cur_token.literal)
      return nil unless expect_peek(Token::ASSIGN)
      return nil unless expect_peek(Token::INT)
      return nil unless expect_peek(Token::SEMICOLON)
      return stmt
    end
  end
end
