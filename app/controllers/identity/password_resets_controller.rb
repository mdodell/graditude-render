class Identity::PasswordResetsController < InertiaController
  skip_before_action :authenticate
  before_action :require_no_authentication

  before_action :set_user, only: %i[ edit update ]

  def new
    render inertia: "RequestForgotPassword"
  end

  def edit
    render inertia: "ResetPassword", props: { sid: params[:sid] }
  end

  def create
    email = params[:email].to_s.strip.downcase

    if email.blank?
      return redirect_to reset_password_path, inertia: { errors: { email: "Email can't be blank" } }
    end

    unless email.match?(URI::MailTo::EMAIL_REGEXP)
      return redirect_to reset_password_path, inertia: { errors: { email: "Invalid email format" } }
    end

    if @user = User.find_by(email: email, verified: true)
      send_password_reset_email
      redirect_to reset_password_path, notice: "Check your email for reset instructions"
    else
      redirect_to reset_password_path, inertia: { errors: { email: "You can't reset your password until you verify your email" } }
    end
  end

  def update
    if @user.update(user_params)
      redirect_to login_path, notice: "Your password was reset successfully. Please sign in"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find_by_token_for!(:password_reset, params[:sid])
    rescue StandardError
      redirect_to reset_password_path, alert: "That password reset link is invalid"
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset.deliver_later
    end
end
