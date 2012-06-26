class LockObject < ActiveRecord::Base
  attr_accessible :lock_name

  def self.lock_on(obj_name, &block)
    obj = find_or_create_by_lock_name(obj_name)
    obj.with_lock do
      obj.lock_time = Time.now
      yield
      obj.save!
    end
  end

end
