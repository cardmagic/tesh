require "./spec_helper"

describe Tesh::Parser do
  describe "#parse_program" do
    it "works for export statements" do
      input = "export x=5; export y=10; export foobar = 838383;"

      l = Tesh::Lexer.new(input)
      p = Tesh::Parser.new(l)
      program = p.parse_program
      program.statements.size.should eq(3)

      [
        ["x"],
        ["y"],
        ["foobar"],
      ].each_with_index do |test, i|
        stmt = program.statements[i]
        stmt.token_literal.should eq "export"
      end
    end
  end
end
