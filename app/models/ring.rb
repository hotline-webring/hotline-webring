class Ring
  FAKE_ID = -1

  def initialize(redirection_to_link)
    @redirection_to_link = redirection_to_link
    @from_redirection = Redirection.first
    @to_redirection = from_redirection.next
  end

  def link
    Redirection.transaction do
      redirection_to_link.update!(next_id: FAKE_ID)
      from_redirection.update!(next: redirection_to_link)
      redirection_to_link.update!(next: to_redirection)
    end
  end

  private

  attr_reader :from_redirection, :to_redirection, :redirection_to_link
end
