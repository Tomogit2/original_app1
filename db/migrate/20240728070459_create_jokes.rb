class CreateJokes < ActiveRecord::Migration[7.0]
  def change
    create_table :jokes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category_id, null: false
      t.string :input_text1, null: false
      t.string :input_text2, null: false

      t.timestamps
    end
  end
end
