# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Course.create(title: 'CS61A')
Course.create(title: 'CS61B')
Course.create(title: 'CS61C')
Course.create(title: 'CS170')
Course.create(title: 'CS169')
Course.create(title: 'CS162')
Course.create(title: 'CS168')

user = User.create! :email => 'test@berkeley.edu', :password => 'password', :password_confirmation => 'password'
user.skip_confirmation!
user.save

