object false
node(:page) {@page}
node(:records) { @total_rows }
node(:total) { @pages }
child @bet_items => :rows do
  extends "home/_bet_item"
  #attributes :_id, :lottery_name
  #node(:id) {|lottery_def| lottery_def._id}
  #node(:cell) do |lottery_def|
  #  #[lottery_def._id, lottery_def.lottery_name]
  #  partial("admin/lottery_defs/_lottery_def.json.rabl", :object => lottery_def)
  #end
end

node(:userdata) do
  @user_data
end