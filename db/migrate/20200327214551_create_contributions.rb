class CreateContributions < ActiveRecord::Migration[6.0]
  def change
    create_table :contributions do |t|
      t.string :title
      t.string :url
      t.text :text
      t.integer :points, default: 1
      t.string :nametype
      t.references :user, null: false, foreign_key: t
      t.string :type
      t.boolean :voted, default: false
      t.string :user_name, null: false
      t.timestamps
    end      
  end
end
