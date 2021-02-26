require "./token"

module Tesh
  class Node
    def initialize(@token)
    end

    def token_literal
    end
  end

  class Statement
    def initialize(@node)
    end

    def statement_node
    end
  end

  class Expression
    def initialize(@node)
    end

    def expression_node
    end
  end

  class Program
    def initialize(@statements)
    end
  end
end
