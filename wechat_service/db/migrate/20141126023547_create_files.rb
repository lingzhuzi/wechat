class CreateFiles < ActiveRecord::Migration
  def change
    create_table :files do |t|
      t.string :file_name
      t.integer :file_size
      t.string :mime_type
      t.string :digest
      t.text :description
      t.references :app, index: true

      t.timestamps
    end
  end
end
