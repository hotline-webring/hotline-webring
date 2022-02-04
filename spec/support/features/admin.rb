module Features
  def admin_login(username = admin_correct_username, password = admin_correct_password)
    page.driver.browser.basic_authorize(username, password)
  end

  def admin_correct_username
    ENV.fetch("ADMIN_USERNAME")
  end

  def admin_correct_password
    ENV.fetch("ADMIN_PASSWORD")
  end

  def admin_wrong_username
    admin_correct_username + "wrong"
  end

  def admin_wrong_password
    admin_correct_password + "wrong"
  end
end
