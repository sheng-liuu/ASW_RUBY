json.extract! @comment, :id, :content, :user_id, :contribution_id, :created_at, :updated_at, :user_name, :voted
json.set! "_links" do
    json.set! "self" do
      json.set! "href", comment_url(@comment, format: :json)
    end
    json.set! "user" do
      json.set! "href", user_url(@comment.user, format: :json)
    end
    json.set! "contribution" do
      json.set! "href", contribution_url(@comment.contribution, format: :json)
    end
end