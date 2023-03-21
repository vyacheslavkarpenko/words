json.extract! record, :id, :word, :transcription, :created_at, :updated_at
json.url record_url(record, format: :json)
