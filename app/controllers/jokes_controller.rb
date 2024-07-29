class JokesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @joke = current_user.jokes.build(joke_params)
    if @joke.save
      joke_text = generate_joke(@joke.category.name, @joke.input_text1, @joke.input_text2)

      else
        @joke.destroy
        @jokes = Joke.all
        flash.now[:alert] = 'ジョークの生成に失敗しました。'
        render 'home/index'
      end
    else
      @jokes = Joke.all
      render 'home/index'
    end
  end

  private

  def joke_params
    params.require(:joke).permit(:category_id, :input_text1, :input_text2)
  end

  def generate_joke(category, input_text1, input_text2)
    client = OpenAI::Client.new

    response = client.completions(
        parameters: {
        model: 'gpt-4o-mini',
        prompt: "Create a science joke in the category #{category} with the following words: #{input_text1}, #{input_text2}",
        max_tokens: 50
      }
    )

    if response && response['choices']
      response['choices'].first['text'].strip
    else
      Rails.logger.error("ジョーク生成エラー: response: #{response}")
      nil
    end
  rescue => e
    Rails.logger.error("ジョーク生成エラー: #{e.message}")
    nil
  end


end
