require_relative 'twitter'
require_relative 'sentimental'

tweets = data("trump", "en", 10)
tweets.each do |t|
  unless t[:text].nil?
    sent = sentiment(t[:text])
  end
end
