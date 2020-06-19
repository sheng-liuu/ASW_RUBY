class CommentsController < ApplicationController
  before_action :set_user_by_token
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy, :point, :new, :submit, :comment, :reply, :vote, :create], unless: -> { request.format.json? }
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :vote, :unvote]
  

  def index
      @comments = Comment.all
    
  end
  
  def comment
    @comment = Comment.all
  end
  
  def show
    @comment = Comment.all
  end
  
  def edit
  end
  
  def reply
     @comment = Comment.find(params[:id])
     render :show
  end

  def show
  end
  
  def newcomments
      @comments = Comment.all.order(created_at: :desc)
  end 

  def new
      @comment = Comment.new
  end 
  
  # POST /comments
  # POST /comments.json
  def create
    if comment_params[:comment_id].blank? 
      @comment = Comment.new(content: comment_params[:content],user_id: comment_params[:user_id],
      contribution_id: comment_params[:contribution_id], user_name: current_user.name)
    else
      @comment = Comment.new(content: comment_params[:content],user_id: comment_params[:user_id], user_name: current_user.name,
      contribution_id: comment_params[:contribution_id], comment_id: comment_params[:comment_id])
    end
    
    respond_to do |format|
        if @comment.save and comment_params[:comment_id].blank? 
          format.html { redirect_to item_path id: @comment.contribution}
          format.json { render :show, status: :created, location: @comment}
        elsif @comment.save
          format.html { redirect_to item_path id: @comment.contribution}
          format.json { render :show, status: :created, location: @comment}
        else 
          format.html { redirect_to item_path id: @comment.contribution }
          format.json { render json: @comment.errors, status: :bad_request }
        end
    end
  rescue #SQLite3::ConstraintException
      self.status = 404
      self.response_body = { error: 'Comment not exist' }.to_json
  end
  
  def get_comments
    @comment = Comment.find(params[:id])
    @comments = @comment.comments
  end

def update
    respond_to do |format|
      if @comment.update(contribution_params)
        format.html { redirect_to @comment, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
end
def upvotedcomments
  @aux = Array.new
  @user = User.find_by_api_key(request.headers[:HTTP_X_API_KEY])
  Comment.all.each do |item|
    if item.voted && item.user != @user
      @aux.push(item)
    end
  end
  @comments = @aux
end
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def vote
    if @comment.user_id != current_user.id && @comment.voted == false
      @comment.voted = true
      @comment.points += 1
      respond_to do |format|
        @comment.save
        format.json { render :vote, status: :ok }
        format.html { redirect_to request.referer}
      end
    else
      self.status = 403
      self.response_body = { error: 'Forbidden. You are voting your comment or You have voted this comment' }.to_json 
    end
  end
  
  def unvote
    if @comment.user_id != current_user.id && @comment.voted == true
      @comment.voted = false
      if @comment.points > 1
        @comment.points -= 1
      end
      respond_to do |format|
        @comment.save
        format.json { render :unvote , status: :ok}
        format.html { redirect_to request.referer}
      end
    else
      self.status = 403
      self.response_body = { error: 'Forbidden. You can not unvote a comment you did not vote' }.to_json 
    end
  end
  
  def add_comment
    @comment = Comment.find(params[:id])
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:content, :user_id, :contribution_id, :comment_id)
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