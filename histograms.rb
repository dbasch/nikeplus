#!/usr/bin/env ruby

#calculate histograms for nikeplus data from Twitter

require 'mongo'

count = 0
useful = 0

weekends = Hash.new 0
weekdays = Hash.new 0
speeds_5k = Hash.new 0
speeds_10k = Hash.new 0
total_weekdays = 0
total_weekends = 0
sum_weekend_distance = 0
sum_weekday_distance  = 0
total_5k = 0
total_10k = 0

db = Mongo::Connection.new.db("nike")
coll = db.collection("tweets")
coll.find.each do |tw|
  count +=1
  puts count if count % 10000 == 0
  t = tw['text']
  day = tw['created_at'].split[0]
  weekend = (day == "Sat" or day == "Sun")
  
  #see if the tweet has all the data we need
  if (t.include? " km " or t.include? " mi ") and t.include? " pace of " 
    parts = t.sub(",", ".").split
    d = 0.0
    pace = (t[9+(t.index " pace ")..-1].split '"') [0]
    a, b = pace.split "'"
    s =  3600.0 / (a.to_i * 60 + b.to_i)
    parts.each_with_index do |p, i|
      if p == "km" or p == "mi" #normalize to the metric system
        d =  parts[i-1].to_f 
        d *= 1.60934 if p == "mi"
        s *= 1.60934 if p == "mi"
      end
    end
    #discard extreme outliers or errors
    next if s > 25 or s < 2 or d > 45 or d < 1 
    useful += 1
    if weekend
       weekends[d.to_i] +=1
       sum_weekend_distance +=d
       total_weekends +=1
     else
       weekdays[d.to_i] +=1
       sum_weekday_distance +=d
       total_weekdays +=1
    end
    if 4.8 < d and 5.2 > d
      speeds_5k[s.to_i] +=1 
      total_5k +=1
    end
    if 9.8 < d and 10.2 > d
      speeds_10k[s.to_i] +=1 
      total_10k +=1
    end
  end
end

#dump histograms to csv files, normalized as if we had 100k runs for each histogram
f = open("weekends_hist.csv", "w")
printf f, "distance,people\n"
weekends.keys.sort.each {|k| printf f, "%d,%d\n", k, weekends[k] * 100000 / total_weekends}
f.close

f = open("weekdays_hist.csv", "w")
printf f, "distance,people\n"
weekdays.keys.sort.each {|k| printf f, "%d,%d\n", k, weekdays[k] * 100000 / total_weekdays}
f.close

f = open("speeds_5k_hist.csv", "w")
printf f, "speed,people\n"
speeds_5k.keys.sort.each {|k| printf f, "%d,%d\n", k, speeds_5k[k] * 100000 / total_5k}
f.close

f = open("speeds_10k_hist.csv", "w")
printf f, "speed,people\n"
speeds_10k.keys.sort.each {|k| printf f, "%d,%d\n", k, speeds_10k[k] * 100000 / total_10k}
f.close

f = open("weekend_weekday_diff.csv", "w")
printf f, "distance,difference\n"
weekends.keys.sort.each {|k| printf f, "%d,%d\n", k, weekends[k] * 100000 / total_weekends - weekdays[k] * 100000 / total_weekdays}
f.close

printf "We had %d tweets, %d of which had useful data.\n", count, useful
printf "Average weekend distance: %.2f\n", sum_weekend_distance / total_weekends
printf "Average weekday distance: %.2f\n", sum_weekday_distance / total_weekdays
