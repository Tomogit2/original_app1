require 'rails_helper'

RSpec.describe Joke, type: :model do
  before do
    @joke = FactoryBot.build(:joke)
  end

  describe 'ジョークの保存' do
    context 'ジョークが保存できるとき' do
      it 'すべての必須項目が正しく入力されている場合、保存できること' do
        expect(@joke).to be_valid
      end
    end

    context 'ジョークが保存できないとき' do
      it 'category_idが空の場合、保存できないこと' do
        @joke.category_id = nil
        @joke.valid?
        expect(@joke.errors.full_messages).to include("Category can't be blank")
      end

      it 'input_text1が空の場合、保存できないこと' do
        @joke.input_text1 = ''
        @joke.valid?
        expect(@joke.errors.full_messages).to include("Input text1 can't be blank")
      end

      it 'input_text2が空の場合、保存できないこと' do
        @joke.input_text2 = ''
        @joke.valid?
        expect(@joke.errors.full_messages).to include("Input text2 can't be blank")
      end

      it 'category_idが1の場合、保存できないこと' do
        @joke.category_id = 1
        @joke.valid?
        expect(@joke.errors.full_messages).to include("Category must be greater than or equal to 2")
      end

      it 'category_idが0の場合、保存できないこと' do
        @joke.category_id = 0
        @joke.valid?
        expect(@joke.errors.full_messages).to include("Category must be greater than or equal to 2")
      end

      it 'category_idが範囲外の場合、保存できないこと' do
        @joke.category_id = 16
        @joke.valid?
        expect(@joke.errors.full_messages).to include("Category must be less than or equal to 15")
      end

    end
  end

  describe 'バリデーションのテスト' do
    it 'category_idが 2 から 15 の範囲内であること' do
      expect(@joke.category_id).to be_between(2, 15)
    end
  end
end

  