class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :movie_id

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :movie_id
    add_index :favorites, [:user_id, :movie_id], unique: true
  end
end
