module StaticPagesHelper

  # permet de préremplir le contact fporm avec les coordonnés du user connecté
  def contact_values
    if current_user 
      name = current_user.firstname
      email = current_user.email
    else
      name =''
      email =''
    end
    contact_values = {
      name: name,
      email: email
    }
  end

end
