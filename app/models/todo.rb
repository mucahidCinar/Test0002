class Todo < ActiveRecord::Base
  validates :startDate, presence: true
  validates :endDate, presence: true
  validates :priority, presence: true
  validates :description, presence: true
  validates :status, presence: true
end
