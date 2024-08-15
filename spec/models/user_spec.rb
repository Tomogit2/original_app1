require 'rails_helper'
require 'faker'

Faker::Config.locale = :ja

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it '全ての項目が適切に記入されていれば登録できること' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      describe 'nickname' do
        it 'nicknameが空では登録できない' do
          @user.nickname = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Nickname can't be blank")
        end
      end

      describe 'email' do
        it 'emailが空では登録できない' do
          @user.email = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Email can't be blank")
        end

        it '重複したemailが存在する場合は登録できない' do
          @user.save
          another_user = FactoryBot.build(:user, email: @user.email)
          another_user.valid?
          expect(another_user.errors.full_messages).to include('Email has already been taken')
        end

        it 'emailは@を含まないと登録できない' do
          @user.email = 'testemail.com'
          @user.valid?
          expect(@user.errors.full_messages).to include('Email is invalid')
        end
      end

      describe 'password' do
        it 'passwordが空では登録できない' do
          @user.password = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Password can't be blank")
        end

        it 'passwordとpassword_confirmationが一致していないと登録できない' do
          @user.password = '123456'
          @user.password_confirmation = '654321'
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end

        it 'passwordは6文字以上でないと登録できない' do
          @user.password = '12345'
          @user.password_confirmation = '12345'
          @user.valid?
          expect(@user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
        end

        it 'passwordが129文字以上では登録できない' do
          @user.password = Faker::Internet.password(min_length: 129, max_length: 129)
          @user.password_confirmation = @user.password
          @user.valid?
          expect(@user.errors.full_messages).to include('Password is too long (maximum is 128 characters)')
        end
        
        it '全角文字を含むパスワードでは登録できない' do
          @user.password = 'ａｂｃ１２３'
          @user.password_confirmation = 'ａｂｃ１２３'
          @user.valid?
          puts @user.errors.full_messages
          expect(@user.errors.full_messages).to include('Password に全角文字を含めないでください')
          
        end
      end

      describe 'password_confirmation' do
        it 'password_confirmationが空では登録できない' do
          @user.password_confirmation = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
        end
      end
    end
  end
end
