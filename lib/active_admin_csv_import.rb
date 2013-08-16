require "active_admin_csv_import/engine"
require "active_admin_csv_import/dsl"
require 'activeadmin'

module ActiveAdminCsvImport
end

::ActiveAdmin::DSL.send(:include, ActiveAdminCsvImport::DSL)