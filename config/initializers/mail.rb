require 'smtp_tls'

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "sac.com",
  :user_name            => "javaplayer",
  :password             => "",
  :authentication       => "plain",
  :enable_starttls_auto => true
}