class Recording < ActiveRecord::Base
	validates :start_time, :end_time, :channel, presence: true
	validate  :end_time_after_start_time
	validate  :not_in_the_past
	validate  :no_other_recordings

	after_create :schedule_for_recording

	def self.get_future_recordings
		Recording.where('(start_time > ?)', Time.now).order(:start_time)
	end	

	def end_time_after_start_time
		if end_time < start_time
			errors.add(:end_time, "cannot be before start time")
		end
	end

	def no_other_recordings
		recordings = Recording.get_future_recordings
		return if recordings.empty?		
		if start_time < recordings.last.end_time && end_time > recordings.first.start_time
			errors.add(:start_time, "there is already a recording set for this time")
		end
	end

	def not_in_the_past
		if start_time < Time.now
			errors.add(:start_time, "cannot set recordings for past shows")
		end
	end

	def schedule_for_recording
		StartWorker.perform_at(self.start_time, self.id, self.channel, self.end_time)
	end

end
