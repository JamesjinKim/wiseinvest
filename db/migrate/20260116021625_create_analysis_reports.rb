class CreateAnalysisReports < ActiveRecord::Migration[8.1]
  def change
    create_table :analysis_reports do |t|
      t.references :stock, null: false, foreign_key: true
      t.integer :total_score, null: false
      t.jsonb :score_breakdown, default: {}
      t.datetime :expires_at

      t.timestamps
    end
  end
end
