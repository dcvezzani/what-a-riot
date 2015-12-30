json.array!(@comments) do |comment|
  json.extract! comment, :id, :author_id, :recorded_on, :body
  json.url comment_url(comment, format: :json)
end
