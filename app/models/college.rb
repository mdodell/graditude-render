class College < ApplicationRecord
  has_and_belongs_to_many :organizations, join_table: :organization_colleges

  validates :name, presence: true, uniqueness: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true

  scope :search, ->(query) { where("name ILIKE ?", "%#{query}%") }
  scope :with_organizations, -> { joins(:organizations).distinct }
  scope :without_organizations, -> { left_joins(:organizations).where(organizations: { id: nil }) }
end
