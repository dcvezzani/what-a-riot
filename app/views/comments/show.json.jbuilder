json.extract! @comment, :id, :author_id, :recorded_on, :body, :created_at, :updated_at
json.recorded_on [ @comment.recorded_on.strftime("%Y"), @comment.recorded_on.strftime("%m"), @comment.recorded_on.strftime("%d"), @comment.recorded_on.strftime("%H"), @comment.recorded_on.strftime("%M") ]

