# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#   
CANDIDATES = [
  {
    first_name: "Donald",
    last_name:  "Trump"
  },
  {
    first_name: "Mark",
    last_name:  "Rubio"
  },
  {
    first_name: "Jeb",
    last_name:  "Bush"
  },
  {
    first_name: "Rand",
    last_name:  "Paul",
  },
  {
    first_name: "Ted",
    last_name:  "Cruz"
  },
  {
    first_name: "Ben",
    last_name:  "Carson"
  },
  {
    first_name: "Chris",
    last_name:  "Christie"
  },
  {
    first_name: "John",
    last_name:  "Kasich"
  }
]

CANDIDATES.each do |candidate|
  Person.where(first: candidate[:first_name], last: candidate[:last_name]).first_or_create
end

TOPICS = [
  "gun control",
  "abortion",
  "economy",
  "environment",
  "immigration",
  "mexico",
  "guns",
  "china",
  "iran",
  "iraq",
  "isis",
  "foreign policy",
  "jobs",
  "guns",
  "education",
  "national security",
  "social issues",
  "veterans",
  "gitmo",
  "tax",
  "minimum wage",
  "low wage",
  "hillary",
  "bernie"
]

TOPICS.each do |topic|
  Topic.where(name: topic).first_or_create
end