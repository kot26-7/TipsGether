require 'rails_helper'

RSpec.describe Post, type: :model do
  let!(:user) { create(:user) }
  let(:post_params) { attributes_for(:unpublished_post) }

  context 'All params is valid' do
    it 'post is valid' do
      post = Post.new(post_params)
      expect(post).to be_valid
      expect(post[:published]).to eq false
    end
  end

  context 'title is invalid' do
    it 'invalid with nil' do
      post_params[:title] = nil
      post = Post.new(post_params)
      expect(post).to be_invalid
    end

    it 'invalid with empty' do
      post_params[:title] = ''
      post = Post.new(post_params)
      expect(post).to be_invalid
    end

    it 'invalid with greater than 75 words' do
      post_params[:title] = 'a' * 76
      post = Post.new(post_params)
      expect(post).to be_invalid
    end
  end

  context 'content is invalid' do
    it 'invalid with nil' do
      post_params[:content] = nil
      post = Post.new(post_params)
      expect(post).to be_invalid
    end

    it 'invalid with empty' do
      post_params[:content] = ''
      post = Post.new(post_params)
      expect(post).to be_invalid
    end

    it 'invalid with greater than 750 words' do
      post_params[:content] = 'a' * 751
      post = Post.new(post_params)
      expect(post).to be_invalid
      post.content = 'a' * 750
      expect(post).to be_valid
    end
  end
end
