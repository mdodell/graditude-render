module Invitable
  extend ActiveSupport::Concern

  # Define an optional, general default role
  DEFAULT_ROLE = :member

  # This block is executed when the concern is included in a model
  included do
    # You could put shared associations here if they were always the same, e.g.:
    # has_many :memberships
    # has_many :users, through: :memberships
    # resourcify

    # NOTE: Since the default_rolify_role needs to be specific, we define
    # a method here that can be overridden.
  end

  # Provide a fallback implementation for the default role
  def default_rolify_role
    raise NotImplementedError, "Subclass must implement default_rolify_role"
  end
end
