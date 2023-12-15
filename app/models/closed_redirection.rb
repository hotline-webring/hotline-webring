class ClosedRedirection
  def next_url
    Rails.application.routes.url_helpers.page_path("closed")
  end

  def previous_url
    Rails.application.routes.url_helpers.page_path("closed")
  end
end
