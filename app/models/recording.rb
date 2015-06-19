class Recording < ActiveRecord::Base
	belongs_to :tuner

	validates :tuner, presence: { message: "There are already recordings schduled at this time" }
	validates :start_time, :end_time, :channel, presence: true
	validate  :end_time_is_after_start_time
	validate  :not_in_the_past

	after_create :schedule_for_recording

	def self.get_future_recordings_for_tuner(tuner_id)
		Recording.where('(tuner_id = ? AND start_time > ?)', tuner_id, Time.now).order(:start_time)
	end	

	def end_time_is_after_start_time
		if end_time < start_time
			errors.add(:end_time, "cannot be before start time")
		end
	end

	def check_for_open_tuner
		tuner1 = Recording.get_future_recordings_for_tuner(1)
		tuner2 = Recording.get_future_recordings_for_tuner(2)

		return Tuner.find(1) if tuner1.empty? || tuner_open?(tuner1)
		return Tuner.find(2) if tuner2.empty? || tuner_open?(tuner2)
		nil
	end

	def tuner_open?(tuner)
		if start_time < tuner.last.end_time && end_time > tuner.first.start_time
			return false
		end
		true
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
