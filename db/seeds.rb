require 'faker'
Faker::Config.locale='fr'
Faker::UniqueGenerator.clear
require 'google/apis/youtube_v3'
require 'open-uri'
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
# Création des catégories
def seed_categories
  CATEGORIES.each do |name, url|
    category = Category.create!(name: name)
    category.icon.attach(io: File.open(url), filename: url.split('/').last)
  end
  puts("#{CATEGORIES.length} Categories créés")
end

# Création des tags
def seed_tags
  TAGS.each do |name|
    Tag.create!(name: name)
  end
  puts("#{TAGS.length} tags créés")
end

# Associer des tags aux ateliers
def seed_assign_tags(workshop)
  rand(1..3).times do
    tag = Tag.all.sample
    unless workshop.tags.include?(tag)
      workshop.tags << Tag.all.sample
    end  
  end
end

# Création des admin
def seed_admins
  RAYM_TEAM.each do |email, names|
    Admin.create!(
      email: email,
      password: "1&Azert"
    )
  end
  puts ("#{RAYM_TEAM.length} Admin créés (password : 1&Azert)")
end

# Création du Creator supprimé
def seed_anonymous
  anonymous = User.create(email: "user01@annieherieau.fr", password: "password",firstname: "Créateur", lastname: "Supprimé", creator: true)
  puts "1 Créateur anonyme créé (password : password)"
  Setting.create!(user: anonymous)
  anonymous.avatar.attach(io: File.open('app/assets/images/raym_team/anonymous.avif'), filename: 'anonymous.avif')
end

# Création des utilisateurs
def seed_users
  seed_anonymous

  # team raym
  RAYM_TEAM.each do |email, names|
    user = User.create!(
      email: email,
      firstname: names[0],
      lastname: names[1],
      password: "1&Azert",
      creator: [true, false].sample,
      pending: false
    )
    #création d'un setting pour chaque user
    Setting.create!(user: user)
  end

  AVATARS.each do |avatar|
    user = User.create!(
      email: Faker::Internet.unique.email,
      password: "1&Azert",
      creator: [true, false].sample,
      pending: false
    )
    if user.creator
      user.update_attribute(:firstname, Faker::Name.first_name)
      user.update_attribute(:lastname, Faker::Name.last_name)
    end
    #création d'un setting pour chaque user
    Setting.create!(user: user)
  end
  puts("#{RAYM_TEAM.length + AVATARS.length + 1 } Users créés")
end


# Création des ateliers avec Youtube API
def seed_courses

  # Appel de l'API
  youtube = Google::Apis::YoutubeV3::YouTubeService.new
  youtube.key = ENV['YOUTUBE_KEY']

  VIDEO_DATA.each do |category, videos|
    videos.each do |video_id|

      # requête pour une video (snippet)
      video_response = youtube.list_videos('snippet', id: video_id)
      video = video_response.items.first.snippet

      # infos extraites du snippet
      workshop = Workshop.create!(
        name: video.title[0..99],
        description: video.description[0..500],
        price: rand(0..30),
        event: false,
        creator: User.where(creator: true).sample,
        category: Category.find_by(name: category),
        brouillon: [true, false].sample,
      )
      unless workshop.brouillon
        workshop.update_attribute(:validated, [true, false].sample)
      end

      # Lien vers la video
      CourseItem.create!(
        link: "https://www.youtube.com/watch?v=#{video_id}",
        workshop: workshop
      )
      # photo
      cover_image_url = video.thumbnails.high.url
      workshop.photo.attach(io: URI.open(cover_image_url), filename: cover_image_url.split('/').last)

      # tags
      seed_assign_tags(workshop)
    end
  end
  puts("#{VIDEO_DATA.length} Workshops Cours créés")
end

def seed_events
  10.times do |i|
    workshop = Workshop.create!(
      name: Faker::Lorem.words(number: rand(3..8)).join(' ')[0, 99], # Générer un nom limiter à 99 caractères
      description: Faker::Lorem.paragraph(sentence_count: rand(4..8)),
      price: rand(0..50),
      start_date: Faker::Time.between(from: DateTime.now + 1, to: DateTime.now + 30),
      duration: rand(1..30) * 5,
      event: true,
      creator: User.where(creator: true).sample,
      category: Category.all.sample,
      brouillon: [true, false].sample,
    )

    unless workshop.brouillon
      workshop.update_attribute(:validated, [true, false].sample)
    end

    # Lien vers le live
    CourseItem.create!(
      link: "https://www.youtube.com/",
      workshop: workshop
    )
    # photo
    cover_image_path = 'app/assets/images/course-01.jpg'
    workshop.photo.attach(io: File.open(cover_image_path), filename: cover_image_path.split('/').last)

    # tags
    seed_assign_tags(workshop)
  end

  puts("10 Workshops Events créés")
end

# # Création des participations
def seed_attendances
  User.all.each do |user|
    rand(1..5).times do
      workshop = Workshop.all.where(validated: true).sample
      unless Attendance.find_by(user: user, workshop: workshop)
        attendance = Attendance.create!(user: user, workshop: Workshop.all.sample)
      end
    end
  end
end


def perform
  seed_categories
  seed_tags
  seed_admins
  seed_users
  seed_courses
  seed_events
end


perform