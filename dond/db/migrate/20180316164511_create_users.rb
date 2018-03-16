# Class for creating Users, that are stored in the database.

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :username 
      t.string :password
      t.boolean :isAdmin
      t.integer :gamesPlayed
      t.float :totalWinnings
      t.integer :gamesWon
      t.string :lastGameState
      t.timestamps null: false 
    end
      User.create(username: "Admin", password: "admin", isAdmin: true, gamesPlayed: 0, totalWinnings: 0.0, gamesWon: 0, lastGameState: "-") # Creating an Admin account.
  end
end