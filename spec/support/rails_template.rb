# Rails template to build the sample app for specs

generate :model, 'store name:string unique_key:string'

# Configure default_url_options in test environment
inject_into_file "config/environments/test.rb", "  config.action_mailer.default_url_options = { :host => 'example.com' }\n", :after => "config.cache_classes = true\n"

# Add our local Active Admin to the load path
inject_into_file "config/environment.rb", "\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire \"active_admin\"\n", :after => "require File.expand_path('../application', __FILE__)"

run "rm Gemfile"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# we need this routing path, named "logout_path", for testing
route <<-EOS
  devise_scope :user do
    match '/admin/logout' => 'active_admin/devise/sessions#destroy', :as => :logout
  end
EOS

generate :'active_admin:install'

run "rm -r test"
run "rm -r spec"

# Setup a root path for devise
route "root :to => 'admin/dashboard#index'"

rake "db:migrate"
rake "db:test:prepare"
# run "/usr/bin/env RAILS_ENV=cucumber rake db:migrate"

