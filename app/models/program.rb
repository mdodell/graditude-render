class Program < ApplicationRecord
  include Memberable, Invitable

  resourcify

  attr_accessor :created_by_user

  # Valid roles for program members
  VALID_ROLES = %w[member admin owner].freeze

  belongs_to :organization

  # Validations
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :organization, presence: true
  validates :description, length: { maximum: 500 }, allow_blank: true

  def default_rolify_role
    :member
  end

  after_create :set_owner

  private

  def set_owner
    if created_by_user
      add_member(created_by_user, :owner)
    end
  end

  def owners
    users.with_role(:owner, self)
  end
end
