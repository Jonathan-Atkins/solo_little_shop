class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :name, null: false
      t.string :unique_code, null: false
      t.decimal :percent_off
      t.float :dollar_off

      t.timestamps
    end
  end
end
