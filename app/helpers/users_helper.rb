module UsersHelper
  def user_profile_name
    if @user == current_user
      "your"
    else
      @user.email_name + "'s"
    end
  end
end