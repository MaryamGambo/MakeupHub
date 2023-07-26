# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://127.0.0.1:3000' # Replace '*' with the domain(s) you want to allow, or configure it based on your requirements.
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'], # Add any additional headers you want to expose
      max_age: 3600 # Set the maximum age (in seconds) for CORS preflight requests.
  end
end
