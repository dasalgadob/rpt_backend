require "rails_helper"

RSpec.describe ProfitReferencesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/profit_references").to route_to("profit_references#index")
    end

    it "routes to #show" do
      expect(get: "/profit_references/1").to route_to("profit_references#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/profit_references").to route_to("profit_references#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/profit_references/1").to route_to("profit_references#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/profit_references/1").to route_to("profit_references#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/profit_references/1").to route_to("profit_references#destroy", id: "1")
    end
  end
end
