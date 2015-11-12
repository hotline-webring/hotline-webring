class Ring
  def initialize(redirection_to_link)
    @oldest_redirection = Redirection.order(created_at: :desc).last
    @newest_redirection = Redirection.order(created_at: :desc).first
    @redirection_to_link = redirection_to_link
  end

  def link
    Redirection.transaction do
      redirection_to_link.update!(next_id: 0)
      newest_redirection.update!(next: redirection_to_link)
      redirection_to_link.update!(next: oldest_redirection)
    end
  end

  private

  attr_reader :oldest_redirection, :newest_redirection, :redirection_to_link
end
