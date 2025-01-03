class ChangeAcceptedDefaultInAnswers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :answers, :accepted, false
  end
end
