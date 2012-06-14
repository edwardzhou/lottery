object :user
attributes :_id, :username, :true_name, :phone, :total_credit, :available_credit, :odds_level_name, :user_role, :locked_at

node(:user_role) do |user|
  t("label.user_role.#{user.user_role || 'user'}")
end

node(:locked) do |user|
  user.locked? ? "锁定" : "正常"
end

node(:show_url) do |user|
  link_to "详细", agent_user_path(user)
end

node(:edit_url) do |user|
  link_to "修改", edit_agent_user_path(user)
end

node(:reset_credit_url) do |user|
  link_to "恢复额度", reset_credit_agent_user_path(user), :confirm => "是否恢复 [#{user.username}] 的额度由 '#{user.available_credit}' 到 '#{user.total_credit}'?"
end


node(:lock_account_url) do |user|
  if user.locked?
    link_to "解锁", unlock_agent_user_path(user), :confirm => "是否解锁 [#{user.username}]?"
  else
    link_to "锁定", lock_agent_user_path(user), :confirm => "是否锁定 [#{user.username}]?"
  end
end

