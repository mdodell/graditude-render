# app/serializers/organization_serializer.rb

class OrganizationSerializer < BaseSerializer
  attributes :id, :name, :domain, :description, :created_at, :updated_at
end
