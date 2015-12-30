class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author_id
      t.datetime :recorded_on
      t.text :body

      t.timestamps null: false
    end
  end
end
