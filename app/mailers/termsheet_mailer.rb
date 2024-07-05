# frozen_string_literal: true

# app/mailers/loan_profit_mailer.rb
class TermsheetMailer < ApplicationMailer
  def email(user_name, user_email, pdf_path)
    @user_name = user_name

    attachments['termsheet.pdf'] = File.read(pdf_path)
    mail(to: user_email, subject: 'Loan Profit Termsheet')
  end
end
