require 'rails_helper'

RSpec.describe GenerateAndEmailTermsheetJob, type: :job do
  describe "#perform" do
    let(:loan_params) {
      {
        target_property: "123 Main St",
        loan_term: 12,
        purchase_price: 100000,
        repair_budget: 5000,
        after_repair_value: 120000
      }
    }
    let(:user_params) {
      {
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        phone: "123-456-7890"
      }
    }
    let(:result) {
      {
        loan_amount: 95000,
        interest_expense: 7500,
        estimated_profit: 15000,
        return_rate: 10
      }
    }

    it "generates and emails termsheet PDF" do
      # Mock TermsheetGenerator to return a dummy filename
      allow_any_instance_of(TermsheetGenerator).to receive(:call).and_return("termsheet.pdf")

      # Expect TermsheetMailer to receive the email method with correct arguments
      expect(TermsheetMailer).to receive(:email).with("John Doe", "john.doe@example.com", "termsheet.pdf").and_return(double(deliver_now: true))

      # Perform the job
      GenerateAndEmailTermsheetJob.perform_now(loan_params, user_params, result)
    end
  end
end
