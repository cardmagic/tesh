module Tesh
  class Token
    @type : String
    @literal : String | Int32

    ILLEGAL = "ILLEGAL"
    EOF     = "EOF"

    # Identifiers + Literals
    IDENT = "IDENT"
    INT   = "INT"

    # Operators
    EQ       = "=="
    NOT_EQ   = "!="
    ASSIGN   = "="
    PLUS     = "+"
    MINUS    = "-"
    BANG     = "!"
    ASTERISK = "*"
    SLASH    = "/"

    LT = "<"
    GT = ">"

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
    TRUE     = "TRUE"
    FALSE    = "FALSE"
    IF       = "IF"
    ELSE     = "ELSE"
    RETURN   = "RETURN"

    KEYWORDS = {
      "fn"     => FUNCTION,
      "let"    => LET,
      "true"   => TRUE,
      "false"  => FALSE,
      "if"     => IF,
      "else"   => ELSE,
      "return" => RETURN,
    }

    def data
      [@type, @literal]
    end

    def initialize(@type, @literal)
    end

    def type
      @type
    end

    def literal
      @literal
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
