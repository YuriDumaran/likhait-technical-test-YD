require 'rails_helper'

RSpec.describe "Api::Categories", type: :request do
  describe "GET /api/categories" do
    before(:each) { Category.delete_all }

    let!(:food) { Category.create!(name: "Food") }
    let!(:transport) { Category.create!(name: "Transport") }
    let!(:supplies) { Category.create!(name: "Supplies") }

    it "returns all categories" do
      get "/api/categories"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq(3)
      expect(json.map { |c| c["name"] }).to include("Food", "Transport", "Supplies")
    end

    it "returns categories in alphabetical order" do
      get "/api/categories"

      json = JSON.parse(response.body)
        expect(json.map { |c| c["name"] }).to eq([ "Food", "Supplies", "Transport" ])
    end
  end

  describe "POST /api/categories" do
    context "with valid parameters" do
      it "creates a new category" do
        expect {
          post "/api/categories", params: { category: { name: "Utilities" } }, as: :json
        }.to change(Category, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["name"]).to eq("Utilities")
      end

      it "returns existing categories in alphabetical order after creation" do
        post "/api/categories", params: { category: { name: "A" } }, as: :json
        get "/api/categories"
        json = JSON.parse(response.body)
        expect(json.first["name"]).to eq("A")
      end
    end

    context "with invalid parameters" do
      it "rejects empty name" do
        expect {
          post "/api/categories", params: { category: { name: "" } }, as: :json
        }.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "rejects duplicate names (case insensitive)" do
        Category.create!(name: "Health")
        expect {
          post "/api/categories", params: { category: { name: "health" } }, as: :json
        }.not_to change(Category, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
