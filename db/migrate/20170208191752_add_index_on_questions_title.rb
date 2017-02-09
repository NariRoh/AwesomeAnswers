class AddIndexOnQuestionsTitle < ActiveRecord::Migration[5.0]
  def change
    # add_index :questions, [:title, :body]
    add_index :questions, :title
  end
end
