class StaticPagesController < ApplicationController
  def contact
  end

  # TODO à brancher lorsque UserMailer sera créé
  def send_contact
    # envoi de confirmation à visiteur
    # user_email = UserMailer.visitor_contact_email(params[:static_pages]).deliver_now
    
    # envoi du message à l'admin
    # admin_email = UserMailer.admin_contact_email(params[:static_pages]).deliver_now
    
    # TODO : a supprimer lorsque le branchement sera fait
    admin_email = true
    user_email= true

    # flash
    if user_email && admin_email
      flash[:success] = "Votre message a bien été envoyé."
    else
      flash[:alert] = "Erreur lors de l'envoi. Veuillez recommencer."
    end
  redirect_to :contact
  end
end
