class Item < ActiveRecord::Base
  include SoftDelete

  # The original wrapper method was fine, but this alternative was the standard
  # in my last shop.  I would follow whatever was the standard at Cofense.
  delegate :title, to: :project, prefix: true

  belongs_to :project, inverse_of: :items

  validates :action,
    presence: true,
    uniqueness: { scope: :project_id,
                  message: 'should be unique within a project' }

  validates :project, presence: true

  # Note : Not a good candidate for an index since the field is a boolean and
  # there are only 2 possible values
  scope :complete, -> { where(done: true) }

end
