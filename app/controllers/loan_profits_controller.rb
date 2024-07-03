class LoanProfitsController < ApplicationController
  def calculate
    @profit = 0

    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end
end
