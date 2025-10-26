# app/serializers/organization_serializer.rb

class OrganizationSerializer < BaseSerializer
  attributes :id, :name, :domain, :description, :created_at, :updated_at
  has_many :colleges, serializer: CollegeSerializer
end
