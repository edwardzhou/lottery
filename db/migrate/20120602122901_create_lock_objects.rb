class CreateLockObjects < ActiveRecord::Migration
  def change
    create_table :lock_objects do |t|
      t.string :lock_name

      t.timestamps
    end
  end
end
