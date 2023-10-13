module ApplicationHelper
  def email_us
    mail_to email_address, "email us"
  end

  def email_address
    "ringleaders@hotlinewebring.club"
  end
end
