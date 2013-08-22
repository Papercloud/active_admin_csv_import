module ActiveAdminCsvImport
  module DSL

    def csv_importable(options={})
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'import_csv'
      end

      # Shows the form and JS which accepts a CSV file, parses it and posts each row to the server.
      collection_action :import_csv do
        @fields     = options[:columns] ||= active_admin_config.resource_class.columns.map(&:name) - ["id", "updated_at", "created_at"]

        @post_path  = options[:path].try(:call)
        @post_path ||= collection_path + "/import_row"

        @redirect_path = options[:redirect_path].try(:call)
        @redirect_path ||= collection_path

        render "admin/csv/import_csv"
      end

      # Receives each row and saves it
      collection_action :import_row, :method => :post do
        @resource = active_admin_config.resource_class.new(params[active_admin_config.resource_class.name.underscore])
        @row_number = params["row"]

        if @resource.save
          render :nothing => true, :status => 201
        else
          render :partial => "admin/csv/import_csv_failed_row", :status => 422
        end
      end

    end

  end
end