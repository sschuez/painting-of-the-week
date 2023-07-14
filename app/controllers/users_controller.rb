class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :submission]
  before_action :set_user, only: [:show]

  def show
    @submissions = @user.submissions
  end

  def submission
    @user = User.find(params[:id])
    authorize @user, :show?
    @submissions = @user.submissions.ordered_by_most_recent
    @submission = @submissions.find(params[:submission_id])
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