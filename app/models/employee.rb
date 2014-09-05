class Employee < ActiveRecord::Base
	require 'csv'
	include SessionHelper

	#Associations
	belongs_to :user
	has_many :skills
	has_many :calls
	#accepts_nested_attributes_for :user

	#CallBacks - Things to be done before object is saved to database
	before_save { |employee| employee.employee_email = employee_email.downcase }
	#before_save :set_owner

	#REGEX for correct email format
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_NAME_REGEX =  /\A[a-zA-Z0-9_]*[a-zA-Z][a-zA-Z0-9_]*$/

	HUMANIZED_ATTRIBUTES = {
		:employee_fname => "First Name",
		:employee_lname => "Last Name",
		:employee_email => "Email Address",
		:employee_contact_num => "Contact Number"
	}

	#Validations
	validates :employee_fname, :presence => true, length: { maximum:25 }, format: { with: VALID_NAME_REGEX, :multiline => true }
	validates :employee_lname, :presence => true, length: { maximum:25 }, format: { with: VALID_NAME_REGEX, :multiline => true }
	validates :employee_email, :presence => true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
	validates :employee_contact_num, :presence => true, length: { minimum: 10, maximum:10 }
	validates :employee_started, :presence => true
	validates_numericality_of :employee_contact_num

	#Get Employee full name, for display purposes
	def full_name
		self.employee_fname.capitalize + " " + self.employee_lname.capitalize
	end

	def full_name_rev
		self.employee_lname.capitalize + ", " + self.employee_fname.capitalize
	end

	def set_owner
		self.user_id = current_user.id
	end

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			Employee.create! row.to_hash
		end
	end

	def self.search(query)
	  where("employee_lname || employee_fname like ?", "%#{query}%")
	end

	def self.human_attribute_name(attr, options={})
		HUMANIZED_ATTRIBUTES[attr.to_sym] || super
	end
	
end
