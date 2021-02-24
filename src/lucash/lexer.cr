module Lucash
  class LexerError < Exception; end

  class Lexer
    @input : String
    @ch : String | Int32

    def initialize(@input)
      @position = 0      # current position in input (points to the current char)
      @read_position = 0 # current reading position in input (points to the next char)
      @ch = ""           # current char under examination
    end

    def read_char
      if @read_position >= @input.size
        @ch = 0
      else
        @ch = @input[@read_position, 1]
      end
      @position = @read_position
      @read_position += 1
    end

    def read_identifier
      pos = @position
      while is_letter?(@ch)
        read_char
      end
      @input[pos...@position]
    end

    def is_letter?(string)
      string.is_a?(String) && string =~ /[a-zA-Z_]+/
    end

    def next_token
      tok = case @ch
            when '='
              Token.new(Token::ASSIGN, @ch)
            when ';'
              Token.new(Token::SEMICOLON, @ch)
            when '('
              Token.new(Token::LPAREN, @ch)
            when ')'
              Token.new(Token::RPAREN, @ch)
            when ','
              Token.new(Token::COMMA, @ch)
            when '+'
              Token.new(Token::PLUS, @ch)
            when '{'
              Token.new(Token::LBRACE, @ch)
            when '}'
              Token.new(Token::RBRACE, @ch)
            when 0
              Token.new(Token::EOF, "")
            else
              if is_letter?(@ch)
                Token.new(read_identifier, @ch)
              else
                Token.new(Token::ILLEGAL, @ch)
              end
            end

      read_char

      return tok
    end
  end
end
