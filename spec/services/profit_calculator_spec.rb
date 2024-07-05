require 'rails_helper'

RSpec.describe ProfitCalculator do
  describe "#call" do
    let(:loan_params) do
      {
        purchase_price: 250000,
        repair_budget: 10000,
        after_repair_value: 300000,
        loan_term: 30
      }
    end

    subject(:calculator) { described_class.new(loan_params) }

    it "calculates the maximum fundable amount" do
      results = calculator.call
      expect(results[:loan_amount]).to eq(210000.0)
    end

    it "calculates the total interest expense" do
      results = calculator.call
      expect(results[:interest_expense]).to eq(80138.89)
    end

    it "calculates the estimated profit" do
      results = calculator.call
      expect(results[:estimated_profit]).to eq(9861.11)
    end

    it "calculates the return rate" do
      results = calculator.call
      expect(results[:return_rate]).to eq(2.9)
    end
  end
end
