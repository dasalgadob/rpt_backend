require "rails_helper"

RSpec.describe EmployeeEvaluationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/employee_evaluations").to route_to("employee_evaluations#index")
    end

    it "routes to #show" do
      expect(get: "/employee_evaluations/1").to route_to("employee_evaluations#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/employee_evaluations").to route_to("employee_evaluations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/employee_evaluations/1").to route_to("employee_evaluations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/employee_evaluations/1").to route_to("employee_evaluations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/employee_evaluations/1").to route_to("employee_evaluations#destroy", id: "1")
    end
  end
end
