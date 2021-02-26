require "./spec_helper"

describe Tesh::Lexer do
  describe "#next_token" do
    it "should be able to get basic tokens" do
      input = "let five = 5; let ten = 10; let add = fn(x, y) { x + y }; let result = add(five, ten);"

      lex = Tesh::Lexer.new(input)

      lex.next_token.data.should eq [Tesh::Token::LET, "let"]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "five"]
      lex.next_token.data.should eq [Tesh::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Tesh::Token::INT, "5"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::LET, "let"]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "ten"]
      lex.next_token.data.should eq [Tesh::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::LET, "let"]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "add"]
      lex.next_token.data.should eq [Tesh::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Tesh::Token::FUNCTION, "fn"]
      lex.next_token.data.should eq [Tesh::Token::LPAREN, "("]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "x"]
      lex.next_token.data.should eq [Tesh::Token::COMMA, ","]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "y"]
      lex.next_token.data.should eq [Tesh::Token::RPAREN, ")"]
      lex.next_token.data.should eq [Tesh::Token::LBRACE, "{"]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "x"]
      lex.next_token.data.should eq [Tesh::Token::PLUS, "+"]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "y"]
      lex.next_token.data.should eq [Tesh::Token::RBRACE, "}"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::LET, "let"]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "result"]
      lex.next_token.data.should eq [Tesh::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "add"]
      lex.next_token.data.should eq [Tesh::Token::LPAREN, "("]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "five"]
      lex.next_token.data.should eq [Tesh::Token::COMMA, ","]
      lex.next_token.data.should eq [Tesh::Token::IDENT, "ten"]
      lex.next_token.data.should eq [Tesh::Token::RPAREN, ")"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::EOF, ""]
    end

    it "should be able to get series of tokens" do
      input = "!-/*5; 5 < 10 > 5; if (5 < 10) { return true; } else { return false }"

      lex = Tesh::Lexer.new(input)

      lex.next_token.data.should eq [Tesh::Token::BANG, "!"]
      lex.next_token.data.should eq [Tesh::Token::MINUS, "-"]
      lex.next_token.data.should eq [Tesh::Token::SLASH, "/"]
      lex.next_token.data.should eq [Tesh::Token::ASTERISK, "*"]
      lex.next_token.data.should eq [Tesh::Token::INT, "5"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::INT, "5"]
      lex.next_token.data.should eq [Tesh::Token::LT, "<"]
      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::GT, ">"]
      lex.next_token.data.should eq [Tesh::Token::INT, "5"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::IF, "if"]
      lex.next_token.data.should eq [Tesh::Token::LPAREN, "("]
      lex.next_token.data.should eq [Tesh::Token::INT, "5"]
      lex.next_token.data.should eq [Tesh::Token::LT, "<"]
      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::RPAREN, ")"]
      lex.next_token.data.should eq [Tesh::Token::LBRACE, "{"]
      lex.next_token.data.should eq [Tesh::Token::RETURN, "return"]
      lex.next_token.data.should eq [Tesh::Token::TRUE, "true"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]
      lex.next_token.data.should eq [Tesh::Token::RBRACE, "}"]
      lex.next_token.data.should eq [Tesh::Token::ELSE, "else"]
      lex.next_token.data.should eq [Tesh::Token::LBRACE, "{"]
      lex.next_token.data.should eq [Tesh::Token::RETURN, "return"]
      lex.next_token.data.should eq [Tesh::Token::FALSE, "false"]
      lex.next_token.data.should eq [Tesh::Token::RBRACE, "}"]

      lex.next_token.data.should eq [Tesh::Token::EOF, ""]
    end

    it "should deal with compound keywords" do
      input = "10 == 10; 10 != 9; 10!=9"

      lex = Tesh::Lexer.new(input)

      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::EQ, "=="]
      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::NOT_EQ, "!="]
      lex.next_token.data.should eq [Tesh::Token::INT, "9"]
      lex.next_token.data.should eq [Tesh::Token::SEMICOLON, ";"]

      lex.next_token.data.should eq [Tesh::Token::INT, "10"]
      lex.next_token.data.should eq [Tesh::Token::NOT_EQ, "!="]
      lex.next_token.data.should eq [Tesh::Token::INT, "9"]

      lex.next_token.data.should eq [Tesh::Token::EOF, ""]
    end
  end
end
