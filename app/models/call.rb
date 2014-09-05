class Call < ActiveRecord::Base
	require 'csv'

	#Associations
	belongs_to :employee

	#Callback
	before_save :set_call_duration

	#Validations
	#validates :employee_fname, :presence => true, length: { maximum:50 }
	#validates :call_startTime, :presence => true, Time.parse {"HH:mm"} 
	#validates :call_endTime, :presence => true, Time.parse {"HH:mm"}
	#validates :call_status, :presence => true, length: {maximum: 150}
	#validates :call_wait_period, :presence => true, Time.parse {"HH:mm"}
	#validates :employee_id, :presence => true
	#validates :call_status_id, :presence => true
	#validates :call_type_id, :presence => true

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			Call.create! row.to_hash
		end
	end

	def set_call_duration
		self.call_duration = self.call_endTime - self.call_startTime
	end

end
