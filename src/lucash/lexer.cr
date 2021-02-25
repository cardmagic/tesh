module Lucash
  class LexerError < Exception; end

  class Lexer
    @input : String
    @ch : String | Int32

    def initialize(@input)
      @position = 0      # current position in input (points to the current char)
      @read_position = 0 # current reading position in input (points to the next char)
      @ch = ""           # character to be evaluated

      read_char # reads the first char
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

    def peek_char
      if @read_position >= @input.size
        0
      else
        @input[@read_position, 1]
      end
    end

    def read_identifier
      pos = @position
      while is_letter?(@ch)
        read_char
      end
      @input[pos...@position]
    end

    def read_digit
      pos = @position
      while is_digit?(@ch)
        read_char
      end
      @input[pos...@position]
    end

    def skip_whitespace
      while @ch =~ /\s+/
        read_char
      end
    end

    def is_letter?(str)
      if str.is_a?(String)
        str =~ /[a-zA-Z_]+/
      else
        false
      end
    end

    def is_digit?(str)
      if str.is_a?(String)
        str =~ /[0-9]+/
      else
        false
      end
    end

    def next_token
      skip_whitespace

      tok = case @ch
            when "="
              if peek_char == "="
                read_char
                Token.new(Token::EQ, "==")
              else
                Token.new(Token::ASSIGN, @ch)
              end
            when ";"
              Token.new(Token::SEMICOLON, @ch)
            when "("
              Token.new(Token::LPAREN, @ch)
            when ")"
              Token.new(Token::RPAREN, @ch)
            when ","
              Token.new(Token::COMMA, @ch)
            when "+"
              Token.new(Token::PLUS, @ch)
            when "-"
              Token.new(Token::MINUS, @ch)
            when "!"
              if peek_char == "="
                read_char
                Token.new(Token::NOT_EQ, "!=")
              else
                Token.new(Token::BANG, @ch)
              end
            when "/"
              Token.new(Token::SLASH, @ch)
            when "*"
              Token.new(Token::ASTERISK, @ch)
            when "<"
              Token.new(Token::LT, @ch)
            when ">"
              Token.new(Token::GT, @ch)
            when "{"
              Token.new(Token::LBRACE, @ch)
            when "}"
              Token.new(Token::RBRACE, @ch)
            when 0
              Token.new(Token::EOF, "")
            else
              if is_letter?(@ch)
                ident = read_identifier
                return Token.new(Token.lookup_ident(ident), ident)
              elsif is_digit?(@ch)
                digit = read_digit
                return Token.new(Token::INT, digit)
              else
                Token.new(Token::ILLEGAL, @ch)
              end
            end

      read_char

      return tok
    end
  end
end
