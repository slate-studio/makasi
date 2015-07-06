class CloudSearchDocument
  include Mongoid::Document

  field :url,                 type: String
  field :present_in_sitemap,  type: Boolean
  field :reindexed_at,        type: DateTime, default: DateTime.new(2000, 1, 1)

  index({ url: 1 }, unique: true)
  index({ reindexed_at: -1 }, background: true)

  validates_uniqueness_of :url

  before_destroy :remove_cloudsearch_index

  private

  def remove_cloudsearch_index
    Makasi::AsariClient.new.remove_item(url)
  end
end
