require 'faker'
Faker::Config.locale='fr'
Faker::UniqueGenerator.clear
require 'google/apis/youtube_v3'
require 'open-uri'
require_relative './data.rb'

# Supprimer toutes les données existantes
def seed_reset
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

  puts ('drop and reset all tables')
end

# Boolean random avec un ratio true. exple 70% de true
def boolean_ratio(percent=50)
  ratio = percent.to_f/100
  Faker::Boolean.boolean(true_ratio: ratio)
end

# créer des fake identities 
def fake(email='')
  email = Faker::Internet.unique.email if email ==''
  name = (email.split('@').first).split('.')
  firstname = name.first
  lastname = name.length == 2 ? name.last : (email.split('@').last).split('.').first
  { email: email, 
  firstname: firstname.capitalize,
  lastname: lastname.capitalize
  }
end

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

# mettre à jour les nom et prénom du user
def seed_name(user)
  user.update_attribute(:firstname, fake(user.email)[:firstname])
  user.update_attribute(:lastname, fake(user.email)[:lastname])
end

# demandes pour devenir créateur
def seed_creator_requests(number)
  users = User.where(creator: false).take(number)

  users.each do |user|
    # ajouter le nom du creteur
    seed_name(user)
    # création de la demande
    user.update_attribute(:pending, true)
    
    # message aux Admin
    Admin.find_each do |admin|
      admin.inbox.messages.create!(
        body: Faker::Lorem.paragraph(sentence_count: rand(2..5)),
        sender: user,
        receiver: admin
      )
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
  user = User.create(email: "user01@annieherieau.fr", password: "password",firstname: "Créateur", lastname: "Supprimé", creator: true)

  # avatar
  user.avatar.attach(io: File.open('app/assets/images/raym_team/anonymous.avif'), filename: 'anonymous.avif')
  puts "1 Créateur anonyme créé (password : password)"
end

# Création des utilisateurs
def seed_users
  seed_anonymous

  # team raym
  RAYM_TEAM.each do |email, infos|
    user = User.create!(
      email: email,
      firstname: infos[0],
      lastname: infos[1],
      password: "1&Azert",
      creator: boolean_ratio,
      pending: false
    )
    # avatar
    user.avatar.attach(io: File.open(infos[2]), filename: infos[2].split('/').last)
  end

  # autres utilisateurs
  i = 0
  AVATARS.each do |avatar_file|
    email = Faker::Internet.unique.email
    user = User.create!(
      email: email,
      password: "1&Azert",
      creator: i<6 ? true : false,
      pending: false
    )
    # aouter le nom du createur
    seed_name(user) if user.creator

    # avatar
    user.avatar.attach(io: File.open("app/assets/images/#{avatar_file}"), filename: avatar_file)
    i += 1
  end
  puts("#{RAYM_TEAM.length + AVATARS.length + 1 } Users créés")
  
end
# Création des inscription
def seed_attendances(workshop)
  # sélection des users inscrits
  attendees = User.all.take(rand(4..12))

  attendees.each do |user|
    # exclure le Cretaor et User anonymous
    next if user == workshop.creator || user.id == 1

    # inscription
    Attendance.create!(user: user, workshop: workshop)
    
    # création de l'Order si payant
    if workshop.price > 0
      order = Order.create!(user: user, date: Date.today)
      order.add_workshops([workshop.id])
    end

    # Ajout d'un Avis (review)
    if boolean_ratio(70)
      seed_reviews(user, workshop)
    end
  end
end


# Ajouter les Reviews (Avis)
def seed_reviews(user, workshop)
  Review.create!(
    rating: rand(3..5),
    content: Faker::Lorem.paragraph(sentence_count: rand(2..5)),
    user: user,
    workshop: workshop
  )
end
# Procedure de publication
def seed_publish(workshop)
  # ajouter les tags
  seed_assign_tags(workshop)

  # exclure les brouillons
  return false if workshop.brouillon
  
  # statut attente de validation ou validé
  workshop.update_attribute(:validated, boolean_ratio(70))

  # Ajouter les inscription + Avis
  seed_attendances(workshop)
