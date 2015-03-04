require 'rails_helper'

RSpec.describe Array, "#single" do
  subject{ array.single }

  context "when the array is empty" do
    let(:array){ [] }
    it{ should be_nil }
  end

  context "when the has a single element" do
    let(:array){ [1] }
    it{ should eq(1) }
  end
  context "when the has a multiple elements" do
    let(:array){ [1,2,3] }
    it{ should be_nil }
  end
end