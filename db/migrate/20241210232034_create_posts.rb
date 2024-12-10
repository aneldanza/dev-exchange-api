class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :type
      t.references :user, foreign_key: true
      t.bigint :question_id

      t.timestamps
    end
  end
end
