json.array!(@recordings) do |recording|
  json.extract! recording, :id, :date, :time, :channel, :video
  json.url recording_url(recording, format: :json)
end
