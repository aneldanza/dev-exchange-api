class RemoveAcceptedFromAnswers < ActiveRecord::Migration[7.1]
  def change
    remove_column :answers, :accepted, :boolean
  end
end
