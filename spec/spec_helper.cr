ENV["NON_INTERACTIVE"] ||= "1"

require "spec"
require "../src/lucash"

def parse(string)
  Lucash::Parser.new.parse(string)
end
