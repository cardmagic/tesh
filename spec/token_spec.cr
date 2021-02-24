require "./spec_helper"

describe Lucash::Token do
  it "works for illegal" do
    Lucash::Token::ILLEGAL.should eq("ILLEGAL")
  end
end
