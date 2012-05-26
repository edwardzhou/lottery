class Sequence
  include Mongoid::Document
  field :seq_id, type: String
  field :seq_cur_val, type: Integer, default: 1
  include Mongoid::Timestamps

  def self.seq_by_id(seq_id)
    where(seq_id: seq_id).first
  end

  def self.next!(seq_id)
    seq_by_id(seq_id).next!
  end

  def next!
    cur_val = self.seq_cur_val

    self.seq_cur_val = self.seq_cur_val.next
    self.save!

    cur_val
  end

end