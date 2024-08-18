require 'rails_helper'

RSpec.describe AiJoke, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @joke = FactoryBot.create(:joke)
  end

  context 'AIジョークの保存' do
    it 'user_idとjoke_idがあれば保存できること' do
      ai_joke = AiJoke.new(user_id: @user.id, joke_id: @joke.id)
      expect(ai_joke).to be_valid
    end

    it 'user_idがなければ保存できないこと' do
      ai_joke = AiJoke.new(joke_id: @joke.id)
      expect(ai_joke).to_not be_valid
    end

    it 'joke_idがなければ保存できないこと' do
      ai_joke = AiJoke.new(user_id: @user.id)
      expect(ai_joke).to_not be_valid
    end
  end
end