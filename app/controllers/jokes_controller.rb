class JokesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @joke = current_user.jokes.build(joke_params)
    if @joke.save
      joke_text = generate_joke(@joke.category.name, @joke.input_text1, @joke.input_text2)
    
      if joke_text
        image_url = generate_image(joke_text)

        if image_url
            @joke.update(generated_joke: joke_text, generated_image_url: image_url)

        redirect_to root_path, notice: 'ジョークが生成されました。'
      else
        @joke.destroy
        @jokes = Joke.all
        flash.now[:alert] = '画像の生成に失敗しました。'
        render 'home/index'
      end
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

  def generate_joke(category_id, input_text1, input_text2)
    begin
      response = OpenAI::Completion.create(
        parameters: {
          engine: 'davinci',
          prompt: "Create a science joke in the category #{category} with the following words: #{input_text1}, #{input_text2}",
          max_tokens: 50
        }
      )
      response.choices.first.text.strip
    rescue => e
      Rails.logger.error("ジョーク生成エラー: #{e.message}")
      nil
    end
  end

  def generate_image(joke_text)
    begin
      response = OpenAI::Image.create(
        parameters: {
          prompt: joke_text,
          n: 1,
          size: '256x256'
      }
    )
    response.data.first.url
    rescue => e
      Rails.logger.error("画像生成エラー: #{e.message}")
      nil
    end
  end
end