class UsersController < ApplicationController
  before_action :set_user, only: %i[show]

  def index
    @users = User.all.limit(5).includes(:reviews)
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
