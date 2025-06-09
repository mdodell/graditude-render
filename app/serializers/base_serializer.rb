# app/serializers/base_serializer.rb

class BaseSerializer < Oj::Serializer
    include TypesFromSerializers::DSL
  end