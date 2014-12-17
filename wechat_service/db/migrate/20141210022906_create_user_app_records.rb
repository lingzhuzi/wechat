class CreateUserAppRecords < ActiveRecord::Migration
  def change
    create_table :user_app_records do |t|
      t.references :app, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
