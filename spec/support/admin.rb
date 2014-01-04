def add_store_admin(options = {})
  options.merge!({ import_unique_key: :unique_key,
                   required_columns: [:name, :unique_key],
                   columns: [:name, :unique_key, :location] })

  ActiveAdmin.register Store do
    csv_importable options
  end
  Rails.application.reload_routes!
end

