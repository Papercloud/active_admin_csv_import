require 'spec_helper'

ActiveAdmin.register Store do
  csv_importable import_unique_key: :unique_key,
                  required_columns: [:name, :unique_key],
                  columns: [:name, :unique_key, :location]
end
Rails.application.reload_routes!

describe Admin::StoresController do

  let(:controller) { Admin::StoresController.new }

  describe "import row" do
    it "should save a row of imported data" do

      lambda {
          post :import_rows, { stores: { 0 => {name: "bob"}}}
      }.should change{Store.count}.by(1)
      
    end
  end

  describe "import an updated row" do

    it "should not create a new row" do

      store = Store.new({name: "bob", unique_key: 123})
      Store.should_receive(:find_by_unique_key).and_return(store)

      store.should_receive(:save)

      post :import_rows, {
        stores: {
          0 => {
          name: "Bobby",
          unique_key: '123'
        }}
      }

      store.name.should eq 'Bobby'
    end
 
  end
end
