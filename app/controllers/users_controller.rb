class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token # no check token
  before_action :set_user_by_token, except: :login
  
  def login
    @user = User.where(email: login_params[:email]).first
    if @user == nil
      @user = User.new(name: login_params[:name], email: login_params[:email], password: Devise.friendly_token[0,20], 
        about: "", created_at: Time.now, api_key: SecureRandom.base58(24))
      @user.save
      sign_in(:user, @user)
      return @user
    elsif @user != nil
      @user = User.where(email: login_params[:email]).first
    end
  end

  def show
    @user = User.find_by_name(params[:id])
    if @user == nil
      self.status = :not_found
      self.response_body = { error: 'User Not Found' }.to_json
    end
  end

  def submitted
    @user = User.find_by_name(params[:id])
    if @user == nil
      self.status = :not_found
      self.response_body = { error: 'User Not Found' }.to_json
    else
      @contributions = @user.contributions
    end
  end
  
  def edit
  end

  def create
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to submit_path, alert: @user.errors.full_messages.to_sentence}
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @user = current_user
      if @user.update(user_params)
        format.json { render :_user, status: :ok, location: @user }
        format.html { redirect_to action: "show", id: @user.name}
      else
        format.json do
          self.status = :unauthorized
          self.response_body = { error: 'Access denied. User(API-KEY) Unauthorized' }.to_json
        end
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
       params.require(:user).permit( :about)
    end
    
    def login_params
      params.require(:user).permit(:name, :email, :confirmation_token)
    end
    
    def set_user_by_token
      api_key = request.headers[:HTTP_X_API_KEY]
      if current_user != nil
        api_key = current_user.api_key
      end
      if api_key.nil?
        respond_to do |format|
          format.html do
            
          end
          format.json do
            self.status = :unauthorized
            self.response_body = { error: 'API-KEY VOID' }.to_json
          end
        end
      else
        user = User.find_by_api_key(api_key)
        if user.nil?
          respond_to do |format|
            format.html do
              flash[:error] = 'Access denied'
              redirect_to root_url
            end
            format.json do
              self.status = :unauthorized
              self.response_body = { error: 'Access denied. User(API-KEY) Unauthorized' }.to_json
            end
          end
        else
          sign_in(:user, user)
          return user
        end
      end
    end
end