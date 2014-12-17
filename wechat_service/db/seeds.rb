# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin  = User.create(email: 'yanghui@yunfis.com', password: '123456789', password_confirmation: '123456789')
wx_app = App.create(name: 'Test', wx_id: 'gh_079e4a51cb6b', app_id: 'wx61c261c9671359d9',secret: '2c7b61b0034b4a1b554eac642f6660b8', token: 'yunfis_infobox')
UserAppRecord.create(app_id: wx_app.id, user_id: admin.id)