object :lottery_def
attributes :_id, :lottery_name, :active, :start_time, :end_time, :period, :description
node(:url) do |m|
  admin_lottery_def_path(m._id)
end

node(:link) do |m|
  link_to "show", admin_lottery_def_path(m)
end