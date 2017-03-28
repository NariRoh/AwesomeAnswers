class AddSlugToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :slug, :string
    add_index :questions, :slug, unique: true
  end
end

# rails g friendly_id
# rails g migration add_slug_to_questions slug:string:uniq
