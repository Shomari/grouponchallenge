class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
    	t.datetime   :start_time
    	t.datetime   :end_time
      t.integer    :channel
      t.binary     :video
      t.belongs_to :tuner

      t.timestamps null: false
    end
  end
end
