#!/usr/bin/env ruby

#collect tweets with the hashtag #nikeplus
require 'tweetstream'
require 'mongo'

db = Mongo::Connection.new.db("nike")
coll = db.collection("tweets")

TweetStream.configure do |config|
  config.consumer_key       = 'your_key'
  config.consumer_secret    = 'your_secret'
  config.oauth_token        = 'your_token'
  config.oauth_token_secret = 'your_token_secret'
  config.auth_method        = :oauth
end

TweetStream::Client.new.track("#nikeplus") {|s| coll.insert(s['attrs'])}
