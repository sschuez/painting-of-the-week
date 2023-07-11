class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy]
  before_action :check_if_user_has_already_submitted_this_week, only: [:new, :create]
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @submissions_last_week = policy_scope(Submission).last_week
    @submissions_before_last_week = policy_scope(Submission).week_before_last_week
  end

  def new
    @submission = Submission.new
    authorize @submission
  end

  def create
    @submission = Submission.new(submission_params)
    authorize @submission

    @submission.user = current_user

    if @submission.save
      respond_to do |format|
        format.html { redirect_to submissions_path, notice: "Submission was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Submission was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
    
  def show
  end

  def edit
  end

  def update
    submission_params_with_image = submission_params[:file] == "" ? submission_params.except(:file) : submission_params

    if @submission.update(submission_params_with_image)
      respond_to do |format|
        format.html { redirect_to submissions_path, notice: "Submission was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Submission was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def check_if_user_has_already_submitted_this_week
    if current_user&.already_submitted_this_week?
      flash.alert = 'You have already submitted this week. Please edit your current submission.'
      redirect_to submissions_path
    end
  end

  def set_submission
    @submission = Submission.find(params[:id])
    authorize @submission
  end

  def submission_params
    params.require(:submission).permit(:title, :description, :file)
  end
end
