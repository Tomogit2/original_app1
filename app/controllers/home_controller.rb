class HomeController < ApplicationController
  def index
    @jokes = Joke.all
    @ai_jokes = AiJoke.includes(:user, :joke)
    @ai_joke = @ai_jokes.first
  end
end
