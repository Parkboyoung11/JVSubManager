class AddViewsToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :views, :integer, :default => 0
  end
end
