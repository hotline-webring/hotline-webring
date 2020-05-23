class Redirection < ActiveRecord::Base
  belongs_to :next, class_name: "Redirection", optional: true
  has_one :previous, class_name: "Redirection", foreign_key: "next_id"

  validates :next_id, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true
  validate :unique_url_ignoring_www_and_protocol

  scope :in_ring_order, -> { order(next_id: :desc) }
  scope :latest_first, -> { order(created_at: :desc) }

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

  def unique_url_ignoring_www_and_protocol
    if url.present?
      uri = URI.parse(url)
      normalized_uri = "#{uri.host.sub(/^www./, '')}#{uri.path}?#{uri.query}"
      matching_redirection = Redirection.where.not(slug: slug).all.detect do |redirection|
        other_uri = URI.parse(redirection.url)
        other_normalized_uri = other_uri.host.sub(/^www./, '') +
          other_uri.path +
          "?#{other_uri.query}"
        other_normalized_uri == normalized_uri
      end
      if matching_redirection
        errors.add(:url, "is already taken by #{matching_redirection.slug}")
      end
    end
  end
end
