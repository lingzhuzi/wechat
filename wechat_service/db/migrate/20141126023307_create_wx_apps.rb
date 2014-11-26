class CreateWxApps < ActiveRecord::Migration
  def change
    create_table :wx_apps do |t|
      t.string :name
      t.references :icon, index: true
      t.string :wx_id
      t.string :app_id
      t.string :token
      t.string :access_token
      t.text :sceret
      t.datetime :refreshed_at

      t.timestamps
    end
  end
end
