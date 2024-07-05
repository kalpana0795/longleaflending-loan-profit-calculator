require 'prawn'
require 'prawn/table'

class TermsheetGenerator < ApplicationService
  attr_accessor :loan_params, :user_params, :calculated_values

  def initialize(loan_params, user_params, calculated_values)
    @loan_params = loan_params
    @user_params = user_params
    @calculated_values = calculated_values
  end

  def call
    generate_pdf
  end

  private

  def generate_pdf
    pdf = Prawn::Document.new
    pdf.font "Helvetica"
    
    generate_title(pdf)
    generate_user_details(pdf)
    generate_input_details(pdf)
    generate_calculated_values(pdf)
    generate_terms(pdf)
    generate_footer(pdf)

    save_pdf(pdf)
  end

  def generate_title(pdf)
    pdf.text "Loan Profit Termsheet", size: 24, style: :bold, align: :center
    pdf.move_down 20
  end

  def generate_user_details(pdf)
    pdf.text "User Details", size: 18, style: :bold
    pdf.move_down 10
    user_details.each do |detail|
      pdf.text detail, size: 12
      pdf.move_down 5
    end
    pdf.move_down 20
  end

  def generate_input_details(pdf)
    pdf.text "Input Details", size: 18, style: :bold
    pdf.move_down 10
    pdf.table(input_details_table)
    pdf.move_down 20
  end

  def generate_calculated_values(pdf)
    pdf.text "Estimated Loan Details", size: 18, style: :bold
    pdf.move_down 10
    pdf.table(calculated_values_table)
    pdf.move_down 20
  end

  def generate_terms(pdf)
    pdf.text "Terms", size: 18, style: :bold
    pdf.move_down 10
    pdf.text longleaf_lending_terms
  end

  def generate_footer(pdf)
    pdf.number_pages "<page> of <total>", at: [pdf.bounds.right - 50, 0]
  end

  def user_details
    [
      "Name: #{user_params[:first_name]} #{user_params[:last_name]}",
      "Email: #{user_params[:email]}",
      "Phone: #{user_params[:phone]}"
    ]
  end

  def input_details_table
    [
      ["Target Property", loan_params[:target_property]],
      ["Loan Term (months)", loan_params[:loan_term]],
      ["Purchase Price ($)", loan_params[:purchase_price]],
      ["Repair Budget ($)", loan_params[:repair_budget]],
      ["After Repair Value (ARV) ($)", loan_params[:after_repair_value]],
    ]
  end

  def calculated_values_table
    [
      ["Loan Amount ($)", calculated_values[:loan_amount]],
      ["Interest Expense ($)", calculated_values[:interest_expense]],
      ["Estimated Profit ($)", calculated_values[:estimated_profit]],
      ["Return Rate (%)", calculated_values[:return_rate]]
    ]
  end

  def longleaf_lending_terms
    <<-TEXT
    Longleaf Lending's Terms:
    
    1. The loan amount can only fund up to 90% of the purchase price.
    2. 100% of the rehab budget can be funded
    3. The loan amount cannot exceed 70% of the after repair value (ARV).
    4. Interest Expense is calculated using a 13% annual rate, compounded monthly for the loan term specified.
    
    For more details, please contact us at support@longleaflending.com.
    TEXT
  end

  def save_pdf(pdf)
    filename = Rails.root.join('tmp', 'termsheet.pdf')
    pdf.render_file(filename)
    filename
  end
end
