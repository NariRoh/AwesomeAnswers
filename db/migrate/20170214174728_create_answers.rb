class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.text :body
      # t.references will generate an integer field called `question_id` to help
      # us associates answers with questions. The `foreign_key: true` option
      # create a DB constraint
      # The `index: true` option adds an index on the `question_id` field on
      # the answers table. We are likely to run queries like:
      # SELECT * FROM answers WHERE question_id=14;
      # the query above will be a lot faster with an index on `question_id`
      # having index: slower writes faster reads 
      t.references :question, foreign_key: true, index: true

      t.timestamps
    end
  end
end
