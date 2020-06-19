class ContributionsController < ApplicationController
   # before_action :set_user_by_token
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :new, :submit, :comment, :reply, :get_contributions, :get_comments], unless: -> { request.format.json? }
  before_action :set_contribution, only: [:show, :edit, :update, :destroy, :point, :desvotar, :comment, :reply]
  skip_before_action :verify_authenticity_token # no check token
  before_action :set_user_by_token

  # GET /contributions
  # GET /contributions.json
  def index
      @contributions = Contribution.all.order(points: :desc)
  end
def get_contributions
    nametype = params[:nametype]
  if (nametype == nil)
    @contributions = Contribution.all.order(created_at: :desc)
  elsif (nametype == "url") 
    @contributions = Contribution.all.where(text: nil).order(points: :desc)
  elsif (nametype == "ask")
    @contributions = Contribution.all.where(url: nil).order(points: :desc)
    

  else
    render :json => {"Error": "Type not allowed"}.to_json, status: 400
  end
end
  # GET /contributions/1
  # GET /contributions/1.json
  def show

  end
  
  def upvoted
    @aux = Array.new
    @user = User.find_by_api_key(request.headers[:HTTP_X_API_KEY])
    Contribution.all.each do |item|
      if item.voted && item.user != @user
        @aux.push(item)
      end
    end
    @contributions = @aux
  end

  # GET /contributions/submit
  def submit
    @contribution = Contribution.new
  end
  
  def newest
     @contributions = Contribution.all.order(created_at: :desc)
  end
  
  def ask
   @contributions = Contribution.all
  end
  
  def submitted
  
   @contributions = Contribution.all
  end

  # GET /contributions/1/edit
  def edit
  end
  
  def comment
      @contribution = Contribution.all
  end
  
  def get_comments
    @contribution = Contribution.find(params[:id])
     @comments = @contribution.comments.where(comment_id: nil).order(id: :asc)
  end
  
  def reply
      @contribution = Contribution.find(params[:id])
  end

  def newcomments
  end 

  # POST /contributions
  # POST /contributions.json
  def create
    #@contribution = Contribution.new(title: contribution_params[:title], url: contribution_params[:url], text: contribution_params[:text], user_id: current_user.id)
    if contribution_params[:title].blank?
      self.status = :Bad_Request
      self.response_body = { error: 'Title is void. Please try again.' }.to_json
    end
    require 'uri'
    if !contribution_params[:title].blank? 
      if !contribution_params[:url].blank? and contribution_params[:text].blank? and contribution_params[:url] =~ URI::regexp
        @contribution = Contribution.new(title: contribution_params[:title], 
        url: contribution_params[:url], user_id: current_user.id, nametype: "url", user_name: current_user.name)
      elsif !contribution_params[:text].blank? and contribution_params[:url].blank?
        @contribution = Contribution.new(title: contribution_params[:title], 
        text: contribution_params[:text], user_id: current_user.id, nametype: "ask", user_name: current_user.name)
      end
    end
    respond_to do |format|
      if !@contribution.nil? and @contribution.save
        format.html { redirect_to newest_path}
        format.json { render :show, status: :created, location: @contribution }
      elsif contribution_params[:title].blank?
        format.html { redirect_to submit_path, notice: 'Please try again. '}
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      elsif contribution_params[:url].blank? and contribution_params[:text].blank?
        format.html { redirect_to submit_path, notice: 'Submission without text or url. '}
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      elsif !contribution_params[:url].blank? and !contribution_params[:text].blank?
        format.html { redirect_to submit_path, notice: 'Submissions can not have both urls and text, so you need to pick one. If you keep the url, you can always post your text as a comment in the thread. '}
        format.json do
            self.status = 409
            self.response_body = { error: 'Submissions can not have both urls and text, so you need to pick one. If you keep the url, you can always post your text as a comment in the thread. ' }.to_json
         end
      else
        format.json do
            self.status = 406
            self.response_body = { error: 'URL does not accepted' }.to_json
         end
        format.html { redirect_to submit_path, notice: 'URL does not exist'}
      end
    end
  rescue #SQLite3::ConstraintException
    @contribution = Contribution.find_by(url: contribution_params[:url]) 
    if @contribution != nil 
      redirect_to :action => "show", :id => @contribution.id
    else
      self.status = 400
      self.response_body = { error: 'Please try again.' }.to_json
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def point
    if @contribution.user_id != current_user.id && @contribution.voted == false
      @contribution.voted = true
      @contribution.points += 1
      respond_to do |format|
        @contribution.save
        format.json { render :point, status: :ok }
        format.html { redirect_to request.referer}
      end
    else
      self.status = 403
      self.response_body = { error: 'Forbidden. You are voting your contribution or You have voted this contribution' }.to_json
    end
  end
  
  def sign_out
    reset_session
    session.clear
    redirect_to root_path
  end
  
  def desvotar
    if @contribution.user_id != current_user.id && @contribution.voted == true
      @contribution.voted = false
      if @contribution.points > 1
        @contribution.points -= 1
      end
      respond_to do |format|
        @contribution.save
        format.json { render :desvotar, status: :ok }
        format.html { redirect_to request.referer}
      end
    else
      self.status = 403
      self.response_body = { error: 'Forbidden. You can not unvote a contribution you did not vote' }.to_json
    end
  end
  
  def submitted
  end
  
  def threads
    @user = User.find_by_name(params[:id])
    if @user == nil
      self.status = :not_found
      self.response_body = { error: 'User Not Found' }.to_json
    else
      @comments = @user.comments
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contribution_params
    params.require(:contribution).permit(:title, :url, :text)
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
