class Skill < ActiveRecord::Base
	#Associations
	has_many :employees
end
