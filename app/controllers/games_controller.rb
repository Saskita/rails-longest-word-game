require 'open-uri'
require 'json'
#
class GamesController < ApplicationController
  VOWELS = %w[A E I O U Y]

  def new
    # @letters = ('A'..'Z').to_a.sample(10)
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = params[:word].upcase
    @grid = params[:grid]
    # @included = included?(@word, @letters)
    @english_word = english_word?(@word)
    # @grid.include?(@word) && english_word?(@word) == true
    @included = include?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def include?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}").read
    data = JSON.parse(response)
    data['found']
  end
end
