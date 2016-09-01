module ApplicationHelper

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
    titles = ["Guest", "Member", "Sergeant-at-Arms", "Reporter", "Treasurer", "Secretary", "Vice President", "President", "Advisor"]
    titles[rank]
  end
end
