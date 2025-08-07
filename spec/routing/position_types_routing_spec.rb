require "rails_helper"

RSpec.describe PositionTypesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/position_types").to route_to("position_types#index")
    end

    it "routes to #show" do
      expect(get: "/position_types/1").to route_to("position_types#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/position_types").to route_to("position_types#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/position_types/1").to route_to("position_types#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/position_types/1").to route_to("position_types#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/position_types/1").to route_to("position_types#destroy", id: "1")
    end
  end
end
