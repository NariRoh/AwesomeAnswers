class CreateVotes < ActiveRecord::Migration[5.0]
  def change
    create_table :votes do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true
      t.boolean :is_up

      t.timestamps
    end
    # we call this type of index: composite index where we're indexing on
    # more than one field, it's a good idea to put such index if our queries
    # including both `user_id` and `question_id` in them.
    # add_index :votes, [:user_id, :question_id]
  end
end
