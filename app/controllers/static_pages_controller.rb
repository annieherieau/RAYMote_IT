class StaticPagesController < ApplicationController
  def contact
  end

  # TODO à brancher lorsque UserMailer sera créé
  def send_contact
    # envoi de confirmation à visiteur
    # user_email = UserMailer.visitor_contact_email(params[:static_pages]).deliver_now
    
    # envoi du message à l'admin
    # admin_email = UserMailer.admin_contact_email(params[:static_pages]).deliver_now

    # redirection + messages
    # if user_email && admin_email
    #   redirect_to :contact, success: "Votre message a bien été envoyé." 
    # else
    #   redirect_to :contact, alert: "Erreur lors de l'envoi. Veuillez recommencer."
    # end

  end
end
