require 'twitter'
require 'geocoder'

def authenticate
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "6b4NEpmuu4o6le3Z7lgkSaUR6"
    config.consumer_secret     = "FPLlzSPuajs78rOM6FgsmsZQiDgsTnPpcSbcdZFbgyC9cSY8EN"
    config.access_token        = "172709911-aKrrCFh3Qay5aS3tpOGLxMEGhsHZzcNsjQbFVWul"
    config.access_token_secret = "cR8Bg49Od9yIIsxFagIlqQEcl3N8g4oPkr6ra3aW0y7D8"
  end
end


def search(query, lang, num)
  client = authenticate
  tweets = []
  client.search(query, lang: lang, result_type: "recent").take(num).collect do |tweet|
    tweets  << { text: tweet.text.to_s,
                 location: tweet.user.location,
                 created_at: tweet.created_at }
  end
  return tweets
end


def data(query, lang, num)
  tweets = search(query, lang, num)
  tweets.each do |t|
    t[:text] = t[:text].gsub(/(?:f|ht)tps?:\/[^\s]+/, '')
    t[:text] = t[:text].gsub!(/\B[@#]\S+\b/, '')

    unless Geocoder.search(t[:location]).first.nil?
      coords = Geocoder.search(t[:location]).first.coordinates
      t[:location] = [lat: coords.first , lng: coords.last ]
    end
  end
end
