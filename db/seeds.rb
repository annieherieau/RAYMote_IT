require 'faker'

# Supprimer toutes les données existantes
Attendance.destroy_all
Workshop.destroy_all
Tag.destroy_all
Category.destroy_all
User.destroy_all

# Création des utilisateurs avec Faker
10.times do
    firstname = Faker::Name.first_name
    lastname = Faker::Name.last_name
    email = "#{firstname.downcase}.#{lastname.downcase}@gmail.com"
  
    User.create!(
      firstname: firstname,
      lastname: lastname,
      email: email,
      password: "password",
      creator: [true, false].sample
    )
  end

# Création des catégories
categories = ["JavaScript", "Python", "Ruby", "Java", "C++", "C#", "Swift", "Go", "PHP", "TypeScript"]
categories.each do |name|
  Category.create!(name: name)
end

# Création des ateliers avec Faker
20.times do
  Workshop.create!(
    name: Faker::Lorem.words(number: 3).join(' ')[0, 15], # Générer un nom de 3 mots et limiter à 15 caractères
    description: Faker::Lorem.paragraph(sentence_count: 2),
    price: rand(10..100),
    start_date: Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 30),
    duration: rand(1..3) * 60,
    event: Faker::Boolean.boolean(true_ratio: 0.7), # 70% chance of being an event
    creator: User.where(creator: true).sample,
    category: Category.all.sample
  )
end

# Création des tags
tags = ["Débutant", "Intermédiaire", "Avancé", "DIY", "Loisir", "Professionnel"]
tags.each do |name|
  Tag.create!(name: name)
end

# Associer des tags aux ateliers
Workshop.all.each do |workshop|
  rand(1..3).times do
    workshop.tags << Tag.all.sample
  end
end

# Création des participations
User.all.each do |user|
  rand(1..5).times do
    attendance = Attendance.new(user: user, workshop: Workshop.all.sample)
    attendance.save if attendance.valid?
  end
end
