json.feeds(@feeds) do |feed|
json.id feed.id
json.goal feed.goal
json.rule1 feed.rule1
json.rule2 feed.rule2
json.rule3 feed.rule3
json.rule4 feed.rule4
json.rule5 feed.rule5
json.misc feed.misc
json.description feed.description
json.lang feed.lang
json.stage feed.stage
json.created_at feed.created_at
json.updated_at feed.updated_at
  
  json.url feed_url(feed, format: :json)
end
