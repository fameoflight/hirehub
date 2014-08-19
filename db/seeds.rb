# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# puts 'SETTING UP DEFAULT USER LOGIN'
# user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
# puts 'New user created: ' << user.name
# user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please', :confirmed_at => Time.now.utc
# puts 'New user created: ' << user2.name

User.create! :name => 'Demo' , :email => 'demo@hirehub.me',
    :password => 'hirehubadmin123' , :password_confirmation => 'hirehubadmin123',
    :organization => 'HireHub', :role => 'recruiter' , :confirmed_at => Time.now.utc

User.create! :name => 'Hemant Verma' , :email => 'hemantv@live.in',
    :password => 'india123' , :password_confirmation => 'india123',
    :organization => 'HireHub', :role => 'admin' , :confirmed_at => Time.now.utc
