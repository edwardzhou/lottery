object false
node(:page) {1}
node(:records) { 20 }
node(:total) { @lottery_defs.size }
child @lottery_defs => :rows do
  extends "admin/lottery_defs/_lottery_def"
  #attributes :_id, :lottery_name
  #node(:id) {|lottery_def| lottery_def._id}
  #node(:cell) do |lottery_def|
  #  #[lottery_def._id, lottery_def.lottery_name]
  #  partial("admin/lottery_defs/_lottery_def.json.rabl", :object => lottery_def)
  #end
end
