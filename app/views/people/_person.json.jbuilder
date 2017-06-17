json.extract! person, :id, :name, :age, :height, :remarks, :missing_date, :police_station, :police_reg_no, :reporter, :photo_url, :created_at, :updated_at
json.url person_url(person, format: :json)
