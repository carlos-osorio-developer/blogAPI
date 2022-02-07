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

  describe "POST /posts" do
    let!(:user) { create(:user) }
    
    it "creates a post" do      

      req_payload = {
        post: {
          title: "Post title",
          content: "Post body",
          published: true,
          user_id: user.id
        } 
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)            
      expect(payload).not_to be_empty
      expect(payload['id']).not_to be_nil
      expect(payload['title']).to eq("Post title")
      expect(payload['content']).to eq("Post body")
      expect(response).to have_http_status(201)# 201 same as :created
    end

    it "returns an error on invalid post" do
      req_payload = {
        post: {          
          content: "",
          published: true,
          user_id: user.id
        } 
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)      
      expect(payload).not_to be_empty
      expect(payload['error']).not_to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
    end      
  end

  describe "PUT /posts/:id" do
    let!(:article) { create(:post, published: true) }

    it "updates a post" do

      req_payload = {
        post: {
          title: "Post new title",
          content: "Post new body",
          published: true
        }
      }        

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)      
      expect(payload).not_to be_empty
      expect(payload['id']).to eq(article.id)
      expect(payload['title']).to eq("Post new title")
      expect(payload['content']).to eq("Post new body")
      expect(response).to have_http_status(:ok)
    end

    it "returns an error on invalid update" do
      req_payload = {
        post: {
          title: nil,
          body: nil,
          published: true          
        } 
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload['errors']).not_to be_empty  
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

 