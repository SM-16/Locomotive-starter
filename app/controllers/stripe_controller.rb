class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token, only: %i[webhook]
    
    def starter_checkout
        @session = Stripe::Checkout::Session.create({
            mode:"payment",
            success_url: root_url,
            cancel_url: root_url,
            customer: current_user.stripe_customer_id,
            line_items:[{
                price:"price_1Ql4PZKa5vbvZR8Vok1makVP",
                quantity: 1,
            }]
        })
        redirect_to @session.url, status: 303, allow_other_host: true
    end
    def premium_checkout
        @session = Stripe::Checkout::Session.create({
            mode:"payment",
            success_url: root_url,
            cancel_url: root_url,
            customer: current_user.stripe_customer_id,
            line_items:[{
                price:"price_1Ql4QkKa5vbvZR8Vyid1OQzT",
                quantity: 1,
            }]
        })
        redirect_to @session.url, status: 303, allow_other_host: true
    end
    

    def webhook

        Stripe.api_key = ENV["STRIPE_SECRET_API_KEY"]
        Stripe.api_version = '2024-06-20'

        # This is your Stripe CLI webhook secret for testing your endpoint locally.
        endpoint_secret = ENV["STRIPE_SIGNING_SECRET"]


            payload = request.body.read
            sig_header = request.env['HTTP_STRIPE_SIGNATURE']
            event = nil

            begin
                event = Stripe::Webhook.construct_event(
                    payload, sig_header, endpoint_secret
                )
            rescue JSON::ParserError => e
                # Invalid payload
                status 400
                return
            rescue Stripe::SignatureVerificationError => e
                # Invalid signature
                status 400
                return
            end
            case event.type
                when 'customer.subscription.deleted'
                    stripe_subscription = event.data.object
                    @user = User.find_by(stripe_customer_id: stripe_subscription.customer)
    
                    @user.update(plan: "Free")
                    
                when 'customer.subscription.updated'
                    stripe_subscription = event.data.object
                    if stripe_subscription.amount_total == 5900
                        @user.update(plan: "starter")
                    elsif stripe_subscription.amount_total == 1500
                        @user.update(plan: "starter")
                    elsif stripe_subscription.amount_total == 7700
                        @user.update(plan: "premium")
                    end
                    @user.update(plan: "starter")
                    puts "aaaaaaaaaaaaaaaaaaaaaaaa"
                    
                when 'checkout.session.completed'
                    session = event.data.object
                    @user = User.find_by(stripe_customer_id: session.customer)

                    if session.amount_total == 3900
                        @user.update(plan: "starter")
                    elsif session.amount_total == 1500
                        @user.update(plan: "starter")
                    elsif session.amount_total == 7700
                        @user.update(plan: "premium")
                    end

                    
                else
                    puts "Unhandled event type: #{event.type}"
                end


            # Handle the event

    end
end

  