json.feed @feed, :id, :goal, :rule1, :rule2, :rule3, :rule4, :rule5, :misc, :description, :lang, :stage, :created_at, :updated_at


json.posts(@posts) do |post| 
  json.extract! post, :id, :content, :feed_id, :status, :anonymity, :created_at, :updated_at
  if post.anonymity == "visible"
    json.creator do
      json.name post.creator.name 
    end
  end
  json.url post_url(post, format: :json)
end

