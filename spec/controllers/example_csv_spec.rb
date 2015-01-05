require 'spec_helper'

add_store_admin

describe Admin::StoresController, type: :controller do

  let(:controller) { Admin::StoresController.new }

  describe "example csv" do
    it "contains all columns" do
      get :example_csv
      expect(response.body).to eq "Name,Unique key,Location\n"
    end
  end

end
