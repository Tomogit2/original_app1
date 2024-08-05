class JokesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :destroy]
  before_action :set_joke, only: [:destroy]
  before_action :correct_user, only: [:destroy]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @jokes = @user.jokes.includes(:category, :ai_jokes)
      @ai_jokes = AiJoke.where(user_id: params[:user_id])
    else
      @jokes = Joke.all.includes(:category, :ai_jokes)
    end
  end

  def create
    @joke = current_user.jokes.build(joke_params)
    if @joke.save
      joke_text = generate_joke(@joke.category.name, @joke.input_text1, @joke.input_text2)
      if joke_text
        AiJoke.create(user: current_user, joke: @joke, generated_joke: joke_text)
      else
        @joke.destroy
        flash.now[:alert] = 'アイデアがつくれませんでした。'
      end
    end
    redirect_to jokes_path
  end
  
  def show
    @joke = Joke.find(params[:id])
    @ai_joke = AiJoke.find_by(joke_id: @joke.id)

    respond_to do |format|
      format.html
      format.turbo_stream 
    end
  end

  def destroy
    @joke.destroy
    redirect_to jokes_path, notice: 'アイデアをけしました。'
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
          { role: "user", content: "くすっと笑える楽しさを重視して、#{category}を軸にした考え方を用いて#{input_text1}, #{input_text2}をお題にして「小学生向けに身近な謎に対する研究題目」を考えてください。語尾は「～について考えてみるのは面白いんじゃない？」としてください" }
        ],
        max_tokens: 100
      }
    )

    if response && response['choices']
      response['choices'].first['message']['content'].strip
    else
      Rails.logger.error("アイデアしっぱい: response: #{response}")
      nil
    end
  rescue => e
    Rails.logger.error("アイデアしっぱい: #{e.message}")
    nil
  end
end
