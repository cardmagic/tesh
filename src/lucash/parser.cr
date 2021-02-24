module Lucash
  class ParseError < Exception; end

  class Parser
    def parse(string)
      raise ParseError.new("Nothing works yet")
    end
  end
end
