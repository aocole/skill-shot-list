class BaseSerializer < ActiveModel::Serializer
  attributes :id
  def id
    object.cached_slug
  end


end
