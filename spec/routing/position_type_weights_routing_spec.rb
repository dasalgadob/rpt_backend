require "rails_helper"

RSpec.describe PositionTypeWeightsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/position_type_weights").to route_to("position_type_weights#index")
    end

    it "routes to #show" do
      expect(get: "/position_type_weights/1").to route_to("position_type_weights#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/position_type_weights").to route_to("position_type_weights#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/position_type_weights/1").to route_to("position_type_weights#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/position_type_weights/1").to route_to("position_type_weights#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/position_type_weights/1").to route_to("position_type_weights#destroy", id: "1")
    end
  end
end
