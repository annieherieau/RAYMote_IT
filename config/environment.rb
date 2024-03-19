# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!


# Config SMTP : Mailjet
ActionMailer::Base.smtp_settings = {
  :user_name => ENV['MAILJET_LOGIN'],
  :password => ENV['MAILJET_PWD'],
  :domain =>  ENV['MAILJET_SENDER_DOMAIN'],
  :address => 'in-v3.mailjet.com',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}