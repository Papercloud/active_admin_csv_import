ActiveAdminCSVImport
=======================

[![Build Status](https://travis-ci.org/Papercloud/active_admin_csv_import.svg?branch=master)](https://travis-ci.org/Papercloud/active_admin_csv_import)

- Add CSV import with one line of code
- Parses the file client-side and imports line-by-line to avoid Heroku timeouts
- Validates the CSV has the correct column names before importing.

Inspired by https://github.com/krhorst/active_admin_importable and makes use of Recline.js. This is a relatively heavy solution with a lot of JS dependencies, but should be easier for large imports on Heroku than first uploading to a file server.

## Compatibility

As of v2.0.0 Active Admin master with Rails 4.1 is supported. For older versions of Active Admin use v1 of active_admin_csv_import.

## Installation

Add this line to your application's Gemfile:

    gem 'active_admin_csv_import'

And then execute:

    $ bundle

## Usage

Add 'csv_importable' into your active admin resource:

```
ActiveAdmin.register Thing do
  csv_importable :columns => [:code, :name, :state_name],
                              :import_unique_key => :code
end
```

An import button should appear on the resource's index page. All columns are expected other than id, updated_at and created_at.

## Demo

http://active-admin-csv-import.herokuapp.com/admin
```
admin@example.com
password
```
Source: https://github.com/Papercloud/active-admin-csv-import-example

## Use other delimiter than semicolon

In `config/initializers/active_admin.rb`, search `csv_options` and set the csv separator as it's showed in the file.

## Wishlist / TODOS

1. Add Appraisal to test against multiple versions of Rails

## Specs
```
bundle exec rspec spec
```
The test suite is limited, but it's a start.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
