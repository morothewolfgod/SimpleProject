# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Seeding..."
puts "Creating User..."
users = User.create!([{
    email: "test@gmail.com",
    password: "123456"
    }])

  users.each_with_index do |user, index|
    user.id = index
    user.save
  
end

puts "User created..."
puts "Creating Projects..."

projects = Project.create!([{
    name: "Project 1",
    description: "Project description 1",
    user_id: 0
  },
  {
   name: "Project 2",
   description: "Test Product description 2",
   user_id: 0
  }])
    projects.each_with_index do |project, index|
    project.id = index
    project.save
  
end

puts "Projects created..."
puts "Creating Tasks..."

Task.create!([{
    name: "Task 1 for Project 1",
    description: "Task 1 for Project 1 description",
    status: "not-started",
    project_id: 0
  },
  {
  name: "Task 2 for Project 1",
    description: "Task 2 for Project 1 description",
    status: "in-progress",
    project_id: 0
  },
  {
  name: "Task 2 for Project 1",
    description: "Task 2 for Project 1 description",
    status: "complete",
    project_id: 0
  },
  {
    name: "Task 1 for Project 2",
    description: "Task 1 for Project 2 description",
    status: "not-started",
   project_id: 1
  },
 {
  name: "Task 2 for Project 2",
  description: "Task 2 for Project 2 description",
  status: "in-progress",
  project_id: 1
},
{
 name: "Task 3 for Project 2",
  description: "Task 2 for Project 2 description",
  status: "complete",
  project_id: 1
}])

  puts "Tasks created..."

puts "Seeding done..."


  


# Task.create!([{
#     sku: 1,
#     name: "Tasks 1 For Project 1",
#     description: "Tasks 1 Description For Project 1",
#     status: " ",
#     project_id: 1
#     }])
 
