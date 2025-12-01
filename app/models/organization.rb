class Organization < ApplicationRecord
  has_and_belongs_to_many :colleges, join_table: :organization_colleges, dependent: :delete_all

  # Step validations for wicked wizard
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, on: :details
  validates :domain, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/ }, on: :details

  validate :must_have_college, on: :college

  validates :description, length: { maximum: 250 }, on: :description

  scope :with_colleges, -> { joins(:colleges).distinct }
  scope :without_colleges, -> { left_joins(:colleges).where(colleges: { id: nil }) }
  scope :by_college, ->(college) { joins(:colleges).where(colleges: { id: college.id }) }

  private

  def must_have_college
    errors.add(:colleges, "must be selected") if colleges.empty?
  end
end
