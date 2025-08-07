require "rails_helper"

RSpec.describe CorporativeGoalsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/corporative_goals").to route_to("corporative_goals#index")
    end

    it "routes to #show" do
      expect(get: "/corporative_goals/1").to route_to("corporative_goals#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/corporative_goals").to route_to("corporative_goals#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/corporative_goals/1").to route_to("corporative_goals#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/corporative_goals/1").to route_to("corporative_goals#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/corporative_goals/1").to route_to("corporative_goals#destroy", id: "1")
    end
  end
end
