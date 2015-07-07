namespace :makasi do
  task :search_reindex => [:environment, "sitemap:refresh"] do
    Makasi::SearchIndex.new.reindex
  end

  task :search_truncate_index => :environment do
    Makasi::AsariClient.new.remove_all
    CloudSearchDocument.delete_all
  end
end
