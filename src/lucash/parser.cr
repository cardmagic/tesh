require "./ast"
require "./lexer"
require "./token"

module Lucash
  class ParseError < Exception; end

  class Parser
    def initialize(@lexer)
      # Read two token, so @cur_token and @peek_token are both set
      next_token
      next_token
    end

    def next_token
      @cur_token = @peek_token
      @peek_token = @lexer.next_token
    end

    def parse_program
    end

    def parse(string)
      raise ParseError.new("Nothing works yet")
    end
  end
end
