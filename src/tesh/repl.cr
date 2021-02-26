module Tesh
  class REPL
    PROMPT = ">> "

    def initialize
      data = ""
      while data != "exit"
        print PROMPT
        data = gets.to_s.chomp

        line = Lexer.new(data)

        while (tok = line.next_token) && tok.type != Token::EOF
          puts tok.data
        end
      end
    end
  end
end
