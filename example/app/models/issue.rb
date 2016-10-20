class Issue < ApplicationRecord
  extend Enumerize

  belongs_to :project
  belongs_to :creator, class_name: 'User'

  validates :title, presence: true

  STATUS_MAP = {
    draft: 0,
    opened: 1,
    closed: 2,
  }.freeze
  enumerize :status, in: STATUS_MAP

end