class AddAnswerIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :answer_id, :bigint
    add_index :posts, :question_id
    add_index :posts, :answer_id
  end
end
