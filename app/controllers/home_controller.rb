class HomeController < ApplicationController
  def index
    @jokes = Joke.all
    @ai_jokes = AiJoke.includes(:user, :joke).order(created_at: :desc)
    @ai_joke = @ai_jokes.first
  end
end
