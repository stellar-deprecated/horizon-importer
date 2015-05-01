require "rails_helper"

RSpec.describe TotalOrderId, ".make", type: :model do
  
  it "accomodates 12-bits of precision for the operation" do
    expect(TotalOrderId.make(0,0,1)).to eq(1)
    expect(TotalOrderId.make(0,0,4095)).to eq(4095)
    expect{TotalOrderId.make(0,0,4096)}.to raise_error(ArgumentError)
  end

  it "accomodates 20-bits of precision for the transaction" do
    expect(TotalOrderId.make(0,1,0)).to eq(4096)
    expect(TotalOrderId.make(0,1048575,0)).to eq(4294963200)
    expect{TotalOrderId.make(0,0,1048576)}.to raise_error(ArgumentError)
  end

  it "accomodates 32-bits of precision for the transaction" do
    expect(TotalOrderId.make(0,0,0)).to eq(0)
    expect(TotalOrderId.make(1,0,0)).to eq(4294967296)

    expect(TotalOrderId.make(2**32-1,0,0)).to eq(18446744069414584320)
    expect{TotalOrderId.make(2**32,0,0)}.to raise_error(ArgumentError)
  end

  it "works" do

    expect(TotalOrderId.make(1,0,1)).to eq(4294967296 + 0 + 1)
    expect(TotalOrderId.make(1,1,1)).to eq(4294967296 + 4096 + 1)
    expect(TotalOrderId.make(0,1,1)).to eq(0 + 4096 + 1)

  end
end
