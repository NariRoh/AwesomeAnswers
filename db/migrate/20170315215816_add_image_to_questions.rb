class AddImageToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :image, :string
  end
end

# rails g uploader image
# rails g migration add_image_to_questions image
