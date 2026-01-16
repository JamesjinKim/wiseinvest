class CreateInvestmentProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :investment_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :survey_score
      t.integer :actual_score
      t.string :risk_tolerance
      t.jsonb :biases, default: {}

      t.timestamps
    end
  end
end
