json.array!(@comments) do |comment|
  json.extract! comment, :id, :content, :user_id, :contribution_id, :created_at, :user_name, :comment_id, :voted, :points
end
