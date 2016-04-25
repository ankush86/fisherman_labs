class Monster < ActiveRecord::Base
	belongs_to :user
	belongs_to :team

	TYPE = {'fire' => 1, 'water' => 2, 'earth' => 3, 'electric' => 4, 'wind' => 5}

	validates :mtype, inclusion: {in: TYPE.keys}
	validates :name, uniqueness: true
	validates :name, presence: true

	scope :available, -> { where("team_id IS NULL") }
end
