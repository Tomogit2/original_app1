  class HomeController < ApplicationController
  def index
    @joke = Joke.new
    @jokes = Joke.all
  end
end
