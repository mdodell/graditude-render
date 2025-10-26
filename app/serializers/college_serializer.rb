# app/serializers/college_serializer.rb

class CollegeSerializer < BaseSerializer
  attributes :id, :name, :website, :created_at, :updated_at
end
