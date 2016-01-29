class Person < ActiveRecord::Base
  has_many :references
  has_many :tweets, through: :references

  scope :excluding, ->(person) { where.not(id: person.id) }

  def name
    "#{first} #{last}"
  end
end
