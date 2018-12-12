class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :description, :limit => 5000
      t.string :image, :limit => 100
      t.string :name, :limit => 100
      t.string :language, :limit => 5

      t.timestamps
    end
  end
end
