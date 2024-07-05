require 'rails_helper'

RSpec.describe TermsheetGenerator do
  describe '#call' do
    let(:loan_params) do
      {
        target_property: '123 Main St',
        loan_term: 30,
        purchase_price: 250_000,
        repair_budget: 10_000,
        after_repair_value: 300_000
      }
    end

    let(:user_params) do
      {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john.doe@example.com',
        phone: '123-456-7890'
      }
    end

    let(:calculated_values) do
      {
        loan_amount: 235_000.0,
        interest_expense: 186_083.78,
        estimated_profit: 78_916.22,
        return_rate: 23.99
      }
    end

    let(:generator) { described_class.new(loan_params, user_params, calculated_values) }

    it 'generates a valid PDF' do
      generator = TermsheetGenerator.new(loan_params, user_params, calculated_values)
      filename = generator.call

      expect(File.exist?(filename)).to be_truthy

      pdf = PDF::Reader.new(filename)
      expect(pdf.pages.size).to eq(1)

      File.delete(filename) if File.exist?(filename)
    end

    it 'includes correct user details in the PDF' do
      pdf_text = extract_pdf_text(generator.call)
      expect(pdf_text).to include('Name: John Doe')
      expect(pdf_text).to include('Email: john.doe@example.com')
      expect(pdf_text).to include('Phone: 123-456-7890')
    end

    it 'includes correct input details in the PDF' do
      pdf_text = extract_pdf_text(generator.call)
      expect(pdf_text).to include('Target Property             123 Main St')
      expect(pdf_text).to include('Loan Term (months)          30')
      expect(pdf_text).to include('Purchase Price ($)          250000')
      expect(pdf_text).to include('Repair Budget ($)           10000')
      expect(pdf_text).to include('After Repair Value (ARV) ($) 300000')
    end

    it 'includes correct calculated values in the PDF' do
      pdf_text = extract_pdf_text(generator.call)
      expect(pdf_text).to include('Loan Amount ($)      235000.0')
      expect(pdf_text).to include('Interest Expense ($) 186083.78')
      expect(pdf_text).to include('Estimated Profit ($) 78916.22')
      expect(pdf_text).to include('Return Rate (%)      23.99')
    end

    it 'includes correct terms in the PDF' do
      pdf_text = extract_pdf_text(generator.call)
      expect(pdf_text).to include("Longleaf Lending's Terms:")
      expect(pdf_text).to include('1. The loan amount can only fund up to 90% of the purchase price.')
      expect(pdf_text).to include('2. 100% of the rehab budget can be funded')
      expect(pdf_text).to include('3. The loan amount cannot exceed 70% of the after repair value (ARV).')
      expect(pdf_text).to include('4. Interest Expense is calculated using a 13% annual rate, compounded monthly for the loan term')
    end
  end

  def extract_pdf_text(pdf_path)
    pdf_reader = PDF::Reader.new(pdf_path)
    pdf_text = ''
    pdf_reader.pages.each do |page|
      pdf_text << page.text
    end
    pdf_text
  end
end
