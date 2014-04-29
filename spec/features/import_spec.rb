require 'spec_helper'

describe 'import', :type => :feature, :js => true do

  before :each do
    @store = Store.new
    Store.stub(:new).and_return(@store)
  end

  it "imports a valid CSV" do
    add_store_admin
    Admin::StoresController.any_instance.should_receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123'
                            })

    visit import_csv_admin_stores_path

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/basic.csv'))
    page.should have_content "Done"
  end

  it "alerts missing required fields" do
    add_store_admin
    Admin::StoresController.any_instance.should_not_receive(:update_row_resource)
    visit import_csv_admin_stores_path
    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/missing_required.csv'))
  end

  it "sends optional fields" do
    add_store_admin
    Admin::StoresController.any_instance.should_receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123',
                            'location' => 'Melbourne'
                            })

    visit import_csv_admin_stores_path

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/optional.csv'))
    page.should have_content "Done"
  end

  it "sends a CSV separated by semicolons" do
    add_store_admin(delimiter: ";")
    Admin::StoresController.any_instance.should_receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123'
                            })

    visit import_csv_admin_stores_path

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/separated_by_semicolon.csv'))
    page.should have_content "Done"
  end

  it "sets default columns if none are specified" do
    ActiveAdmin.register Store do
      csv_importable
    end
    Rails.application.reload_routes!
    
    visit import_csv_admin_stores_path
    page.should have_content "Name"
    page.should have_content "Unique key"
  end

end
