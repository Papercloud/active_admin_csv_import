require 'spec_helper'

describe Admin::StoresController do

  let(:controller) { Admin::StoresController.new }

  describe "import row" do
    it "should save a row of imported data" do

      lambda {
          post :import_row, { store: {name: "bob"}}
      }.should change{Store.count}.by(1)
      
    end
  end
end
