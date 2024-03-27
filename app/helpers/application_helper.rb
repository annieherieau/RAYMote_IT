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

  def workshop_jsonld(workshop)
    {
      "@context": "http://schema.org",
      "@type": "Course",
      "name": workshop.name,
      "description": workshop.description,
      "author": {
        "@type": "Person",
        "name": workshop.creator
      },
      # Ajout d'autres propriétés ici selon les besoins
    }.to_json.html_safe
  end
end
