class Contact < MailForm::Base
  attribute :name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    admin_email = User.find(1).user_email
    {
      :subject => "Workforce Management Contact Email",
      :to => "#{admin_email}",
      :from => %("#{name}" <#{email}>)
    }
  end
end
