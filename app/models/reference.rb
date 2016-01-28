class Reference < ActiveRecord::Base
  belongs_to :tweet
  belongs_to :person
end
