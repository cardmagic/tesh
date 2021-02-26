ENV["NON_INTERACTIVE"] ||= "1"

require "spec"
require "../src/tesh"

def parse(string)
  Tesh::Parser.new.parse(string)
end
