class Redirection < ActiveRecord::Base
  belongs_to :next, class_name: "Redirection"
  has_one :previous, class_name: "Redirection", foreign_key: "next_id"

  validates :next_id, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true

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
end
