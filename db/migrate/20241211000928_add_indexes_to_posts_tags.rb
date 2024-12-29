class AddIndexesToPostsTags < ActiveRecord::Migration[7.1]
  def change
    add_index :posts_tags, :post_id
    add_index :posts_tags, :tag_id
  end
end
