class Settings < ActiveRecord::Base
	# Associations
	belongs_to :user 

	# Validations
	validates :service_level, :numericality => { :greater_than => 0,  :less_than_or_equal_to => 100 }
	validates :expected_success, :numericality => { :greater_than => 0,  :less_than_or_equal_to => 100 }
	validates :expected_employee_success, :numericality => { :greater_than => 0,  :less_than_or_equal_to => 100 }
	validates :target_answer_time, :numericality => { :greater_than => 0,  :less_than_or_equal_to => 300 }
end
