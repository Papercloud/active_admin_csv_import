# Rails template to build the sample app for specs

# gsub_file 'config/database.yml', /^test:.*\n/, "test: &test\n"

# Generate some test models
# generate :model, "post title:string body:text published_at:datetime author_id:integer category_id:integer starred:boolean"
# inject_into_file 'app/models/post.rb', "  belongs_to :author, :class_name => 'User'\n  belongs_to :category\n  accepts_nested_attributes_for :author\n", :after => "class Post < ActiveRecord::Base\n"

# We'll put this basic delegator in app/models in order to simplify auto-loading.
# copy_file File.expand_path('../templates/post_decorator.rb', __FILE__), "app/models/post_decorator.rb"

# Rails 3.2.3 model generator declare attr_accessible
# inject_into_file 'app/models/post.rb', "  attr_accessible :author\n", :before => "end" if Rails::VERSION::STRING >= '3.2.3'
# generate :model, "user type:string first_name:string last_name:string username:string age:integer"
# inject_into_file 'app/models/user.rb', "  has_many :posts, :foreign_key => 'author_id'\n", :after => "class User < ActiveRecord::Base\n"
# generate :model, "publisher --migration=false --parent=User"
# generate :model, 'category name:string description:text'
# inject_into_file 'app/models/category.rb', "  has_many :posts\n  accepts_nested_attributes_for :posts\n", :after => "class Category < ActiveRecord::Base\n"
generate :model, 'store name:string'

# Configure default_url_options in test environment
inject_into_file "config/environments/test.rb", "  config.action_mailer.default_url_options = { :host => 'example.com' }\n", :after => "config.cache_classes = true\n"

# Add our local Active Admin to the load path
inject_into_file "config/environment.rb", "\n$LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire \"active_admin\"\n", :after => "require File.expand_path('../application', __FILE__)"

# Add some translations
# append_file "config/locales/en.yml", File.read(File.expand_path('../templates/en.yml', __FILE__))

# Add predefined admin resources
directory File.expand_path('../templates/admin', __FILE__), "app/admin"

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

