class CreateKeyWords < ActiveRecord::Migration
  def change
    create_table :key_words do |t|
      t.string :key
      t.text :content
      t.references :app, index: true

      t.timestamps
    end
  end
end
