class AddForeignKeysToTagsUsers < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :tags_users, :tags, on_delete: :cascade
    add_foreign_key :tags_users, :users, on_delete: :cascade
  end
end
