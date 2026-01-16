class CreateSurveyResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :survey_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :question_key
      t.integer :answer_value

      t.timestamps
    end
  end
end
