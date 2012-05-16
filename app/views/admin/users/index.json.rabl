object false
node(:page) {1}
node(:records) { @users.size }
node(:total) { @users.size }
child @users => :rows do
  extends "admin/users/_user"
  #attributes :_id, :lottery_name
  #node(:id) {|lottery_def| lottery_def._id}
  #node(:cell) do |lottery_def|
  #  #[lottery_def._id, lottery_def.lottery_name]
  #  partial("admin/lottery_defs/_lottery_def.json.rabl", :object => lottery_def)
  #end
end
