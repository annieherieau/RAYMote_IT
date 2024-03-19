class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILJET_DEFAULT_FROM']
  default to: ENV['DEFAULT_ADMIN_EMAIL']
  layout "mailer"

  def application_url
    if Rails.env.production?
      ENV["PROD_HOST"]
    else
      ENV["DEV_HOST"]
    end
  end
end

