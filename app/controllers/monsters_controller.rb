class MonstersController < ApplicationController
	before_action :authenticate_user!
	before_action :check_monster_count, only: [:new, :create]

	def new
		@monster = Monster.new
	end

	def create
    respond_to do |format|
      @monster = current_user.monsters.build(monster_params)
      if @monster.save
        format.html { redirect_to @monster, notice: 'Your monster was successfully created.' }
        format.json { @monster }
      else
        format.html { render action: 'new' }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
	end

	def edit
		@monster = Monster.find(params[:id])
	end

	def update
    respond_to do |format|
      @monster = Monster.find(params[:id])
      if @monster.update(monster_params)
        format.html { redirect_to @monster, notice: 'Your monster was successfully created.' }
        format.json { @monster }
      else
        format.html { render action: 'edit' }
        format.json { render json: @monster.errors, status: :unprocessable_entity }
      end
    end
	end

	def index
    respond_to do |format|
      @monsters = current_user.monsters   
      format.html { render action: 'index'}
      format.json { @monsters }
    end
	end

	def show
		@monster = Monster.find(params[:id])
	end

	def destroy
		respond_to do |format|
			@monster = current_user.monsters.find(params[:id])   
			if @monster.destroy
				format.html { redirect_to monsters_path, notice: 'Your monster was successfully deleted.'}
				format.json { head :no_content }
			else
				format.html { render action: 'new' }
				format.json { head :no_content }
			end
		end
	end

	private

	def monster_params
		params.require(:monster).permit(:name, :mtype, :power)
	end

	def check_monster_count
		if current_user.check_monster_count?
			flash[:notice] = "You have alredy created #{Monster::LIMIT} monsters."
		end
	end
end
