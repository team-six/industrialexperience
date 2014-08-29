class User < ActiveRecord::Base

	## Associations
	has_many :employees
	has_many :calls, through: :employees

	## Password Encryption using BCrypt
	has_secure_password

	## CallBacks - Things to be done before object is saved to database
	before_save { |user| user.user_email = user_email.downcase }
	before_save :create_remember_token
	after_initialize :set_pass, :set_defaults

	#REGEX for correct email format
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_NAME_REGEX =  /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/

	HUMANIZED_ATTRIBUTES = {
		:user_fname => "First Name",
		:user_lname => "Last Name",
		:user_email => "Email Address"
	}

	## Validations
	validates :user_fname, :presence => true, length: { maximum:25 }, format: { with: VALID_NAME_REGEX, :multiline => true }
	validates :user_lname, :presence => true, length: { maximum:25 }, format: { with: VALID_NAME_REGEX, :multiline => true }
	validates :user_email, :presence => true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :password, :presence => true, length: { minimum: 8 }
	validates :password_confirmation, :presence => true

	## Get users full name, for display purposes
	def full_name
		self.user_fname.capitalize + " " + self.user_lname.capitalize
	end
	## Increment User login count
	def increment_login
		current_count = self.sign_in_count
		self.sign_in_count = current_count + 1
		self.save
	end
	
	def self.human_attribute_name(attr, options={})
		HUMANIZED_ATTRIBUTES[attr.to_sym] || super
	end
	
	private
	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end

	def set_pass
		if self.new_record? && self.password.nil?
			pass = SecureRandom.hex(4)
			self.password = pass
			self.password_confirmation = pass
		end
	end

	def set_defaults
		if self.new_record?
			self.sign_in_count = 0
		end
	end
end
