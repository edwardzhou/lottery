module HomeHelper
  def username_with_level(user)
    user.username + " (" + user.odds_level.level_name + ")"
  end
end
