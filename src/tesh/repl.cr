require "readline"

module Tesh
  class REPL
    PROMPT = ">> "

    def initialize
      data = ""
      while data != "exit"
        data = Readline.readline(PROMPT)

        line = Lexer.new(data.to_s)

        while (tok = line.next_token) && tok.type != Token::EOF
          puts tok.data
        end
      end
    end
  end
end
