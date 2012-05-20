object :user
attributes :_id, :username, :true_name, :phone, :total_credit, :available_credit, :odds_level_name, :user_role, :locked_at

node(:user_role) do |user|
  t("label.user_role.#{user.user_role || 'user'}")
end

node(:locked) do |user|
  user.locked? ? "锁定" : "正常"
end

node(:show_url) do |user|
  link_to "详细", admin_user_path(user)
end

node(:edit_url) do |user|
  link_to "修改", edit_admin_user_path(user)
end

node(:lock_account_url) do |user|
  if user.locked?
    link_to "解锁", unlock_admin_user_path(user)
  else
    link_to "锁定", lock_admin_user_path(user)
  end
end

