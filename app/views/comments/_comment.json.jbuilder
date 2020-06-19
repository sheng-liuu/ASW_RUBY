json.extract! comment, :id, :content, :user_id, :contribution_id, :comment_id, :voted, :points, :created_at, :updated_at, :user_name
json.url contribution_url(comment, format: :json)
