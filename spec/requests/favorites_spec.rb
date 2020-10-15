require 'rails_helper'

RSpec.describe 'Favorites', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }
  let!(:pblsh_other_post) { create(:published_other_post) }

  context 'when sign_in' do
    before do
      sign_in user
    end

    describe 'favorites#create' do
      it 'returns http 302' do
        post post_favorites_path(post_id: pblsh_other_post.id)
        expect(response.status).to eq 302
      end

      it 'create action has success' do
        expect do
          post post_favorites_path(post_id: pblsh_other_post.id)
        end.to change(Favorite, :count).by 1
      end

      it 'redirects to post_path' do
        post post_favorites_path(post_id: pblsh_other_post.id)
        expect(response).to redirect_to post_path(pblsh_other_post.id)
      end
    end

    describe 'favorites#destroy' do
      let!(:favorite) { create(:favorite, { post_id: pblsh_other_post.id, user_id: user.id }) }

      it 'returns http 302' do
        delete post_favorite_path(post_id: pblsh_other_post.id, id: favorite)
        expect(response.status).to eq 302
      end

      it 'create action has success' do
        expect do
          delete post_favorite_path(post_id: pblsh_other_post.id, id: favorite)
        end.to change(Favorite, :count).by(-1)
      end

      it 'redirects to post_path' do
        delete post_favorite_path(post_id: pblsh_other_post.id, id: favorite)
        expect(response).to redirect_to post_path(pblsh_other_post.id)
      end
    end
  end

  context 'when not sign_in' do
    before do
      get root_path
    end

    describe 'favorites#create' do
      it 'going to login page' do
        post post_favorites_path(post_id: pblsh_other_post.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'favorites#destroy' do
      let!(:favorite) { create(:favorite, { post_id: pblsh_other_post.id, user_id: user.id }) }

      it 'going to login page' do
        delete post_favorite_path(post_id: pblsh_other_post.id, id: favorite)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
