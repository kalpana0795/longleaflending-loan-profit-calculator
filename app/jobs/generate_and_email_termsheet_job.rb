class GenerateAndEmailTermsheetJob < ApplicationJob
  queue_as :default

  def perform(loan_params, user_params, result)
    pdf_generator = TermsheetGenerator.new(loan_params, user_params, result)
    pdf_generator.call

    user_name = "#{user_params[:first_name]} #{user_params[:last_name]}"

    TermsheetMailer.email(user_name, user_params[:email], 'termsheet.pdf').deliver_now
  end
end
