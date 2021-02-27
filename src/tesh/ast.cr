require "./token"

module Tesh
  class Node
    @token : Token

    def initialize(@token)
    end

    def token_literal
    end
  end

  class Expression
    @node : Node

    def initialize(@node)
    end

    def node
      @node
    end
  end

  class Statement
    @token : Token
    @name : Int32 | Identifier

    def initialize(@token)
      @name = 0
    end

    def name=(@name)
    end

    def token
      @token
    end

    def token_literal
      @token.literal
    end
  end

  class ExportStatement < Statement
  end

  class ReturnStatement < Statement
  end

  class Identifier
    @token : Token
    @value : Int32 | String

    def initialize(@token, @value)
    end

    def token
      @token
    end

    def value
      @value
    end

    def expression_node
    end

    def token_literal
      @token.literal
    end
  end

  class Program
    def initialize(@statements = [] of Statement)
    end

    def statements
      @statements
    end

    def <<(stmt)
      @statements << stmt
    end
  end
end
