require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:other_post) { create(:published_other_post) }

  context 'when sign_in' do
    before do
      sign_in user
      get user_path(user)
    end

    describe 'comments#create' do
      let(:comment_params) { attributes_for(:comment) }
      let(:invld_comment_params) { attributes_for(:comment, content: 'a' * 101) }

      context 'parameter is valid' do
        it 'returns http 200' do
          post post_comments_path(post_id: other_post.id),
               params: { comment: comment_params }, xhr: true
          expect(response.status).to eq 200
        end

        it 'create action has success' do
          expect do
            post post_comments_path(post_id: other_post.id),
                 params: { comment: comment_params }, xhr: true
          end.to change(Comment, :count).by 1
        end
      end

      context 'parameter is valid' do
        it 'returns http 200' do
          post post_comments_path(post_id: other_post.id),
               params: { comment: invld_comment_params }, xhr: true
          expect(response.status).to eq 200
        end

        it 'create action has failed' do
          expect do
            post post_comments_path(post_id: other_post.id),
                 params: { comment: invld_comment_params }, xhr: true
          end.to change(Comment, :count).by 0
        end
      end
    end
  end

  context 'when not sign_in' do
    before do
      get root_path
    end

    describe 'comments#create' do
      let(:comment_params) { attributes_for(:comment) }

      it 'create action has failed' do
        expect do
          post post_comments_path(post_id: other_post.id),
               params: { comment: comment_params }, xhr: true
        end.to change(Comment, :count).by 0
      end
    end
  end
end
