require 'rails_helper'

RSpec.describe Recording, :type => :model do

	let!(:tuner) {Tuner.create!}
	let!(:recording) { Recording.create!(start_time: Time.now + 1.hour, end_time: Time.now + 4.hours, channel: 1, tuner: tuner )}

	describe "validation methods" do
		it "adds an error of the end time is set before the start time" do
			failed_recording =  Recording.new(start_time: Time.now + 1.hour, end_time: Time.now - 2.hours, channel: 1 )
			expect {failed_recording.save!}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it "fails if there is another recording scheduled at the same time" do
			failed_recording = Recording.new(start_time: Time.now + 2.hour, end_time: Time.now + 3.hours, channel: 1 )
			expect {failed_recording.save!}.to raise_error(ActiveRecord::RecordInvalid)
		end

		it "fails if start_time is set in the past" do
			failed_recording = Recording.new(start_time: Time.now - 2.hour, end_time: Time.now + 3.hours, channel: 1 )
			expect {failed_recording.save!}.to raise_error(ActiveRecord::RecordInvalid)			
		end
	end

	describe "class methods" do
		it "gets future recordings" do
			records = Recording.get_future_recordings_for_tuner(1)
			expect(records.count).to eq(1)
		end
	end
end
