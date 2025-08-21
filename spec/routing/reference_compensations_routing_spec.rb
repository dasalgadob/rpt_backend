require "rails_helper"

RSpec.describe ReferenceCompensationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/reference_compensations").to route_to("reference_compensations#index")
    end

    it "routes to #show" do
      expect(get: "/reference_compensations/1").to route_to("reference_compensations#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/reference_compensations").to route_to("reference_compensations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/reference_compensations/1").to route_to("reference_compensations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/reference_compensations/1").to route_to("reference_compensations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/reference_compensations/1").to route_to("reference_compensations#destroy", id: "1")
    end
  end
end
