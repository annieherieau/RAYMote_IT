class Attendance < ApplicationRecord
    belongs_to :workshop
    belongs_to :user
end
