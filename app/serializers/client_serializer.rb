class ClientSerializer < ActiveModel::Serializer
  attributes :id, :name, :role, :api_key
end
