class CreateWxMessages < ActiveRecord::Migration
  def change
    create_table :wx_messages do |t|
      t.string :title
      t.text :content
      t.text :original
      t.string :message_type
      t.string :event
      t.string :event_key
      t.string :to_user_name
      t.string :from_user_name
      t.integer :msg_id
      t.references :file, index: true
      t.references :app, index: true
      t.references :author, index: true

      t.timestamps
    end
  end
end
