Rails.configuration.stripe = {
  publishable_key: ENV['PUBLISHABLE_KEY'],
  secret_key: ENV['SECRET_KEY']
}


Stripe.api_key = Rails.application.credentials[:stripe][:secret]