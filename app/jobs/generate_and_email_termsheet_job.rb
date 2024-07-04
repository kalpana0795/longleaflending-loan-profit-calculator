class GenerateAndEmailTermsheetJob < ApplicationJob
  queue_as :default

  def perform(loan_params, user_params, result)
    pdf_generator = TermsheetGenerator.new(loan_params, user_params, result)
    pdf_generator.call

    TermsheetMailer.email(user_params[:name], user_params[:email], 'termsheet.pdf').deliver_now
  end
end
