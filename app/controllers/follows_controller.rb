class FollowsController < ApplicationController
  before_action :set_user

  def create
    return head :bad_request if Current.user == @user

    if Current.user.follow @user
      respond_to do |format|
        format.html { redirect_to @user, notice: "Followed successfully" }
        format.turbo_stream do
          flash.now[:notice] = "Followed successfully"
          render turbo_stream: [
            turbo_stream.update(helpers.nested_dom_id(@user, Current.user, 'follow_status'), partial: 'users/follow_status'),
            helpers.render_turbo_stream_flash_messages
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @user, alert: "Follow failed" }
        format.turbo_stream do
          flash.now[:alert] = "Follow failed"
          render turbo_stream: helpers.render_turbo_stream_flash_messages
        end
      end
    end
  end

  def destroy
    return head :bad_request if Current.user == @user

    if Current.user.unfollow @user
      respond_to do |format|
        format.html { redirect_to @user, notice: "Unfollowed successfully" }
        format.turbo_stream do
          flash.now[:notice] = "Unfollowed successfully"
          render turbo_stream: [
            turbo_stream.update(helpers.nested_dom_id(@user, Current.user, 'follow_status'), partial: 'users/follow_status'),
            helpers.render_turbo_stream_flash_messages
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to @user, alert: "Follow failed" }
        format.turbo_stream do
          flash.now[:alert] = "Unfollow failed"
          render turbo_stream: helpers.render_turbo_stream_flash_messages
        end
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
