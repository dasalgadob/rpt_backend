require "rails_helper"

RSpec.describe ProfitReferenceHasPositionTypesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/profit_reference_has_position_types").to route_to("profit_reference_has_position_types#index")
    end

    it "routes to #show" do
      expect(get: "/profit_reference_has_position_types/1").to route_to("profit_reference_has_position_types#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/profit_reference_has_position_types").to route_to("profit_reference_has_position_types#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/profit_reference_has_position_types/1").to route_to("profit_reference_has_position_types#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/profit_reference_has_position_types/1").to route_to("profit_reference_has_position_types#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/profit_reference_has_position_types/1").to route_to("profit_reference_has_position_types#destroy", id: "1")
    end
  end
end
