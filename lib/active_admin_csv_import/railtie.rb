class Railtie < ::Rails::Railtie
  initializer "active_admin_csv_import.setup_vendor", :after => "active_admin_csv_import.setup", :group => :all do |app|
    vendor_path = File.expand_path("../../vendor/assets", __FILE__)
    app.config.assets.paths.push(vendor_path.to_s)

    app.config.assets.precompile += %w( active_admin_csv_import/import_csv.js )
  end
end