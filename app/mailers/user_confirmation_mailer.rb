class UserConfirmationMailer < ActionMailer::Base
  default from: "admin@team-six.com"

  def confirmation_mail (user)
  	@user = user
	  mail(to: user.user_email, from: "Team Six", subject: 'Team-Six WFMS | A New Account Has Been Created For You')
	end
end
