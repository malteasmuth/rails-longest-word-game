class GamesController < ApplicationController

  require 'open-uri'
  require 'json'

  def new
    @range = ('A'..'Z').to_a
    @random_word = []
    10.times do
      @random_word << @range.sample
    end
  end

  def score
    @guess_word = params[:guess_word].downcase
    @url = "https://wagon-dictionary.herokuapp.com/#{@guess_word}"
    @check_serialized = URI.open(@url).read
    @check_result = JSON.parse(@check_serialized)

    @guess_word = @guess_word.split("")
    @random_word = params[:random_word].downcase.split
    if @check_result["found"] == true
      @guess_word.each do |letter|
        if @random_word.include?(letter)
          @random_word.delete_at(@random_word.index(letter))
          @result = "Well done, you rock!"
        else
          @result = "This word can't be build from the grid, sorry"
        end
      end

    elsif @check_result["found"] == false
      @result = "Sorry but #{@guess_word.join.upcase} is not a valid word"
    end
  end
end
