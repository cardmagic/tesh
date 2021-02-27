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
    @value : Identifier
    @name : Identifier

    def initialize(@token)
      # placeholder name and value
      @name = Identifier.new(Token.new(Token::ILLEGAL, ""), "")
      @value = Identifier.new(Token.new(Token::ILLEGAL, ""), "")
    end

    def name=(@name)
    end

    def value=(@value)
    end

    def token
      @token
    end

    def token_literal
      @token.literal
    end

    def name
      @name.token.literal
    end

    def value
      @value.token.literal
    end

    def to_s
      ""
    end
  end

  class ExportStatement < Statement
    def to_s
      "#{token_literal} #{name} = #{value};"
    end
  end

  class ReturnStatement < Statement
    def to_s
      "#{token_literal} #{value};"
    end
  end

  class ExpressionStatement < Statement
    def expression=(@expression)
    end

    def expression
      @expression
    end
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

    def to_s
      statements.map do |stmt|
        stmt.to_s
      end.join(" ")
    end
  end
end
