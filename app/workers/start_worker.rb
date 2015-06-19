class StartWorker
	 include Sidekiq::Worker

	 def perform(channel, end_time)
	 	puts "now recording on channel #{channel}"
	 	EndWorker.perform_at(end_time, id)
	 end
end