class MachineSerializer < ActiveModel::Serializer
  attributes :id
  has_one :title
end
