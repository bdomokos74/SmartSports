json.array!(@elements) do |cf|
  json.extract! cf, :id, :property_code, :defaults
end
