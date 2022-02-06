require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do    

    it "returns OK" do
      get "/posts"
      payload = JSON.parse(response.body)
      expect(payload).to be_empty
      expect(response).to have_http_status(200) 
    end    
  end

  describe "with data in DB" do
    let!(:posts) { create_list(:post, 10, published: true) }

    it "returns all posts" do
      get "/posts"
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(10)
      expect(response).to have_http_status(200)
    end
  end
     
  describe "GET /posts/:id" do
    let(:post) { create(:post, published: true) }

    it "returns a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(response).to have_http_status(200)
    end
  end

end