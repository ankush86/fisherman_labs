class AddTeamIdToMonsters < ActiveRecord::Migration
  def change
  	add_column :monsters, :team_id, :integer
  end
end
