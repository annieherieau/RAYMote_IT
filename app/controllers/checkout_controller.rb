class CheckoutController < ApplicationController
  before_action :authenticate_user!
  
  # creation du checkout à partir du Workshop
  def create
    @workshop = Workshop.find(params[:workshop_id])
    @amount = @workshop.price.to_d
    @session = Stripe::Checkout::Session.create(
      payment_method_types: ['card'],
      line_items: [
        {
          price_data: {
            currency: 'eur',
            unit_amount: (@amount*100).to_i,
            product_data: {
              name: 'Rails Stripe Checkout',
            },
          },
          quantity: 1
        },
      ],
      metadata: {
        workshop_id: @workshop.id
      },
      mode: 'payment',
      success_url: checkout_success_url + '?session_id={CHECKOUT_SESSION_ID}',
      cancel_url: checkout_cancel_url(workshop_id: @workshop.id )
    )
    redirect_to @session.url, allow_other_host: true
  end


  def success
    # récupération des infos de session
    session_id = params[:session_id]
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)
    workshop_id = stripe_session.metadata["workshop_id"]
    @user = current_user
  
    if Workshop.find(workshop_id)
      ActiveRecord::Base.transaction do
        # inscription du User
        Attendance.create(user_id: @user.id, workshop_id: workshop_id)

        # création de l'Order: version sans panier
        @order = Order.create!(user_id: @user.id, date: Date.today)
        @order.add_workshops([workshop_id])
        @order.send_order_emails
      end
    else
      Rails.logger.error "L'évènement ID: #{workshop_id} n'a pas été trouvé!"
    end
  end
  
  def cancel
    @workshop = Workshop.find(params[:workshop_id])
  end
end
