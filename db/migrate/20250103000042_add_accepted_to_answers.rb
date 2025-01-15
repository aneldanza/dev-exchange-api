class AddAcceptedToAnswers < ActiveRecord::Migration[7.1]
  def change
    add_column :answers, :accepted, :boolean
  end
end
