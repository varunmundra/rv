class CreateOccupationMasters < ActiveRecord::Migration
  def change
    create_table :occupation_masters do |t|
      t.string :description
      t.string :cams_code
      t.string :karvy_code
      t.timestamps
    end
  end
end
