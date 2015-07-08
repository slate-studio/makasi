# Allow the new api syntax of version 2013-01-01

class Asari
  class Collection
    def initialize(httparty_response, page_size)
      resp = httparty_response.parsed_response
      @total_entries = resp["hits"]["found"]
      @page_size = page_size

      complete_pages = (@total_entries / @page_size)
      @total_pages = (@total_entries % @page_size > 0) ? complete_pages + 1 : complete_pages
      # There's always one page, even for no results
      @total_pages = 1 if @total_pages == 0

      start = resp["hits"]["start"]
      @current_page = (start / page_size) + 1
      if resp["hits"]["hit"].first && resp["hits"]["hit"].first["fields"]
        @data = {}
        resp["hits"]["hit"].each { |hit|  @data[hit["id"]] = hit["fields"]}
      else
        @data = resp["hits"]["hit"].map { |hit| hit["id"] }
      end
    end
  end

  def search(term, options = {})
    return Asari::Collection.sandbox_fake if self.class.mode == :sandbox
    term,options = "",term if term.is_a?(Hash) and options.empty?

    if options[:filter]
      bq = boolean_query(options[:filter])
      bq = "(and '#{term.to_s.gsub("'", " ")}' #{bq})" if term.present?
    end
    page_size = options[:page_size].nil? ? 10 : options[:page_size].to_i

    url = "http://search-#{search_domain}.#{aws_region}.cloudsearch.amazonaws.com/#{api_version}/search"
    if options[:filter]
      url += "?q.parser=structured&q=#{CGI.escape(bq)}"
    else
      url += "?q=#{CGI.escape(term.to_s)}"
    end
    url += "&size=#{page_size}"
    url += "&return-fields=#{options[:return_fields].join ','}" if options[:return_fields]

    if options[:page]
      start = (options[:page].to_i - 1) * page_size
      url << "&start=#{start}"
    end

    if options[:rank]
      rank = normalize_rank(options[:rank])
      url << "&rank=#{rank}"
    end

    begin
      response = HTTParty.get(url)
    rescue Exception => e
      ae = Asari::SearchException.new("#{e.class}: #{e.message} (#{url})")
      ae.set_backtrace e.backtrace
      raise ae
    end

    unless response.response.code == "200"
      raise Asari::SearchException.new("#{response.response.code}: #{response.response.msg} (#{url})")
    end

    Asari::Collection.new(response, page_size)
  end
end
