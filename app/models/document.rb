# Site wide documents
class Document < ActiveRecord::Base
  validates :title, presence: true
  validates :title, length: {maximum: 64}

  validates :link, presence: true
  validates :link, length: {maximum: 64}
end
