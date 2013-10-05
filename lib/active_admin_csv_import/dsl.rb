module ActiveAdminCsvImport
  module DSL

    def csv_importable(options={})

      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'import_csv'
      end

      # Shows the form and JS which accepts a CSV file, parses it and posts each row to the server.
      collection_action :import_csv do
        @columns           = options[:columns] ||= active_admin_config.resource_class.columns.map(&:name) - ["id", "updated_at", "created_at"]
        @required_columns  = options[:required_columns] ||= @columns

        @post_path  = options[:path].try(:call)
        @post_path ||= collection_path + "/import_rows"

        @redirect_path = options[:redirect_path].try(:call)
        @redirect_path ||= collection_path

        render "admin/csv/import_csv"
      end

      # Receives each row and saves it
      collection_action :import_rows, :method => :post do

        @failures = []

        resource_params.values.each do |row_params|
          row_params = row_params.with_indifferent_access
          row_number = row_params.delete('_row')
  
          resource = existing_row_resource(options[:import_unique_key], row_params)
          resource ||= active_admin_config.resource_class.new()

          if not update_row_resource(resource, row_params)
            @failures << {
              row_number: row_number,
              resource: resource
            }
          end
        end

        render :partial => "admin/csv/import_csv_failed_row", :status => 200
      end

      # Rails 4 Strong Parameters compatibility and backwards compatibility.
      controller do
        def resource_params
          # I don't think this will work any more.
          if respond_to?(:permitted_params)
            permitted_params
          else
            params[active_admin_config.resource_class.name.pluralize.underscore]
          end
        end

        # Updates a resource with the CSV data and saves it.
        #
        # @param resource [Object] the object to save
        # @param params [Hash] the CSV row
        # @return [Boolean] Success
        def update_row_resource(resource, params)
          resource.attributes = params
          resource.save
        end

        def existing_row_resource(lookup_column, params)
          return unless lookup_column

          finder_method = "find_by_#{lookup_column}".to_sym
          value = params[lookup_column]
          return active_admin_config.resource_class.send(finder_method, value)
        end
      end

    end

  end
end
