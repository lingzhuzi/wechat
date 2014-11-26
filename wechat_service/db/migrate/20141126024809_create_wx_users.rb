class CreateWxUsers < ActiveRecord::Migration
  def change
    create_table :wx_users do |t|
      t.string :nick_name
      t.string :remark_name
      t.string :open_id
      t.references :app, index: true
      t.references :avatar, index: true
      t.text :description

      t.timestamps
    end
  end
end
