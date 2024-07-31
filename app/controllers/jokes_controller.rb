class JokesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :show]
  before_action :set_joke, only: [:show, :destroy]

  def index
    @user = User.find(params[:user_id])
    @jokes = @user.jokes
  end

  def create
    @joke = current_user.jokes.build(joke_params)
    if @joke.save
      joke_text = generate_joke(@joke.category.name, @joke.input_text1, @joke.input_text2)
      if joke_text
        AiJoke.create(user: current_user, joke: @joke, generated_joke: joke_text)
      else
        @joke.destroy
        flash.now[:alert] = 'ジョークの生成に失敗しました。'
      end
    end
    @jokes = Joke.all
    @ai_jokes = AiJoke.all
    render 'home/index'
  end

  def show
    @ai_joke = AiJoke.find_by(joke_id: params[:id])
  end

  private

  def joke_params
    params.require(:joke).permit(:category_id, :input_text1, :input_text2)
  end

  def set_joke
    @joke = Joke.find(params[:id])
  end

  def generate_joke(category, input_text1, input_text2)
    client = OpenAI::Client.new

    response = client.chat(
      parameters: {
        model: 'gpt-4o-mini',
        messages: [
          { role: "system", content: "You are a funny assistant." },
          { role: "user", content: "Create a science joke in the category #{category} with the following words: #{input_text1}, #{input_text2}" }
        ],
        max_tokens: 50
      }
    )

    if response && response['choices']
      response['choices'].first['message']['content'].strip
    else
      Rails.logger.error("ジョーク生成エラー: response: #{response}")
      nil
    end
  rescue => e
    Rails.logger.error("ジョーク生成エラー: #{e.message}")
    nil
  end
end
