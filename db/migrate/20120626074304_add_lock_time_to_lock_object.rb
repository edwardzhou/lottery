class AddLockTimeToLockObject < ActiveRecord::Migration
  def change
    change_table :lock_objects do |t|
      t.timestamp :lock_time
    end
  end
end
