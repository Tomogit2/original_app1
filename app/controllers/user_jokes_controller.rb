class UserJokesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @jokes = @user.ai_jokes
  end
end