class RegistrationsController < Devise::RegistrationsController
  
  def update
    respond_to do |format|
      if current_user.update(user_params)
        
        format.html { render :edit, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end
  
  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end
    
  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:about, :showdead, :noprocrast, :maxvisit, :minaway, :delay)
    end
end