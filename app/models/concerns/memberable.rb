# app/models/concerns/memberable.rb
module Memberable
  extend ActiveSupport::Concern

  # The `included` block runs when the module is included in a model.
  included do
    # 1. Membership Association (The Polymorphic Part)
    # This defines the "has many" side of the polymorphic association.
    # `as: :memberable` links this model to the memberable_type/id columns in the Membership table.
    # `dependent: :destroy` ensures all memberships are deleted if the Program/Organization is deleted.
    has_many :memberships, as: :memberable, dependent: :destroy

    # 3. User Association (Convenience Method)
    # This provides a clean way to access the users who are members of this entity.
    has_many :users, through: :memberships
  end

  class_methods do
    # Example class method: Find entities where a specific user is a member.
    def find_by_user(user)
      joins(:memberships).where(memberships: { user_id: user.id })
    end
  end
end
