class LotterySeed
  def generate_seed
    seed = (1..20).collect{|v| v}.combination(8)
    #eliminate 3 sequences
    seed = seed.select{ |c| not ( (c[2] == c[1]+1 and c[1] == c[0]+1) or
                                  (c[3] == c[2]+1 and c[2] == c[1]+1) or
                                  (c[4] == c[3]+1 and c[3] == c[2]+1) or
                                  (c[5] == c[4]+1 and c[4] == c[3]+1) or
                                  (c[6] == c[5]+1 and c[5] == c[4]+1) or
                                  (c[7] == c[6]+1 and c[6] == c[5]+1) or
                                  (c[8] == c[7]+1 and c[7] == c[6]+1) ) }

    #eliminate 2 sequences
    seed = seed.select {|c| not ( (c[1]==c[0].next and (c[3]==c[2].next or
                                                        c[4]==c[3].next or
                                                        c[5]==c[4].next or
                                                        c[6]==c[5].next or
                                                        c[7]==c[6].next )) ) }

    seed = seed.select {|c| not ( (c[2]==c[1].next and (c[4]==c[3].next or
                                                          c[5]==c[4].next or
                                                          c[6]==c[5].next or
                                                          c[7]==c[6].next)) )}

    seed = seed.select {|c| not ( (c[3]==c[2].next and ( c[5]==c[4].next or
                                                          c[6]==c[5].next or
                                                          c[7]==c[6].next )) )}

    seed = seed.select {|c| not ( (c[4]==c[3].next and ( c[6]==c[5].next or c[7]==c[6].next)) )}

    #eliminate all odds
    seed = seed.select {|a| not ( a[0].odd? and a[1].odd? and a[2].odd? and a[3].odd? and a[4].odd? and a[5].odd? and a[6].odd? and a[7].odd? )}

    #eliminate all evens
    seed = seed.select {|a| not ( a[0].even? and a[1].even? and a[2].even? and a[3].even? and a[4].even? and a[5].even? and a[6].even? and a[7].even? )}

    seed
  end

  def fill_seed(seeds)
    seeds.each do |seed|
      #print "seeding "
      #print seed
      #print " ...\n"
      lp = LotteryPredict.new
      lp.set_ball_values(seed)
      lp.save!
    end
  end

end