require "./spec_helper"

describe Lucash::Lexer do
  describe "#next_token" do
    it "should be able to get tokens" do
      input = "let five = 5; let ten = 10; let add = fn(x, y) { x + y }; let result = add(five, ten);"

      lex = Lucash::Lexer.new(input)

      lex.next_token.data.should eq [Lucash::Token::LET, "let"]
      lex.next_token.data.should eq [Lucash::Token::IDENT, "five"]
      lex.next_token.data.should eq [Lucash::Token::ASSIGN, "="]
      lex.next_token.data.should eq [Lucash::Token::INT, "5"]
      lex.next_token.data.should eq [Lucash::Token::SEMICOLON, ";"]
    end
  end

  describe "#read_char" do
    it "is true when no elements are in the array" do
      ([] of Int32).empty?.should be_true
    end

    it "is false if there are elements in the array" do
      [1].empty?.should be_false
    end
  end
end
