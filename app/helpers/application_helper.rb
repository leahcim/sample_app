module ApplicationHelper

  # Return title on a per-page basis
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil? then
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
end
