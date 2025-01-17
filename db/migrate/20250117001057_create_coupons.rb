class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :unique_code, null: false
      t.float :percent_off, precision: 5, scale: 2, default: 0.0
      t.float :dollar_off, precision:5, scale: 2, default: 0.0
      t.boolean :active, default: true

      t.timestamps
    end
    add_index :coupons, :unique_code, unique: true
  end
end
