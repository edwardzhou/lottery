module LotteryMembers
  module InstanceMethods

    def get_odds_level(level_id)
      if @odds_level_map.nil?
        @odds_level_map = {}
        odds_levels.each {|l| @odds_level_map[l.level_id] = l}
      end

      @odds_level_map[level_id]
    end

    def bet_rule(rule_id)
      rule_id = rule_id.to_sym unless rule_id.kind_of?(Symbol)
      result = self.bet_rules.where(rule_id: rule_id).first
      if result.nil?
        result = self.bet_rules.create({rule_id: rule_id})
      end

      result
    end

    def set_ball_values(balls_values)

      if self.ball_1.nil?
        self.ball_1 = Ball.new
      end
      if self.ball_2.nil?
        self.ball_2 = Ball.new
      end
      if self.ball_3.nil?
        self.ball_3 = Ball.new
      end
      if self.ball_4.nil?
        self.ball_4 = Ball.new
      end
      if self.ball_5.nil?
        self.ball_5 = Ball.new
      end
      if self.ball_6.nil?
        self.ball_6 = Ball.new
      end
      if self.ball_7.nil?
        self.ball_7 = Ball.new
      end
      if self.ball_8.nil?
        self.ball_8 = Ball.new
      end
      if self.ball_9.nil?
        self.ball_9 = Ball.new
      end
      if self.ball_10.nil?
        self.ball_10 = Ball.new
      end

      ball_sum = 0

      if (balls_values.kind_of?(Hash))
        self.ball_1.set_value(balls_values[:ball_1])
        self.ball_2.set_value(balls_values[:ball_2])
        self.ball_3.set_value(balls_values[:ball_3])
        self.ball_4.set_value(balls_values[:ball_4])
        self.ball_5.set_value(balls_values[:ball_5])
        self.ball_6.set_value(balls_values[:ball_6])
        self.ball_7.set_value(balls_values[:ball_7])
        self.ball_8.set_value(balls_values[:ball_8])
        ball_sum = balls_values.inject(0) {|sum, ball| sum = sum + ball[1] }
      else
        self.ball_1.set_value(balls_values[0])
        self.ball_2.set_value(balls_values[1])
        self.ball_3.set_value(balls_values[2])
        self.ball_4.set_value(balls_values[3])
        self.ball_5.set_value(balls_values[4])
        self.ball_6.set_value(balls_values[5])
        self.ball_7.set_value(balls_values[6])
        self.ball_8.set_value(balls_values[7])
        ball_sum = balls_values.inject(0) {|sum, ball| sum = sum + ball}
      end

      self.ball_9.set_value(ball_sum, true)
      self.ball_9.dragon = self.ball_1.ball_value > self.ball_8.ball_value
      self.ball_9.tiger = !self.ball_9.dragon

      self.ball_10.set_value(ball_sum, true)
      self.ball_10.dragon = self.ball_1.ball_value > self.ball_8.ball_value
      self.ball_10.tiger = !self.ball_10.dragon

      self

    end


    def balls_to_a
      [ball_1.ball_value, ball_2.ball_value, ball_3.ball_value, ball_4.ball_value,
       ball_5.ball_value, ball_6.ball_value, ball_7.ball_value, ball_8.ball_value]
    end

    def shuffle_balls!
      set_ball_values(balls_to_a.shuffle)
      self
    end

    def is_s?(s_array)
      @ball_values ||= balls_to_a
      s = s_array.select {|x| @ball_values.include?(x)}
      return s == s_array
    end

    def is_c?(c_array)
      @ball_values ||= balls_to_a
      @ball_values_str ||= @ball_values.join(",")
      c_array.permutation.each do |p|
        return true if @ball_values_str.include?(p.join(","))
      end
      false
    end

    def is_ps?(c_array)
      @ball_values ||= balls_to_a
      @ball_values_str ||= @ball_values.join(",")
      c_array.permutation.each do |p|
        return true if @ball_values_str.start_with?(p.join(","))
      end
      false
    end

  end

  extend ActiveSupport::Concern


end