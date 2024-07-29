  class HomeController < ApplicationController
  def index
    @joke = Joke.new
    @ai_jokes = AiJoke.all
  end
end
