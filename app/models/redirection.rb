class Redirection < ActiveRecord::Base
  belongs_to :next, class_name: "Redirection", optional: true
  has_one :previous, class_name: "Redirection", foreign_key: "next_id"

  validates :next_id, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true
  validate :unique_url_with_normalized_urls

  scope :in_ring_order, -> { order(next_id: :desc) }
  scope :latest_first, -> { order(created_at: :desc) }
  scope :order_nulls_last, ->(args) do
    sql = %[#{args["sort_key"]} #{args["sort_dir"]} NULLS LAST]
    order(sanitize_sql_for_order(Arel.sql(sql)))
  end

  def self.most_recent
    latest_first.first
  end

  def next_url
    self.next.url
  end

  def previous_url
    previous.url
  end

  def tag_uri
    date = created_at.iso8601

    "tag:#{UNCHANGING_HOSTNAME},#{date}:#{url}"
  end

  def unlink
    previous_redirection = previous
    next_redirection = self.next

    self.class.transaction do
      destroy!
      previous_redirection.update!(next: next_redirection)
    end
  end

  private

  def unique_url_with_normalized_urls
    if url.present?
      uri = URI.parse(url)
      matching_redirection = Redirection.where.not(slug: slug).all.detect do |redirection|
        UriComparison.same_normalized_uri?(uri, URI.parse(redirection.url))
      end
      if matching_redirection
        errors.add(:url, "is already taken by #{matching_redirection.slug}")
      end
    end
  end
end
