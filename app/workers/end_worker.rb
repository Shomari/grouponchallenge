class EndWorker
	include Sidekiq::Worker

	def perform(id)
		puts "stoping recording id #{id}"
	end
end