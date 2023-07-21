Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  sceret_key: ENV['SECRET_KEY']
}


Stripe.api_key = R