require "./ast"
require "./lexer"
require "./token"

module Tesh
  class ParseError < Exception; end

  class Parser
    @lexer : Lexer

    def initialize(@lexer)
      @errors = [] of String
      @cur_token = Token.new(Token::ILLEGAL, "")
      @peek_token = Token.new(Token::ILLEGAL, "")
      @prefix_parse_fns = {
        Token::IDENT => ->(expr : Expression) { parse_identifier(expr) },
      } of String => Proc(Expression, Nil)
      @infix_parse_fns = {} of String => Proc(Expression, Nil)

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

    def prefix_parse
    end

    def infix_parse(expression)
    end

    def parse_statement
      case cur_token.type
      when Token::EXPORT
        parse_export_statement
      when Token::RETURN
        parse_return_statement
      else
        parse_expression_statement
      end
    end

    def parse_export_statement
      stmt = ExportStatement.new(cur_token)
      return nil unless expect_peek(Token::IDENT)
      stmt.name = Identifier.new(cur_token, cur_token.literal.to_s)
      return nil unless expect_peek(Token::ASSIGN)
      return nil unless expect_peek(Token::INT)
      stmt.value = Identifier.new(cur_token, cur_token.literal.to_s)
      return nil unless expect_peek(Token::SEMICOLON)
      return stmt
    end

    def parse_return_statement
      stmt = ReturnStatement.new(cur_token)
      return nil unless expect_peek(Token::INT)
      stmt.value = Identifier.new(cur_token, cur_token.literal.to_s)
      return nil unless expect_peek(Token::SEMICOLON)
      return stmt
    end

    def parse_expression_statement
      stmt = ExpressionStatement.new(cur_token)
      stmt.expression = parse_expression(:lowest)
      next_token if peek_token_is(Token::SEMICOLON)
      return stmt
    end

    def parse_identifier(ident)
    end

    def parse_expression(precedence)
      if prefix = @prefix_parse_fns[cur_token.type]
        prefix.call(cur_token)
      end
    end
  end
end
