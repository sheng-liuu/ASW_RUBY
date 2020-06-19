class CreateUsers < ActiveRecord::Migration[6.0]
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :showdead, default: "no"
      t.string :noprocrast, default: "no"
      t.string :about, default: ""
      t.integer:maxvisit, default: 20
      t.integer :minaway, default: 180
      t.integer :delay, default: 0
      t.integer :karma, default: 1
      t.timestamps
    end
  end
  
  def down 
    drop_down :users 
  end
end
