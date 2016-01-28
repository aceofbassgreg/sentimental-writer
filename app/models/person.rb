class Person < ActiveRecord::Base
  has_many :references
  has_many :tweets, through: :references
end
