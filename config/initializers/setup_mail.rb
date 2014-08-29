#config.action_mailer.raise_delivery_errors = true 

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
	:address        => 'smtp.gmail.com',
	:domain         => 'mail.google.com',
	:port           => 587,
	:user_name      => 'teamsixproject2014@gmail.com',
	:password       => 'osama2014',
	:authentication => :plain,
	:enable_starttls_auto => true
}