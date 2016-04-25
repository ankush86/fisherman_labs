class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
			t.string :name
			t.string :power
			# type is a reserved column
			t.string :mtype
			t.integer :user_id
      t.timestamps null: false
    end
  end
end
