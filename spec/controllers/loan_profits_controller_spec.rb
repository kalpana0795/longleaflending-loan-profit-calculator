require 'rails_helper'

RSpec.describe LoanProfitsController, type: :controller do
  describe "POST #calculate" do
    let(:loan_params) do
      {
        target_property: "123 Main St",
        loan_term: "30 years",
        purchase_price: "250000",
        repair_budget: "10000",
        after_repair_value: "300000"
      }
    end

    let(:user_params) do
      {
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        phone: "123-456-7890"
      }
    end

    let(:results) do
      {
        estimated_profit: 50000.55,
        return_rate: 12.5
      }
    end

    before do
      allow(ProfitCalculator).to receive(:call).with(loan_params).and_return(results)
      allow(GenerateAndEmailTermsheetJob).to receive(:perform_later)
    end

    context "when request format is turbo_stream" do
      it "assigns @estimated_profit, @return_rate, and @user_name" do
        post :calculate, params: loan_params.merge(user_params), format: :turbo_stream
        expect(assigns(:estimated_profit)).to eq(50000.55)
        expect(assigns(:return_rate)).to eq(12.5)
        expect(assigns(:user_name)).to eq("John Doe")
      end

      it "enqueues GenerateAndEmailTermsheetJob" do
        expect(GenerateAndEmailTermsheetJob).to receive(:perform_later).with(loan_params, user_params, results)
        post :calculate, params: loan_params.merge(user_params), format: :turbo_stream
      end

      it "responds with turbo_stream format" do
        post :calculate, params: loan_params.merge(user_params), format: :turbo_stream
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/vnd.turbo-stream.html; charset=utf-8")
      end
    end

    context "when request format is html" do
      it "assigns @estimated_profit, @return_rate, and @user_name" do
        post :calculate, params: loan_params.merge(user_params), format: :html
        expect(assigns(:estimated_profit)).to eq(50000.55)
        expect(assigns(:return_rate)).to eq(12.5)
        expect(assigns(:user_name)).to eq("John Doe")
      end

      it "enqueues GenerateAndEmailTermsheetJob" do
        expect(GenerateAndEmailTermsheetJob).to receive(:perform_later).with(loan_params, user_params, results)
        post :calculate, params: loan_params.merge(user_params), format: :html
      end

      it "responds with html format" do
        post :calculate, params: loan_params.merge(user_params), format: :html
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/html; charset=utf-8")
      end
    end
  end
end
