# Helpers for User
module UsersHelper
  def dropdown_ranks
    if User.find_by(id: session[:user_id]).advisor?
      ['Guest', 'Member', 'Seargent-At-Arms', 'Reporter', 'Treasurer', 'Secretary', 'Vice President', 'President', 'Advisor']
    else
      %w(Guest Member)
    end
  end
end
