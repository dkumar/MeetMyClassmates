class Message < ActiveRecord::Base
  belongs_to :studygroup
  belongs_to :user
end
