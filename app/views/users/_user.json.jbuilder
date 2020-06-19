json.extract! @user, :id, :name, :created_at, :about, :email, :api_key
json.url user_url(@user, format: :json)
