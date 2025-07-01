class RegistrationsController < InertiaController
  skip_before_action :authenticate, only: %i[new create]
  before_action :require_no_authentication, only: %i[new create]

  def new
    render inertia: "Auth/Register"
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session_record = @user.sessions.create!
      set_session_cookie(params[:remember_me], session_record)

      send_email_verification
      redirect_to root_path, notice: "Welcome! You have signed up successfully"
    else
      redirect_to register_path, inertia: inertia_errors(@user)
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end

    def set_session_cookie(remember_me, session_record)
        if remember_me
          cookies.signed.permanent[:session_token] = {
            value: session_record.id,
            httponly: true,
            secure: Rails.env.production?,
            same_site: :lax
          }
        else
          cookies.signed[:session_token] = {
            value: session_record.id,
            httponly: true,
            secure: Rails.env.production?,
            same_site: :lax,
            expires: 1.hour
          }
        end
      end
end
