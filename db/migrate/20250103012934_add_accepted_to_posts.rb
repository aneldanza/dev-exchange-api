class AddAcceptedToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :accepted, :boolean, default: false
  end
end
