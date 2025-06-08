# app/serializers/user_serializer.rb

class UserSerializer < BaseSerializer
  attributes :email, :verified, :created_at, :updated_at
end