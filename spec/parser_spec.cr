require "./spec_helper"

describe Tesh::Parser do
  describe "#parse_program" do
    it "should work for valid export statements" do
      input = "export x=5; export y=10; export foobar = 838383;"

      l = Tesh::Lexer.new(input)
      p = Tesh::Parser.new(l)
      program = p.parse_program
      p.errors.should eq([] of String)
      program.statements.size.should eq(3)
      program.to_s.should eq "export x = 5; export y = 10; export foobar = 838383;"

      [
        ["x"],
        ["y"],
        ["foobar"],
      ].each_with_index do |test, i|
        stmt = program.statements[i]
        stmt.token_literal.should eq "export"
      end
    end

    it "shouldn't work for invalid export statements" do
      input = "export x 5; export = 10; export 838383;"

      l = Tesh::Lexer.new(input)
      p = Tesh::Parser.new(l)
      program = p.parse_program
      p.errors.size.should eq(3)
      p.errors.should eq(["Expected next token to be = but got INT instead", "Expected next token to be IDENT but got = instead", "Expected next token to be IDENT but got INT instead"])
    end

    it "should work for valid return statements" do
      input = "return 5; return 10; return 123943943;"

      l = Tesh::Lexer.new(input)
      p = Tesh::Parser.new(l)
      program = p.parse_program
      p.errors.should eq([] of String)
      program.statements.size.should eq(3)
      program.to_s.should eq input

      [
        ["5"],
        ["10"],
        ["123943943"],
      ].each_with_index do |test, i|
        stmt = program.statements[i]
        stmt.token_literal.should eq "return"
      end
    end

    it "shouldn't work for invalid return statements" do
      input = "return wiuhfduisdh; return;"

      l = Tesh::Lexer.new(input)
      p = Tesh::Parser.new(l)
      program = p.parse_program
      p.errors.size.should eq(2)
      p.errors.should eq(["Expected next token to be INT but got IDENT instead", "Expected next token to be INT but got ; instead"])
    end
  end
end
