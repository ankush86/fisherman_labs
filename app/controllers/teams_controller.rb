class TeamsController < ApplicationController
	before_action :authenticate_user!

	def new
		@team = Team.new
		@monsters = current_user.monsters.available
	end

	def create
    respond_to do |format|
      @team = current_user.teams.build(team_params)
      if @team.save

        unless params[:monsters].blank?
          @monsters = Monster.where(id: params[:monsters])
          @monsters.update_all(team_id: @team.id)
        end

        format.html { redirect_to @team, notice: 'Your monster was successfully created.' }
        format.json { @team }
      else
        format.html { render action: 'new' }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
	end

  def index
    @teams = current_user.teams
  end

  def show
    @team = Team.find(params[:id])
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end
end
