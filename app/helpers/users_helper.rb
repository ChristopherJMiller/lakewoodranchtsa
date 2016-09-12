module UsersHelper
  def dropdown_ranks
    if User.find_by_id(session[:user_id]).is_advisor
      ["Guest", "Member", "Seargent-At-Arms", "Reporter", "Treasurer", "Secretary", "Vice President", "President", "Advisor"]
    else
      ["Guest", "Member"]
    end
  end
end
