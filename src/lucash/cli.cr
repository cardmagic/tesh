module Lucash
  class CLI
    def initialize
      puts "Hello, This is the Lucash shell!"
      puts "Feel free to type in commands"
      puts
      REPL.new
    end
  end
end
