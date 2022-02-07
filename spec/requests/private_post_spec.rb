require "rails_helper"

RSpec.describe "Posts with authentication", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:user_post) { create(:post, user_id: user.id) }
  let!(:other_user_post) { create(:post, user_id: other_user.id, published: true) }
  let!(:other_user_post_private) { create(:post, user_id: other_user.id, published: false) }

  let!(:auth_headers) { { 'Autorization' => "Bearer #{user.auth_token}"} }
  let!(:other_auth_headers) { { 'Autorization' => "Bearer #{other_user.auth_token}"} }

  describe "GET /posts/:id" do
    context "with valid auth" do
      context "when requesting another user post" do
        context "when requesting a public post" do
          it "returns the post" do
            get "/posts/#{other_user_post.id}", headers: auth_headers
            response = JSON.parse(response.body)
            expect(response).to have_http_status(200)
            expect(response["id"]).to eq(other_user_post.id)
          end
        end
        context "when requesting a private post" do          
          it "returns an error" do
            get "/posts/#{other_user_post_private.id}", headers: auth_headers
            response = JSON.parse(response.body)
            expect(response).to have_http_status(404)
            expect(response["error"]).to eq("Not Found")
          end
        end
      end
      context "when requesting own post" do
      end
    end
  end

  describe "POST /posts" do
  end

  describe "PUT /posts/:id" do
  end
end