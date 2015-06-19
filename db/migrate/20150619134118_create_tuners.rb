class CreateTuners < ActiveRecord::Migration
  def change
    create_table :tuners do |t|

      t.timestamps null: false
    end
  end
end
