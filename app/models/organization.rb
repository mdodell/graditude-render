class Organization < ApplicationRecord
  has_and_belongs_to_many :colleges, join_table: :organization_colleges

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }, on: :step1
  validates :domain, presence: true, uniqueness: true,
            format: { with: /\A[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\z/ }, on: :step1
  validates :description, length: { maximum: 250 }, on: :step2

  def valid?(context = nil)
    if context.nil?
      super(:create) && super(:update) && super(:step1) && super(:step2)
    else
      super
    end
  end

  scope :with_colleges, -> { joins(:colleges).distinct }
  scope :without_colleges, -> { left_joins(:colleges).where(colleges: { id: nil }) }
  scope :by_college, ->(college) { joins(:colleges).where(colleges: { id: college.id }) }
end
