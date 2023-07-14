class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]

  def show
    @submissions = @user.submissions
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end