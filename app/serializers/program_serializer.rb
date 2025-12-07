# app/serializers/program_serializer.rb

class ProgramSerializer < BaseSerializer
  attributes :id, :name, :description, :organization_id, :created_at, :updated_at
  belongs_to :organization, serializer: OrganizationSerializer
end
