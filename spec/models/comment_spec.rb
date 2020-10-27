require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let!(:post) { create(:published_post) }
  let(:comment_params) { attributes_for(:comment) }

  context 'All params is valid' do
    it 'comment is valid' do
      comment = Comment.new(comment_params)
      expect(comment).to be_valid
    end
  end

  context 'content is invalid' do
    it 'invalid with nil' do
      comment_params[:content] = nil
      comment = Comment.new(comment_params)
      expect(comment).to be_invalid
    end

    it 'invalid with empty' do
      comment_params[:content] = ''
      comment = Comment.new(comment_params)
      expect(comment).to be_invalid
    end

    it 'invalid with greater than 100 words' do
      comment_params[:content] = 'a' * 101
      comment = Comment.new(comment_params)
      expect(comment).to be_invalid
      comment.content = 'a' * 100
      expect(comment).to be_valid
    end
  end
end
