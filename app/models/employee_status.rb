class EmployeeStatus < ActiveRecord::Base
    has_many :employees

    def collect
        employee_statuses=es_type.find(:all)
    end
end
