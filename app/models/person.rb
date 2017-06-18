class Person < ApplicationRecord
  validates :name, :age, :height, :remarks, :missing_date, :reporter, presence: true
  validates :name, format: { with: /\A[[a-zA-Z]+\s*[a-zA-Z]+]+\z/, message: "should only be letters" }
  validates :reporter, length: { in: 10..12 }, numericality: { only_integer: true }
  validates :age, numericality: { only_integer: true }
  validates :height, length: { is: 3 }, numericality: true
  
  mount_uploader :avatar, AvatarUploader
end
