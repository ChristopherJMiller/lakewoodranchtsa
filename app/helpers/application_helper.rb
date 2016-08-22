module ApplicationHelper
  def logged_in
    session[:user_id] && User.find_by_id(session[:user_id])
  end

  def current_user
    session[:user_id] && User.find_by_id(session[:user_id])
  end

  def format_date(date)
    date.to_formatted_s(:long)
  end

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
  end

  def format_time(time)
    time.strftime('%b %d, %Y %I:%M %p')
  end

  def rank_title(rank)
    titles = ["Guest", "Member", "Seargent-At-Arms", "Reporter", "Treasurer", "Secretary", "Vice President", "President", "Advisor"]
    titles[rank]
  end
end
