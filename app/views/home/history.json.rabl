object false
node(:page) {@page}
node(:records) { @total_rows }
node(:total) { @pages }
child @history => :rows do
  extends "home/_history_item"
end
