json.array!(@employees) do |employee|
  json.extract! employee, :id, :employee_fname, :employee_lname, :employee_started, :employee_contact_num, :employee_email
  json.url employee_url(employee, format: :json)
end
