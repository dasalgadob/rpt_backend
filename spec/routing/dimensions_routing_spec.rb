require "rails_helper"

RSpec.describe DimensionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/dimensions").to route_to("dimensions#index")
    end

    it "routes to #show" do
      expect(get: "/dimensions/1").to route_to("dimensions#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/dimensions").to route_to("dimensions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/dimensions/1").to route_to("dimensions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/dimensions/1").to route_to("dimensions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/dimensions/1").to route_to("dimensions#destroy", id: "1")
    end
  end
end
