require 'json'
require 'open-uri'

class GamesController < ApplicationController

  def new
    @my_letters = ""
    @letters = []
    10.times do
      @letters << ("A".."Z").to_a.sample
    end
  end

  def score
    response = params[:response]
    my_letters = params[:my_letters].chars
    letters_response = response.upcase.split("")
    hash_response = from_array_to_hash(letters_response)
    hash_prop = from_array_to_hash(my_letters)
    hash_response.each do |key, value|
      if value > hash_prop[key]
      	return @answer = "Sorry but #{response.upcase} can't be built out of #{my_letters.join(",")}"
      elsif !word_valid?(response)
        return @answer = "Sorry but #{response.upcase} doesn't seem to be an English word ..."
      else
        return @answer = "Congratulation! #{response.upcase} is a valide English word!"
      end
    end
  end

  def from_array_to_hash(array)
    new_hash = Hash.new(0)
    array.each { |letter| new_hash[letter] += 1 }
    new_hash
  end

  def word_valid?(word)
    url_base = "https://wagon-dictionary.herokuapp.com/"
    url = "#{url_base}#{word.downcase}"
    url_serialized = open(url).read
    api_response = JSON.parse(url_serialized)
    binding.pry
    api_response["found"] == true ? true : false
  end
end
