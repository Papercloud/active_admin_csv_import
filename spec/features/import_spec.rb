require 'spec_helper'

describe 'import', :type => :feature, :js => true do

  before :each do
    @store = Store.new
    allow(Store).to receive(:new).and_return(@store)
  end

  it "imports a valid CSV" do
    add_store_admin
    expect_any_instance_of(Admin::StoresController).to receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123'
                            })

    visit import_csv_admin_stores_path

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/basic.csv'))
    expect(page).to have_content "Done"
  end

  it "alerts missing required fields" do
    add_store_admin
    expect_any_instance_of(Admin::StoresController).to_not receive(:update_row_resource)
    visit import_csv_admin_stores_path
    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/missing_required.csv'))
  end

  it "sends optional fields" do
    add_store_admin
    expect_any_instance_of(Admin::StoresController).to receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123',
                            'location' => 'Melbourne'
                            })

    visit import_csv_admin_stores_path

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/optional.csv'))
    expect(page).to have_content "Done"
  end

  it "sends a CSV separated by semicolons" do
    add_store_admin(delimiter: ";")
    expect_any_instance_of(Admin::StoresController).to receive(:update_row_resource).
                            with(
                            @store,
                            {
                            'name' => 'Terry',
                            'unique_key' => '123'
                            })

    visit import_csv_admin_stores_path

    attach_file('csv-file-input', File.expand_path('./spec/fixtures/csvs/separated_by_semicolon.csv'))
    expect(page).to have_content "Done"
  end

end
