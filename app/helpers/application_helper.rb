module ApplicationHelper
  # formate le nombre en Euros
  def number_to_euros(number)
    return number_to_currency(number, unit: "€", separator: ",", format: "%n %u")
  end

  # Devise en français
  def devise_fr
    resource_name.to_s.humanize == 'User' ? 'Utilisateur' : 'Admin'
  end
end
