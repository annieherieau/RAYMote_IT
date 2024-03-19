module OrdersHelper

  # Méthode affichage statut commande dans la view
  def display_order_status(order)
    case order.status
    when 'pending'
      'En attente'
    when 'completed'
      'Terminée'
    when 'cancelled'
      'Annulée'
    else
      'Statut inconnu'
    end
  end

  # Méthode affichage montant total d'une commande
  def display_order_amount(order)
    number_to_currency(order.amount)
  end

  # Méthode affichage détails d'une commande dans une liste
  def order_details_list(order)
    content_tag(:ul) do
      concat content_tag(:li, "Statut : #{display_order_status(order)}")
      concat content_tag(:li, "Montant total : #{display_order_amount(order)}")
      concat content_tag(:li, "Date de création : #{order.created_at}")
      concat content_tag(:li, "Cours : #{order.workshops.map(&:name).join(', ')}")
      concat content_tag(:li, "ID de commande : #{order.id}")
      # etc...
    end
  end
end

