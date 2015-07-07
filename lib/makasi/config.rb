module Makasi
  class Config
    def self.rails_config
      Rails.configuration.x.makasi
    end

    def self.setup
      yield(rails_config)
    end

    def self.cloudsearch_index
      rails_config.cloudsearch_index
    end

    def self.sitemap_url
      rails_config.sitemap_url
    end

    def self.website_url
      rails_config.website_url
    end

    def self.cloudsearch_api_version
      rails_config.cloudsearch_api_version.presence || "2013-01-01"
    end

    def self.cloudsearch_aws_region
      rails_config.cloudsearch_aws_region.presence || "us-east-1"
    end
  end
end
