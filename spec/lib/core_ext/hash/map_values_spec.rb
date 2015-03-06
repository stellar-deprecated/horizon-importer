require 'rails_helper'

RSpec.describe Hash, "#map_values" do
  subject{ {1 => "1", 2 => "2", 3 => "3"} }

  it "yields each value in the hash" do
    expect{|b| subject.map_values(&b) }.to yield_successive_args(*[
      ["1", 1], 
      ["2", 2], 
      ["3", 3],
    ])
  end

  it "returns a hash that is the where each map result is used for the new value" do
    expect(subject.map_values{|v| v * 2}).to eq({
      1 => "11",
      2 => "22",
      3 => "33",
    })
  end
end