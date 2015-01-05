require 'spec_helper'

add_store_admin

describe Admin::StoresController, type: :controller do

  let(:controller) { Admin::StoresController.new }

  describe "import row" do
    it "saves a row of imported data" do

      expect {
          post :import_rows, { store: { 0 => {name: "bob"}}}
      }.to change{Store.count}.by(1)

    end
  end

  describe "import an updated row" do

    it "does not create a new row" do

      store = Store.new({name: "bob", unique_key: 123})
      expect(Store).to receive(:find_by_unique_key).and_return(store)

      expect(store).to receive(:save)

      post :import_rows, {
        store: {
          0 => {
          name: "Bobby",
          unique_key: '123'
        }}
      }

      expect(store.name).to eq 'Bobby'
    end

  end
end
