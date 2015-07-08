module Makasi
  class AsariClient
    def add_item(id, fields)
      asari.add_item(hash(id), fields)
    end

    def remove_item(id)
      asari.remove_item(hash(id))
    end

    def search(query, params={})
      asari.search(query, params)
    end

    def search_resource_ids(query, resource_type)
      results = search(query, filter: {and: {resource_type: resource_type}})
      results.map{ |id, r| r["resource_id"]}
    end

    def remove_all
      loop do
        items = search("lolzcat|-lolzcat")
        break if items.empty?
        items.each do |id, item|
          asari.remove_item(id)
          Rails.logger.debug "Makasi::AsariClient: item ##{id} has been removed"
        end
      end
    end

    private

    def hash(str)
      Digest::MD5.hexdigest(str)
    end

    def asari
      asari = Asari.new(Makasi::Config.cloudsearch_index)
      asari.api_version = Makasi::Config.cloudsearch_api_version
      asari.aws_region  = Makasi::Config.cloudsearch_aws_region
      Asari.mode = :production
      asari
    end
  end
end
