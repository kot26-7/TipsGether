require 'rails_helper'

RSpec.describe 'Containers', type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  context 'when sign_in' do
    before do
      sign_in user
      get user_path(user)
    end

    describe 'posts#index' do
      context 'posts dont exist' do
        before do
          get posts_path
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'renders the :index template' do
          expect(response).to render_template :index
        end

        it 'displayed on correct title' do
          expect(response.body).to include full_title('投稿一覧')
        end

        it 'assigns the requested user to @posts' do
          expect(assigns(:posts)).to eq []
        end
      end

      context 'posts exist' do
        let!(:posts) { create_list(:published_post, 2) }
        let!(:unpublished_post) { create(:unpublished_post) }
        let!(:unpblsh_other_post) { create(:unpublished_other_post) }
        let!(:pblsh_other_post) { create(:published_other_post) }

        before do
          get posts_path
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'renders the :index template' do
          expect(response).to render_template :index
        end

        it 'displayed on correct title' do
          expect(response.body).to include full_title('投稿一覧')
        end

        it 'assigns the requested user to @posts' do
          expect(assigns(:posts)).to eq [posts, pblsh_other_post].flatten
        end
      end
    end

    describe 'posts#show' do
      let(:post) { create(:published_post) }

      before do
        get post_path(post)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :show
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title(post.title)
      end

      it 'assigns the requested user to @post' do
        expect(assigns(:post)).to eq post
      end
    end

    describe 'posts#new' do
      before do
        get new_post_path
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :new
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('新規投稿')
      end
    end

    describe 'posts#edit' do
      let(:post) { create(:published_post) }
      let!(:other_post) { create(:published_other_post) }

      before do
        get edit_post_path(post)
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'renders the :index template' do
        expect(response).to render_template :edit
      end

      it 'displayed on correct title' do
        expect(response.body).to include full_title('投稿編集')
      end

      it 'assigns the requested user to @post' do
        expect(assigns(:post)).to eq post
      end

      it 'invalid access and redirect to user_path' do
        get edit_post_path(other_post)
        expect(response).to redirect_to user_path(user)
      end
    end

    describe 'posts#create' do
      let(:post_params) { attributes_for(:unpublished_post) }
      let(:invld_post_params) { attributes_for(:unpublished_post, title: '') }

      before do
        get new_post_path
      end

      context 'parameter is valid' do
        it 'returns http 302' do
          post posts_path, params: { post: post_params }
          expect(response.status).to eq 302
        end

        it 'create action has success' do
          expect do
            post posts_path, params: { post: post_params }
          end.to change(Post, :count).by 1
        end

        it 'redirects to user_container_path' do
          post posts_path, params: { post: post_params }
          expect(response).to redirect_to post_path(1)
        end
      end

      context 'parameter is invalid' do
        it 'returns http success' do
          post posts_path, params: { post: invld_post_params }
          expect(response.status).to eq 200
        end

        it 'create action has failed' do
          expect do
            post posts_path, params: { post: invld_post_params }
          end.to change(Post, :count).by 0
        end
      end
    end

    describe 'posts#update' do
      let(:post) { create(:unpublished_post) }
      let(:post_params) { attributes_for(:unpublished_post, title: 'sample') }
      let(:invld_post_params) { attributes_for(:unpublished_post, title: '') }

      before do
        get edit_post_path(post)
      end

      context 'parameter is valid' do
        it 'returns http 302' do
          patch post_path, params: { post: post_params }
          expect(response.status).to eq 302
        end

        it 'parameter has changed successfully' do
          patch post_path, params: { post: post_params }
          expect(post.reload.title).to eq 'sample'
        end

        it 'redirects to user_container_path' do
          patch post_path, params: { post: post_params }
          expect(response).to redirect_to post_path(post)
        end
      end

      context 'parameter is invalid' do
        it 'returns http success' do
          patch post_path, params: { post: invld_post_params }
          expect(response.status).to eq 200
        end
      end
    end

    describe 'post#destroy' do
      let!(:post) { create(:published_post) }

      it 'destroy http is 302' do
        delete post_path(post)
        expect(response.status).to eq 302
      end

      it 'redirects to user_path' do
        delete post_path(post)
        expect(response).to redirect_to user_path(user)
      end

      it 'deletes a post' do
        expect do
          delete post_path(post)
        end.to change(Post, :count).by(-1)
      end
    end
  end

  context 'when not sign_in' do
    before do
      get root_path
    end

    describe 'posts#index' do
      let!(:posts) { create_list(:published_post, 2) }
      let!(:unpublished_post) { create(:unpublished_post) }

      it 'going to login page' do
        get posts_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'posts#show' do
      let!(:post) { create(:published_post) }

      it 'going to login page' do
        get post_path(post)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'posts#new' do
      it 'going to login page' do
        get new_post_path
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'posts#edit' do
      let(:post) { create(:published_post) }

      it 'going to login page' do
        get edit_post_path(post)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'posts#create' do
      let(:post_params) { attributes_for(:unpublished_post) }

      it 'going to login page' do
        post posts_path, params: { post: post_params }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
