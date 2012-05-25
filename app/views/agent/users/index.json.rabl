object false
node(:page) {@page}
node(:records) { @total_rows }
node(:total) { @pages }
child @users => :rows do
  extends "agent/users/_user"
end
