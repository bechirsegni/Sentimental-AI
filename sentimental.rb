require "json"
require 'yaml'

def reader(file)
  elements = []
  extracted =  File.open(file)
  extracted.each_line { |l| elements << l.chomp }
  return elements
end

def extract(tweet)
  words = tweet.downcase.split(" ")
end

def negative(words)
  negate = []
  list = words & reader("./Data/negative.txt")
  if list.length >= 1
    list.each do |f|
      negate << words[words.index(f) + 1]
    end
      negate
    else
      negate
  end
end

def clean(tweet)
  words = extract(tweet)
  clean =  words - reader("./Data/stopwords.txt")
end

def sentiment(tweet)
  words = extract(tweet)
  negate = negative(words)
  clean =  words - reader("./Data/stopwords.txt")
  en_words = JSON.parse( IO.read("./Data/en_words.json", encoding:'utf-8') )
  first_step = []
  clean.each do |n|
    first_step << {key: n , value: en_words[n]}
  end

  i = 0
  first_step.each do |word|
    if  negate.include?(word[:key])
      word[:value] = word[:value].to_f * -1
    end
      i += word[:value].to_f
  end

  if i > 0.25
      i =  "postive"
    elsif i < 0.25 && i >= -0.25
      i = "neutral"
    else i < -0.26
      i = "negative"
  end

  frequency_file = "./Data/agent/#{i}.yml"

  if File.exists?(frequency_file)
    old_frequency = YAML.load_file(frequency_file)
  else
    old_frequency = {}
  end

  old_frequency.default = 0

  frequency = clean.group_by{|name| name}.map{|name, list| [name,list.count+old_frequency[name]]}.to_h

  File.open(frequency_file,'w'){|f| f.write frequency.to_yaml}

end
