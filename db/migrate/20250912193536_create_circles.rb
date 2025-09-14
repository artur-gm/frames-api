class CreateCircles < ActiveRecord::Migration[8.0]
  def change
    create_table :circles do |t|
      t.references :frame, null: false, foreign_key: true, type: :bigint
      t.decimal :center_x, precision: 10, scale: 2
      t.decimal :center_y, precision: 10, scale: 2
      t.decimal :diameter, precision: 10, scale: 2

      t.timestamps
    end
  end
end
