class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :available_copies
end
