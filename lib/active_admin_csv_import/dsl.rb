module ActiveAdminCsvImport
  module DSL

    def csv_importable
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'import_csv'
      end

      collection_action :import_csv do
        @fields = active_admin_config.resource_class.columns.map(&:name) - ["id", "updated_at", "created_at"]
        render "admin/csv/import_csv"
      end

      collection_action :create_or_update_batch, :method => :post do
        # Create or update from posted data.
      end
    end

  end
end