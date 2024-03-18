class CheckoutController < ApplicationController

  # creation du checkout à partir du Workshop
  def create
    @workshop = Workshop.find(params[:id])
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
      cancel_url: checkout_cancel_url
    )
    redirect_to @session.url, allow_other_host: true
  end


  def success
    session_id = params[:session_id]
    stripe_session = Stripe::Checkout::Session.retrieve(session_id)
    cart_id = stripe_session.metadata["workshop_id"]
    @user = current_user

    @workshop = Workshop.find(workshop_id)
  
    if @workshop
      ActiveRecord::Base.transaction do
        @order = Order.create!(user: @user)
        # TODO order: lien workshop + amount
        @order.send_order_emails
      end
    else
      Rails.logger.error "Workshop not found with ID: #{workshop_id}"
    end
  end
  
  def cancel
  end
end
