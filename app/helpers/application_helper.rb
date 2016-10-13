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

  def report_action_exist?
    begin
      current_page?(action: 'report')
    rescue
      return false
    end

    true
  end

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
  end

  def format_time(time)
    time.strftime('%b %d, %Y %I:%M %p')
  end

  def rank_title(rank)
    titles = ["Guest", "Member", "Sergeant-at-Arms", "Reporter", "Treasurer", "Secretary", "Vice President", "President", "Advisor"]
    titles[rank]
  end

  def current_user_submission_count
    session[:user_id] && Submission.where(user_id: session[:user_id]).count
  end

  def current_user_submission_todo
    session[:user_id] && (AccountabilityLog.count - Submission.where(user_id: session[:user_id]).count)
  end
end
