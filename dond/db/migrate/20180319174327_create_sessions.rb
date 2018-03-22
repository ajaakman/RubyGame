# Class for creating Sessions, that are stored in the database.

class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :user 
      t.string :sequence
      t.string :selectedboxes
      t.string :amounts
      t.integer :chosenbox
      t.integer :selectedbox
      t.timestamps null: false 
    end
      Session.create(user: "Guest", sequence: "", selectedboxes: "", amounts: "", chosenbox: 0, selectedbox: 0) # Test.      
  end
end
