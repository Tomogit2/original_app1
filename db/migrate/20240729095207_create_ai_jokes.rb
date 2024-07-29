class CreateAiJokes < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_jokes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :joke, null: false, foreign_key: true
      t.text :generated_joke

      t.timestamps
    end
  end
end
