require 'rails_helper'

RSpec.describe ProblemRenderer, ".render" do
  subject{ ProblemRenderer }

  context "when providing a symbol" do
    context "and the symbol is a member of COMMON_PROBLEMS" do
      it "should render with the correct status code"
      it "should render with the correct body"
    end

    context "and the symbol is a _not_ member of COMMON_PROBLEMS" do
      it "should render a 500 status code"
      it "should render the internal_server_error body"
    end
  end

  context "when providing a hash" do
    it "should render with the correct status code"
    it "should render with the correct body"
  end

  context "when providing an exception" do
    it "should render a 500 status code"
    it "should render the internal_server_error body"
  end

  context "when providing an object that responds to #to_problem" do
    it "should render with the correct status code"
    it "should render with the correct body"
  end

end