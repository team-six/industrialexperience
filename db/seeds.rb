
#======================================
# USER ROLES
#======================================

Role.create!([
	{ role_name: "admin" },
	{ role_name: "general" }
])


#======================================
# DEPARTMENTS
#======================================

Department.create!([
	{ dept_name: "administration"},
	{ dept_name: "accounting"},
	{ dept_name: "marketing"},
	{ dept_name: "human resources"},
	{ dept_name: "production"},
	{ dept_name: "sales"},
	{ dept_name: "technical"},
	{ dept_name: "information technology"}
])

dept_size = Department.all.size

#======================================
# EMPLOYEE STATUS TYPE
#======================================

EmployeeStatus.create!([
	{ es_type: "active" },
	{ es_type: "company leave" },
	{ es_type: "maternal leave" },
	{ es_type: "sick leave" },
	{ es_type: "compassionate leave" },
	{ es_type: "retrenched" }
])

es_size = EmployeeStatus.all.size

#======================================
# USERS
#======================================

User.create!([
	{
		user_fname: "lebron", 
		user_lname: "james", 
		user_email: "admin@team-six.com",
		role_id: 1,
		sign_in_count: 0,
		password: "password",
		password_confirmation: "password",
		department_id: 1
	},
	{
		user_fname: "thabo",
		user_lname: "titus",
		user_email: "ttitus@team-six.com",
		role_id: 2,
		sign_in_count: 0,
		password: "password",
		password_confirmation: "password",
		department_id: 1 + rand(dept_size)
	},
	{
		user_fname: "tafadzwa", 
		user_lname: "banda", 
		user_email: "tbanda@team-six.com", 
		role_id: 2,
		sign_in_count: 0,
		password: "password",
		password_confirmation: "password",
		department_id: 1 + rand(dept_size)
	},
	{
		user_fname: "tafadzwa", 
		user_lname: "chiura", 
		user_email: "tchiura@team-six.com", 
		role_id: 2,
		sign_in_count: 0,
		password: "password",
		password_confirmation: "password",
		department_id: 1 + rand(dept_size)
	},
	{
		user_fname: "tanaka", 
		user_lname: "marufu", 
		user_email: "tmarufu@team-six.com", 
		role_id: 2,
		sign_in_count: 0,
		password: "password",
		password_confirmation: "password",
		department_id: 1 + rand(dept_size)
	},
	{
		user_fname: "mohammed", 
		user_lname: "aliyu", 
		user_email: "maliyu@team-six.com",
		role_id: 2,
		sign_in_count: 0,
		password: "password",
		password_confirmation: "password",
		department_id: 1 + rand(dept_size)
	}
])

#======================================
# RELIGIONS
#======================================

Religion.create!([
	{religion_name: "christian"},  	
	{religion_name: "islam"},				
	{religion_name: "hindu"},				
	{religion_name: "buddhist"},		
	{religion_name: "judaism"},			
	{religion_name: "zion"},				
	{religion_name: "atheism"}			
]) 

religion_size = Religion.all.size

##=======================================================
## Employee Generator
##=======================================================

## Avoid clashing emails
email_index = 1
user_size = User.all.size

first_names = ["william","miguel","mason","ethan","logan", "lucas", "owen", "bob","noah","pedro",
"louis","kendra","stewie","glenn","patricia","mary","sally","jane","megan","sarah","jovan","grace","london","mpho"]

last_names = ["brown","wilson","jackson","davis","white","lopez","miller","jones","walker","nelson",
"green","quagmire","harris","chiura","banda","titus","marufu","griffin","young", "hill","kelly","retief","burges"]
 	

312.times do
	fname = 1 + rand(first_names.length) -1
	lname = 1 + rand(last_names.length) -1
	religion = 1 + rand(religion_size)
	status = 1 + rand(es_size)
	user = 1 + rand(user_size)
	  		
 	Employee.create! ([{
		employee_fname: first_names[fname],
		employee_lname: last_names[lname],
		employee_started: Time.now,
		employee_contact_num: "0117896547",
		employee_email: first_names[fname] + last_names[lname] + email_index.to_s + "@team-six.com",
		user_id: user,
		religion_id: religion,
		employee_status_id: status
	}])

	email_index = email_index + 1
end

##=======================================================
## Call Generator
##=======================================================
 
current_time = Time.now
emp_size = Employee.all.size

8000.times do	
	#Up To 1 year ago
	benchmark_time = current_time - (1 + rand(31536000)) 
	# Max call time of 20 minutes 		
	minutes = 60 * (1 + rand(25))
	# Employee IDs ranging from 1 - 19		
	employee = 1 + rand(emp_size)		
	# Max wait time of 5 mins(300 secs)		
	call_wait = 1 + rand(300) 
	# Boolean Value	(0 or 1)
	call_status = 1 + rand(2) - 1

	Call.create! ([{		
		call_starttime: benchmark_time,
		call_endTime: benchmark_time + minutes,
		employee_id: employee,
		call_wait_period: call_wait,
		call_status_id: call_status
	}])
end



  



