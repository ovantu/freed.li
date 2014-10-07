json.array!(@posts) do |post|
  json.extract! post, :id, :content, :creator_id, :feed_id, :status
  json.url post_url(post, format: :json)
end
