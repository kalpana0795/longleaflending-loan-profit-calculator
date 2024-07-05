class LoanProfitsController < ApplicationController
  def calculate
    results = ProfitCalculator.call(loan_params.to_h)

    @estimated_profit = results[:estimated_profit]
    @return_rate = results[:return_rate]
    @user_name = "#{user_params[:first_name]} #{user_params[:last_name]}"

    GenerateAndEmailTermsheetJob.perform_later(loan_params.to_h, user_params.to_h, results)

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
    params.permit(:first_name, :last_name, :email, :phone)
  end
end
