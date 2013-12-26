json.array!(@feeds) do |feed|
  json.extract! feed, :id, :goal, :rule1, :rule2, :rule3, :rule4, :rule5, :misc, :description, :lang, :status
  json.url feed_url(feed, format: :json)
end
