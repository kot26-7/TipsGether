require 'rails_helper'

RSpec.describe 'Home', type: :request do
  describe 'GET root_path' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET search_path' do
    context 'when sign_in' do
      let!(:user) { create(:user) }
      let!(:other_user) { create(:other_user) }
      let!(:post1) { create(:published_other_post, title: 'hello') }
      let!(:post2) { create(:published_post, title: 'hi') }
      let!(:post3) { create(:unpublished_other_post, title: 'hisample') }

      before do
        sign_in user
        get user_path(user)
      end

      context 'search_path with no params' do
        it 'going to login page' do
          get search_path
          expect(response).to redirect_to root_path
        end
      end

      context 'search_path when keyword is blank' do
        before do
          get search_path(option: 2)
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested msg to @err_msg' do
          expect(assigns(:err_msg)).to eq 'キーワードが設定されていません。再度検索を行ってください。'
        end

        it 'displayed on correct msg' do
          expect(response.body).to include 'あなたの検索は、どのユーザー・投稿にも一致しませんでした。'
        end
      end

      context 'search_path when option is 1' do
        before do
          get search_path(option: 1, keyword: 'test')
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested msg to @err_msg' do
          expect(assigns(:err_msg)).to eq '検索対象が設定されていません。再度お試しください。'
        end

        it 'displayed on correct msg' do
          expect(response.body).to include 'あなたの検索は、どのユーザー・投稿にも一致しませんでした。'
        end
      end

      context 'search_path when option is 2' do
        before do
          get search_path(option: 2, keyword: 'test')
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested msg to @err_msg' do
          expect(assigns(:err_msg)).to eq ''
        end

        it 'assigns the requested user to @results_u' do
          expect(assigns(:results_u)).to eq [user]
        end

        it 'displayed on correct msg' do
          expect(response.body).to include 'ユーザーの検索結果'
          expect(response.body).to include "ユーザー名: #{user.username}"
        end
      end

      context 'search_path when option is 3' do
        before do
          get search_path(option: 3, keyword: 'hi')
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested msg to @err_msg' do
          expect(assigns(:err_msg)).to eq ''
        end

        it 'assigns the requested user to @results_p' do
          expect(assigns(:results_p)).to eq [post2]
        end

        it 'displayed on correct msg' do
          expect(response.body).to include '投稿の検索結果'
          expect(response.body).to include "タイトル: #{post2.title}"
          expect(response.body).to include "投稿者: #{post2.user.username}"
        end
      end

      context 'search_path when keyword unmatch' do
        before do
          get search_path(option: 3, keyword: 'sample')
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'assigns the requested msg to @err_msg' do
          expect(assigns(:err_msg)).to eq ''
        end

        it 'assigns the requested user to @results_p' do
          expect(assigns(:results_p)).to eq []
        end

        it 'assigns the requested user to @results_u' do
          expect(assigns(:results_u)).to eq ''
        end

        it 'displayed on correct msg' do
          expect(response.body).to include 'あなたの検索は、どのユーザー・投稿にも一致しませんでした。'
        end
      end
    end

    context 'when not sign_in' do
      it 'going to login page' do
        get search_path
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
