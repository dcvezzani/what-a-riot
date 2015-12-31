json.array!(@comments) do |comment|
  json.extract! comment, :id, :author_id, :recorded_on, :body
  json.recorded_on comment.recorded_on.strftime("%Y-%m-%d %H:%M")
  json.url comment_url(comment, format: :json)
end
