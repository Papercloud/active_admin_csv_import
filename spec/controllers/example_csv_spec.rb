require 'spec_helper'

add_store_admin

describe Admin::StoresController do

  let(:controller) { Admin::StoresController.new }

  describe "example csv" do
    it "should contain all columns" do
      get :example_csv
      response.body.should eq "Name,Unique key,Location\n"
    end
  end

end
