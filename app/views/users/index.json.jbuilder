json.array!(@users) do |user|
  json.extract! user, :id, :user_fname, :user_lname
  json.url user_url(user, format: :json)
end
