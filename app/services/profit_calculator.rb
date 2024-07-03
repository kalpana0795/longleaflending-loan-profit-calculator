class ProfitCalculator < ApplicationService
  attr_accessor :purchase_price, :repair_budget, :after_repair_value, :loan_term

  def initialize(loan_params)
    @purchase_price = loan_params[:purchase_price].to_f
    @repair_budget = loan_params[:repair_budget].to_f
    @after_repair_value = loan_params[:after_repair_value].to_f
    @loan_term = loan_params[:loan_term].to_i
  end

  def call
    max_loan_by_purchase_price = 0.9 * purchase_price
    max_loan_by_arv = 0.7 * after_repair_value

    max_fundable_amount = [max_loan_by_purchase_price + repair_budget, max_loan_by_arv].min

    monthly_interest_rate = 0.13 / 12
    total_interest_expense = max_fundable_amount * (1 + monthly_interest_rate) ** loan_term - max_fundable_amount

    estimated_profit = after_repair_value - max_fundable_amount - total_interest_expense

    total_investment = purchase_price + repair_budget + total_interest_expense
    return_rate = (estimated_profit / total_investment) * 100

    {
      estimated_profit: estimated_profit,
      return_rate: return_rate
    }
  end
end
