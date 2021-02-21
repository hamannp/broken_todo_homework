class Project < ActiveRecord::Base
  validates :title, :presence => true
  has_many :items, dependent: :destroy, inverse_of: :project
end
