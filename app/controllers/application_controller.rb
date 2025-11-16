class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  include Pagy::Backend
  include Pundit::Authorization

  before_action :set_current_request_details
  before_action :authenticate

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
    def current_user
      Current.user
    end

    def authenticate
      redirect_to login_path unless perform_authentication
    end

    def require_no_authentication
      return unless perform_authentication
      redirect_to root_path
    end

    def perform_authentication
      Current.session ||= Session.find_by_id(cookies.signed[:session_token])
    end

    def set_current_request_details
      Current.user_agent = request.user_agent
      Current.ip_address = request.ip
    end

    def user_not_authorized(exception)
      error_message = authorization_error_message(exception)
      redirect_back_or_to(root_path, alert: error_message)
    end

    def authorization_error_message(exception)
      policy = exception.policy
      policy_name = policy.class.to_s.underscore
      query = exception.query
      reason = policy.respond_to?(:error_reason) ? policy.error_reason(query) : nil

      query_key = "pundit.#{policy_name}.#{query}"
      global_default_key = "pundit.default"
      hardcoded_default = "You are not authorized to perform this action."

      # Build fallback chain: specific reason → query default → global default
      if reason
        t("#{query_key}.#{reason}",
          default: t("#{query_key}._",
            default: t(global_default_key, default: hardcoded_default)
          )
        )
      else
        t("#{query_key}._",
          default: t(query_key,
            default: t(global_default_key, default: hardcoded_default)
          )
        )
      end
    end
end
