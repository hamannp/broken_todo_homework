class Project < ActiveRecord::Base
  include SoftDelete

  validates :title, presence: true, uniqueness: true
  has_many :items, dependent: :destroy, inverse_of: :project
end
