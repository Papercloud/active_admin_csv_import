require 'active_admin_csv_import/engine'
require 'active_admin_csv_import/dsl'
require 'active_admin_csv_import/railtie'
require 'active_admin_csv_import/version'
require 'activeadmin'

module ActiveAdminCsvImport
end

::ActiveAdmin::DSL.send(:include, ActiveAdminCsvImport::DSL)
