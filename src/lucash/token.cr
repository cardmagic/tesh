module Lucash
  class Token
    @type : String
    @literal : String | Int32

    ILLEGAL = "ILLEGAL"
    EOF     = "EOF"

    # Identifiers + Literals
    IDENT = "IDENT"
    INT   = "INT"

    # Operators
    ASSIGN = "="
    PLUS   = "+"

    # Delimiters
    COMMA     = ","
    SEMICOLON = ";"

    LPAREN = "("
    RPAREN = ")"
    LBRACE = "{"
    RBRACE = "}"

    # Keywords
    FUNCTION = "FUNCTION"
    LET      = "LET"

    def data
      [@type, @literal]
    end

    def initialize(@type, @literal)
    end
  end
end