end

# Création des Cours avec Youtube API
def seed_courses

  # Appel de l'API
  youtube = Google::Apis::YoutubeV3::YouTubeService.new
  youtube.key = ENV['YOUTUBE_KEY']

  # Extraction des données de la vidéo pour créer le Workshop
  VIDEO_DATA.each do |category, videos|
    videos.each do |video_id|

      # requête pour une video (snippet)
      video_response = youtube.list_videos('snippet', id: video_id)
      video = video_response.items.first.snippet

      # infos extraites du snippet pour créer le workshop
      workshop = Workshop.create!(
        name: video.title[0..99],
        description: video.description[0..500],
        price: boolean_ratio ? 0 : rand(1..30), # 50% gratuit
        event: false,
        creator: User.where(creator: true).sample,
        category: Category.find_by(name: category),
        brouillon: boolean_ratio(30),
      )

      # Lien vers la video
      CourseItem.create!(
        link: "https://www.youtube.com/watch?v=#{video_id}",
        workshop: workshop
      )
      # photo
      cover_image_url = video.thumbnails.high.url
      workshop.photo.attach(io: URI.open(cover_image_url), filename: cover_image_url.split('/').last)

      # Publication
      seed_publish(workshop)

    end
  end
  puts("#{Workshop.where(event:false).count} COURS créés dont #{Workshop.where(event:false, validated: true).count} publiés")
end   

# Création des Ateliers evènements (live_broadcasts de notre channel youtube)
def seed_events

  # Appel de l'API
  youtube = Google::Apis::YoutubeV3::YouTubeService.new
  youtube.key = ENV['YOUTUBE_KEY']
  channel_id = ENV['CHANNEL_ID']

  # extraire les videos de la chaine
  list_response = youtube.list_searches('snippet', channel_id: channel_id, max_results: 20)
  # garder les ids des videos
  video_ids = list_response.items.map { |item| item.id.video_id }.compact

  # extraire les infos de chaque video et créer l'event
  video_ids.each do |video_id|

    # infos de la video (snippet)
    snippet_response = youtube.list_videos('snippet', id: video_id)
    video = snippet_response.items.first.snippet

   
    
    # infos du live associé : liveStreamingDetails
    stream_response = youtube.list_videos('liveStreamingDetails', id: video_id)
    live = stream_response.items.first

    #  date de début du live (scheduled_start_time)
    start_date = live.live_streaming_details.scheduled_start_time

    # exclure si start_date passée
    next if start_date < DateTime.now

    workshop = Workshop.create!(
        name: video.title,
        description: video.description,
        price: boolean_ratio ? 0 : rand(1..30), # 50% gratuit
        event: true,
        start_date: start_date,
        duration: 360, # 6h pour les tests
        creator: User.where(creator: true).sample,
        category: Category.find_by(name: video.tags.first),
        brouillon: false,
        validated: true
      )

      # Lien vers le live
      CourseItem.create!(
        link: "https://www.youtube.com/watch?v=#{video_id}",
        workshop: workshop
      )
      
      # photo
      cover_image_url = video.thumbnails.standard.url
      workshop.photo.attach(io: URI.open(cover_image_url), filename: cover_image_url.split('/').last)

      # Publication
      seed_publish(workshop)

  end
  puts("#{Workshop.where(event:true).count} LIVES créés et publiés")
end




def perform
  puts ('---- START SEEDING ----')
  seed_reset
  seed_categories
  seed_tags
  seed_admins
  seed_users
  seed_creator_requests(4)
  # seed_courses
  # seed_events
  puts ("#{Attendance.count} Attendances créées")
  puts ("#{Review.count} Reviews créés")
  puts ("#{Order.count} Orders créés")
  puts ("#{User.where(pending: true).count} demandes de compte créateur créés + messages aux Admins")
  puts ('---- END SEEDING ----')
end


perform
