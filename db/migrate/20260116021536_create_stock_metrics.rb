class CreateStockMetrics < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_metrics do |t|
      t.references :stock, null: false, foreign_key: true
      t.decimal :roe
      t.decimal :debt_ratio
      t.decimal :operating_margin
      t.decimal :per
      t.decimal :pbr
      t.integer :profit_growth_years
      t.date :data_date

      t.timestamps
    end
  end
end
