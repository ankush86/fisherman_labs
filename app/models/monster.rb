class Monster < ActiveRecord::Base
	belongs_to :user
	belongs_to :team
	before_save :check_count

	LIMIT = 20
	TYPE = {'fire' => 1, 'water' => 2, 'earth' => 3, 'electric' => 4, 'wind' => 5}

	validates :mtype, inclusion: {in: TYPE.keys}
	validates :name, uniqueness: true
	validates :name, presence: true

	scope :available, -> { where("team_id IS NULL") }

	private

	def check_count
		if Monster.where(user_id: self.user_id).count >= LIMIT
			self.errors.add(:base, "You have already created #{LIMIT} monsters") 
			return false
		end
		true
	end
end
