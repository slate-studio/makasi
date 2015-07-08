namespace :makasi do
  desc "Refresh sitemap and update indices on Amazon CloudSearch"
  task :search_reindex => [:environment, "sitemap:refresh"] do
    Makasi::SearchIndex.new.reindex
  end

  desc "Delete all indices from Amazon CloudSearch and cleanup CloudSearchDocument model"
  task :search_truncate_index => :environment do
    Makasi::AsariClient.new.remove_all
    CloudSearchDocument.delete_all
  end
end
