class Redirection < ActiveRecord::Base
  belongs_to :next, class_name: "Redirection"
  has_one :previous, class_name: "Redirection", foreign_key: "next_id"

  validates :next_id, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :url, presence: true

  def next_url
    self.next.url
  end

  def previous_url
    previous.url
  end
end
