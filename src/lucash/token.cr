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

    KEYWORDS = {
      "fn"  => FUNCTION,
      "let" => LET,
    }

    def data
      [@type, @literal]
    end

    def initialize(@type, @literal)
    end

    def self.lookup_ident(ident)
      if KEYWORDS.has_key?(ident)
        KEYWORDS[ident]
      else
        IDENT
      end
    end
  end
end
