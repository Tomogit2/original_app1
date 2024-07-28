class JokesController < ApplicationController
  require 'openai'
  require 'http'

  def create
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

    response = client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: [
            { role: "", content: ""
                    ],
          tempe

    response = client.completions(
      engine: 'text-davinci-003',
      prompt: params[:input_text],
      max_tokens: 150
    )

    @joke = response['choices'].first['text']
    render json: { joke: @joke }

    @generated_text = response.dig("choices", 0, "message", "content")
    
  end
end

def new
    @joke = Joke.new
  end

  def create
    @joke = Joke.new(joke_params)
    if @joke.save
      response = generate_joke(@joke)
      @joke.update(response: response)
      generate_image(@joke)
      redirect_to @joke
    else
      render :new
    end
  end

  def show
    @joke = Joke.find(params[:id])
  end

  private

  def joke_params
    params.require(:joke).permit(:topic, :input1, :input2)
  end

  def generate_joke(joke)
    prompt = "理系的なジョークが面白いと感じるのですが、『#{joke.topic}』『#{joke.input1}』、『#{joke.input2}』をお題に何かダジャレや面白いことをお嬢様口調で 1つ言ってください。"
    response = HTTP.post("https://api.openai.com/v1/engines/davinci-codex/completions", 
                          headers: { "Authorization" => "Bearer YOUR_OPENAI_API_KEY" },
                          json: { prompt: prompt, max_tokens: 100 })
    JSON.parse(response.body)["choices"][0]["text"]
  end

  def generate_image(joke)
    prompt = joke.response
    response = HTTP.post("https://api.openai.com/v1/images/generations",
                         headers: { "Authorization" => "Bearer YOUR_OPENAI_API_KEY" },
                         json: { prompt: prompt, n: 1, size: "512x512" })
    joke.update(image_url: JSON.parse(response.body)["data"][0]["url"])
  end
end
