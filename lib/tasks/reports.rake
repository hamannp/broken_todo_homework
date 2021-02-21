namespace :todo do
  namespace :reports do
    desc 'Generate a CSV report of completed Items'
    task :csv => :environment do
      CompletedItemsCsvExporter.new.export!
    end

    desc 'Print a report to STDOUT'
    task :print => :environment do
      ProjectItemsReporter.new.call
    end
  end
end
