module ApplicationHelper
  # formate le nombre en Euros
  def number_to_euros(number)
    return number_to_currency(number, unit: "€", separator: ",", format: "%n %u")
  end

  # Devise en français
  def devise_fr
    resource_name.to_s.humanize == 'User' ? 'Utilisateur' : 'Admin'
  end

  # formate les dates
  def date_format(date)
    date ? date.strftime("%d/%m/%Y %H:%M") : ''
  end

  def course_jsonld(workshop)
    {
      "@context": "https://schema.org",
      "@type": "Course",
      "name": workshop.name, 
      "description": workshop.description, 
      "creator": {
        "@type": "Person",
        "givenName": workshop.creator.firstname, 
        "familyName": workshop.creator.lastname, 
        "email": workshop.creator.email,
      },
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": workshop.average,
          },
      "dateCreated": workshop.created_at.iso8601, 
      "dateModified": workshop.updated_at.iso8601 
      
    }.to_json.html_safe
  end

  def event_jsonld(workshop)
    {
      "@context": "https://schema.org",
      "@type": "Event",
      "name": workshop.name, 
      "description": workshop.description, 
      "startDate": workshop.start_date, 
      "Duration": workshop.duration, 
      "organizer": {
        "@type": "Person",
        "givenName": workshop.creator.firstname, 
        "familyName": workshop.creator.lastname, 
      },
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": workshop.average,
          },
    }.to_json.html_safe
  end

  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :success
      "alert-success"
    when :error
      "alert-danger" # Classe Bootstrap pour les erreurs
    when :alert
      "alert-warning"
    when :notice
      "alert-info"
    else
      flash_type.to_s
    end
end  
end
