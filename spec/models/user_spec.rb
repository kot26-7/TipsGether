require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user_params) { attributes_for(:user) }

  context 'All params is valid' do
    it 'user is valid' do
      user = User.new(user_params)
      expect(user).to be_valid
    end
  end

  context 'username is invalid' do
    it 'empty username is invalid' do
      user_params[:username] = ''
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'nil username is invalid' do
      user_params[:username] = nil
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'username with . is invalid' do
      user_params[:username] = 'hoge.hoge'
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'username greater than 51 is invalid' do
      user_params[:username] = 'a' * 51
      user = User.new(user_params)
      expect(user).to be_invalid
      user.username = 'a' * 50
      expect(user).to be_valid
    end
  end

  context 'email is invalid' do
    it 'empty email is invalid' do
      user_params[:email] = ''
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'nil email is invalid' do
      user_params[:email] = nil
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'short email is invalid' do
      user_params[:email] = 'ho@ga'
      user = User.new(user_params)
      expect(user).to be_invalid
    end
  end

  context 'password is invalid' do
    it 'empty password is invalid' do
      user_params[:password] = ''
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'nil password is invalid' do
      user_params[:password] = nil
      user = User.new(user_params)
      expect(user).to be_invalid
    end

    it 'password less than 6 is invalid' do
      user_params[:password] = 'a' * 5
      user = User.new(user_params)
      expect(user).to be_invalid
      user.password = 'a' * 6
      expect(user).to be_valid
    end
  end

  context 'introduce is invalid' do
    it 'introduce greater than 500 is invalid' do
      user_params[:introduce] = 'a' * 501
      user = User.new(user_params)
      expect(user).to be_invalid
      user.introduce = 'a' * 500
      expect(user).to be_valid
    end
  end
end
