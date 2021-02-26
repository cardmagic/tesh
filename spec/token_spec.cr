require "./spec_helper"

describe Tesh::Token do
  it "works for illegal" do
    Tesh::Token::ILLEGAL.should eq("ILLEGAL")
  end
end
