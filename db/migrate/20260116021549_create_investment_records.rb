class CreateInvestmentRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :investment_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.string :action, null: false
      t.integer :quantity, null: false
      t.decimal :price, precision: 12, scale: 2, null: false
      t.datetime :traded_at, null: false
      t.string :reason_tags, array: true, default: []
      t.integer :pre_rating

      t.timestamps
    end
  end
end
