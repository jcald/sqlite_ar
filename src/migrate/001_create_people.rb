class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name, :limit => 32, :null => false
      t.date :birthdate
      t.timestamps
    end
    add_index :people, :name, :unique => true
  end

  def self.down
    drop_table :people
  end
end