module Makasi
  class AsariResult
    include ActionView::Helpers

    attr_reader :url

    def initialize(asari_result, query)
      @url = asari_result["url"]
      @asari_result = asari_result
      @query = query
    end

    def highlighted_url
      highlight url
    end

    def title
      highlight @asari_result["resource_name"].to_s
    end

    def snippet
      text = HTMLEntities.new.decode strip_tags(@asari_result["content"].to_s).gsub(/\s+/, ' ')
      highlight truncate(snippet_containing_query(text), length: 130)
    end

    private

    def highlight(text)
      word_regexp = Regexp.new "(#{@query.split.map{|word| Regexp.escape(word)}.join("|")})", true
      text.gsub(word_regexp, "<span class='highlighted'>\\1</span>").html_safe
    end

    # Extracts snippet which include query string or at least a word from it
    def snippet_containing_query(text)
      @query.split.each do |word|
        index = text.index(word)
        if index && index > 70
          text = text[index-70..-1]
          text = "..." + text[text.index(" ")+1..text.length]
        end
        break if index
      end
      text
    end
  end
end
