object :history_item
attributes :lottery_full_id

node(:end_time) do |item|
  item.formatted_end_time
end

node(:ball_1) do |item|
  "<div style='margin-top: 2px;height: 25px; width: 27px' class='No_#{format("%02d", item.ball_1.ball_value)}'></div>"
end

node(:ball_2) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_2.ball_value)}'></div>"
end

node(:ball_3) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_3.ball_value)}'></div>"
end

node(:ball_4) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_4.ball_value)}'></div>"
end

node(:ball_5) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_5.ball_value)}'></div>"
end

node(:ball_6) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_6.ball_value)}'></div>"
end

node(:ball_7) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_7.ball_value)}'></div>"
end

node(:ball_8) do |item|
  "<div style='height: 25px; width: 27px' class='No_#{format("%02d", item.ball_8.ball_value)}'></div>"
end


node(:sum) do |item|
  item.ball_9.ball_value
end

node(:dragon_tiger) do |item|
  if item.ball_9.dragon?
    "<font color='red'>龍</font>"
  else
    "虎"
  end
end

node(:sum_big_small) do |item|
  if item.ball_9.big
    "<font color='red'>大</font>"
  else
    "小"
  end
end

node(:sum_trail_big_small) do |item|
  if item.ball_9.trail_big
    "<font color='red'>尾大</font>"
  else
    "尾小"
  end
end

node(:sum_even_odd) do |item|
  if item.ball_9.even
    "<font color='red'>雙</font>"
  else
    "單"
  end
end



