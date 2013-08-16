//= require backbone/json2
//= require backbone/underscore
//= require backbone/backbone
//= require recline/backend.csv.js
//= require recline/backend.memory.js
//= require recline/model
//= require underscore.string.min.js
//= require_self

// Mix in underscore.string.js methods into underscore.js
_.mixin(_.str.exports());


$(document).ready(function() {
  // the file input
  var $file = $('#csv-file-input')[0];

  var clearFileInput = function() {
    // Reset input so .change will be triggered if we load the same file again.
    $($file).wrap('<form>').closest('form').get(0).reset();
    $($file).unwrap();

    var progress = $("#csv-import-progress");
    progress.text("");
  };

  // listen for the file to be submitted
  $($file).change(function(e) {

    var progress = $("#csv-import-progress");
    progress.text("Loading...");

    // create the dataset in the usual way but specifying file attribute
    var dataset = new recline.Model.Dataset({
      file: $file.files[0],
      backend: 'csv'
    });

    dataset.fetch().done(function(data) {

      if (!data.recordCount) {
        alert("No records found. Please save as 'Windows Comma Separated' from Excel (2nd CSV option).");
        clearFileInput();
        return;
      }

      // Re-query to get all records. Otherwise recline.js defaults to just 100.
      dataset.query({size: dataset.recordCount});

      // Check whether the CSV's columns match up with our data model.
      // import_csv_fields is passed in from Rails in import_csv.html.erb
      var wanted_columns = import_csv_fields;
      var csv_columns = _.pluck(data.records.first().fields.models, "id");
      var normalised_csv_columns = _.map(csv_columns, function(name) {
        return _.underscored(name);
      });

      // Check we have all the columns we want.
      var missing_columns = _.difference(wanted_columns, normalised_csv_columns);
      var missing_columns_humanized = _.map(missing_columns, function(name) {
        return _.humanize(name);
      });

      if (missing_columns.length > 0) {
        alert("The following columns are missing: " + _.toSentence(missing_columns_humanized) + ". Please check your column names.");
      } else {
        // Import!

        var total = data.recordCount;
        var loaded = 0;
        var succeeded = 0;
        var i = 0;

        _.each(data.records.models, function(record) {

          // Add a gap between each post to give the server
          // room to breathe
          setTimeout(function () {

            // Filter only the attributes we want, and normalise column names.
            var record_data = {};
            record_data[import_csv_resource_name] = {};

            _.each(_.pairs(record.attributes), function(attr) {
              var underscored_name = _.underscored(attr[0]);
              if (_.contains(wanted_columns, underscored_name)) {
                record_data[import_csv_resource_name][underscored_name] = attr[1];
              }
            });

            $.post(
            import_csv_path,
            record_data,
            function(data) {
              succeeded = succeeded + 1;
            }).always(function() {
              loaded = loaded + 1;
              progress.text("Progress: " + loaded + " of " + total);

              if (loaded == total) {
                progress.html("Done. Imported " + total + " records, " + succeeded + " succeeded.");
                if (redirect_path) {
                  progress.html(progress.text() + " <a href='"+redirect_path +"'>Click to continue.</a>");
                }
              }
            });

          }, 100 * i);

          i++;

        });
      }

      clearFileInput();
    });
  });
});