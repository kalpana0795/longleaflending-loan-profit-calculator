class LoanProfitsController < ApplicationController
  def calculate
    results = ProfitCalculator.call(loan_params)

    @estimated_profit = results[:estimated_profit].round(2)
    @return_rate = results[:return_rate].round(2)

    GenerateAndEmailTermsheetJob.perform_later(loan_params, user_params, results)

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  private

  def loan_params
    params.permit(:target_property, :loan_term, :purchase_price, :repair_budget, :after_repair_value)
  end

  def user_params
    params.permit(:name, :email, :phone)
  end
end
