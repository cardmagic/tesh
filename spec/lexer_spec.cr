require "./spec_helper"

describe Lucash::Lexer do
  describe "#next_token" do
    it "should be able to get basic tokens" do
      input = "let five = 5; let ten = 10; let add = fn(x, y) { x + y }; let result = add(five, ten);"

      lex = Lucash::Lexer.new(input)

      lex.next_token.data.should eq [Lucash::Token::LET, "let"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "five"]
      lex.next_token.data.should eq [Lucash::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Lucash::Token::INT, "5"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::LET, "let"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "ten"]
      lex.next_token.data.should eq [Lucash::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::LET, "let"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "add"]
      lex.next_token.data.should eq [Lucash::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Lucash::Token::FUNCTION, "fn"]
      lex.next_token.data.should eq [Lucash::Token::LPAREN, "("]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "x"]
      lex.next_token.data.should eq [Lucash::Token::COMMA, ","]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "y"]
      lex.next_token.data.should eq [Lucash::Token::RPAREN, ")"]
      lex.next_token.data.should eq [Lucash::Token::LBRACE, "{"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "x"]
      lex.next_token.data.should eq [Lucash::Token::PLUS, "+"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "y"]
      lex.next_token.data.should eq [Lucash::Token::RBRACE, "}"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::LET, "let"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "result"]
      lex.next_token.data.should eq [Lucash::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "add"]
      lex.next_token.data.should eq [Lucash::Token::LPAREN, "("]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "five"]
      lex.next_token.data.should eq [Lucash::Token::COMMA, ","]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "ten"]
      lex.next_token.data.should eq [Lucash::Token::RPAREN, ")"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::EOF, ""]
    end

    it "should be able to get series of tokens" do
      input = "!-/*5; 5 < 10 > 5; if (5 < 10) { return true; } else { return false }"

      lex = Lucash::Lexer.new(input)

      lex.next_token.data.should eq [Lucash::Token::BANG, "!"]
      lex.next_token.data.should eq [Lucash::Token::MINUS, "-"]
      lex.next_token.data.should eq [Lucash::Token::SLASH, "/"]
      lex.next_token.data.should eq [Lucash::Token::ASTERISK, "*"]
      lex.next_token.data.should eq [Lucash::Token::INT, "5"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::INT, "5"]
      lex.next_token.data.should eq [Lucash::Token::LT, "<"]
      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::GT, ">"]
      lex.next_token.data.should eq [Lucash::Token::INT, "5"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::IF, "if"]
      lex.next_token.data.should eq [Lucash::Token::LPAREN, "("]
      lex.next_token.data.should eq [Lucash::Token::INT, "5"]
      lex.next_token.data.should eq [Lucash::Token::LT, "<"]
      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::RPAREN, ")"]
      lex.next_token.data.should eq [Lucash::Token::LBRACE, "{"]
      lex.next_token.data.should eq [Lucash::Token::RETURN, "return"]
      lex.next_token.data.should eq [Lucash::Token::TRUE, "true"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]
      lex.next_token.data.should eq [Lucash::Token::RBRACE, "}"]
      lex.next_token.data.should eq [Lucash::Token::ELSE, "else"]
      lex.next_token.data.should eq [Lucash::Token::LBRACE, "{"]
      lex.next_token.data.should eq [Lucash::Token::RETURN, "return"]
      lex.next_token.data.should eq [Lucash::Token::FALSE, "false"]
      lex.next_token.data.should eq [Lucash::Token::RBRACE, "}"]

      lex.next_token.data.should eq [Lucash::Token::EOF, ""]
    end

    it "should deal with compound keywords" do
      input = "10 == 10; 10 != 9; 10!=9"

      lex = Lucash::Lexer.new(input)

      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::EQ, "=="]
      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::NOT_EQ, "!="]
      lex.next_token.data.should eq [Lucash::Token::INT, "9"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Lucash::Token::INT, "10"]
      lex.next_token.data.should eq [Lucash::Token::NOT_EQ, "!="]
      lex.next_token.data.should eq [Lucash::Token::INT, "9"]

      lex.next_token.data.should eq [Lucash::Token::EOF, ""]
    end
  end
end
