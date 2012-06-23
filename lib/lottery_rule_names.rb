#encoding: utf-8

module LotteryRuleNames
  module InstanceMethods
    BALL_NAMES = %w(none 第一球 第二球 第三球 第四球 第五球 第六球 第七球 第八球 兩面盤 總和、龍虎 連碼)
    COMB_NAMES = {:s2 => "任選二",
                  :c2 => "選二連組",
                  :s3 => "任選三",
                  :x3 => "選三前組",
                  :s4 => "任選四",
                  :s5 => "任選五"}

    HALF_BET_ITEMS = {:big => "大", :small => "小", :even => "雙",
                      :odd => "單", :trail_big => "尾大", :trail_small => "尾小",
                      :add_even => "合數雙", :add_odd => "合數單", :dragon => "龍",
                      :tiger => "虎"}
    QUARTER_BET_ITEMS = {:east => "東", :south => "南", :west => "西", :north => "北"}
    THIRD_BET_ITEMS = {:middle => "中", :fa => "發", :white => "白"}
  end

  extend ActiveSupport::Concern
end