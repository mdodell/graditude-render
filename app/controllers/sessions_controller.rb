class SessionsController < InertiaController
  skip_before_action :authenticate, only: %i[ new create ]
  before_action :require_no_authentication, only: %i[ new create ]
  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    render inertia: "Login"
  end

  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      set_session_cookie(params[:remember_me])
      redirect_to root_path, notice: "Signed in successfully"
    else
      redirect_to login_path, inertia: {
        email: params[:email],
        password: params[:password],
        errors: {
          email: "That email or password is incorrect"
        }
      }
    end
  end

  def destroy
    @session.destroy; redirect_to(login_path, notice: "That session has been logged out")
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end

    def set_session_cookie(remember_me)
      if remember_me
        cookies.signed.permanent[:session_token] = {
          value: @session.id,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :lax
        }
      else
        cookies.signed[:session_token] = {
          value: @session.id,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :lax,
          expires: 1.hour
        }
      end
    end
end
