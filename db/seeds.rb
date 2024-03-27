require 'faker'
require 'google/apis/youtube_v3'
require_relative './data.rb'

# Supprimer toutes les données existantes
Workshop.destroy_all
Admin.destroy_all
User.destroy_all
Category.destroy_all
Tag.destroy_all
Order.destroy_all
Review.destroy_all
Message.destroy_all
ActiveStorage::Attachment.all.each { |attachment| attachment.purge }

# reset ID 
ActiveRecord::Base.connection.tables.each do |t|
    ActiveRecord::Base.connection.reset_pk_sequence!(t)
  end 

puts ('---- START SEEDING ----')
VIDEOS.each do |cat, videos|
  puts cat
end


# User.create(email: "user01@annieherieau.fr", password: "password",firstname: "Créateur", lastname: "Supprimé", creator: false)
# puts "User anonyme créé (password : password)"

# # Création des utilisateurs avec Faker
# emails_with_names = {
#   'annie.herieau@gmail.com' => ['Annie', 'Herieau'],
#   'r.robena@gmail.com' => ['Robena', 'R.'],
#   'malo.bastianelli@gmail.com' => ['Malo', 'Bastianelli'],
#   'yann.rezigui@gmail.com' => ['Yann', 'Rezigui']
# }


# emails_with_names.each do |email, names|
#   user = User.create!(
#     email: email,
#     firstname: names[0],
#     lastname: names[1],
#     password: "1&Azert",
#     creator: [true, false].sample,
#     pending: false
#   )
#   #création d'un setting pour chaque user
#   Setting.create!(user: user)
# end
# puts('4 Users créés - creator aleatoires')

# # Création des admin
# emails_with_names.each do |email, names|
#   Admin.create!(
#     email: email,
#     password: "1&Azert"
#   )
# end
# puts ('4 admins créés (mail, password : 1&Azert)')

# Création des catégories
CATEGORIES.each do |name|
  category = Category.create!(name: name)
  category.icon.attach(io: File.open("app/assets/images/cat-icons/#{format('%02d', category.id)}.png'), filename: 'counter-01.png')
end

puts("Categories créés")

# # Création des ateliers avec Faker
# 20.times do
#   Workshop.create!(
#     name: Faker::Lorem.words(number: 3).join(' ')[0, 15], # Générer un nom de 3 mots et limiter à 15 caractères
#     description: Faker::Lorem.paragraph(sentence_count: 2),
#     price: rand(10..100),
#     start_date: Faker::Time.between(from: DateTime.now - 1, to: DateTime.now + 30),
#     duration: rand(1..3) * 60,
#     event: true,
#     creator: User.where(creator: true).sample,
#     category: Category.all.sample,
#     validated: [true, false].sample,
#     brouillon: false
#   )
# end
# puts('10 Workshops créés')

# # Création des tags
# tags = ["Débutant", "Intermédiaire", "Avancé", "DIY", "Loisir", "Professionnel"]
# tags.each do |name|
#   Tag.create!(name: name)
# end
# puts('6 tags créés')

# # Associer des tags aux ateliers
# Workshop.all.each do |workshop|
#   rand(1..3).times do
#     tag = Tag.all.sample
#     unless workshop.tags.include?(tag)
#       workshop.tags << Tag.all.sample
#     end  
#   end
# end

# # Création des participations
# User.all.each do |user|
#   rand(1..5).times do
#     workshop = Workshop.all.where(validated: true).sample
#     unless Attendance.find_by(user: user, workshop: workshop)
#       attendance = Attendance.create!(user: user, workshop: Workshop.all.sample)
#     end
#   end
# end
