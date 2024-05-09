class CreateMortgageCalculations < ActiveRecord::Migration[7.1]
  def change
    create_table :mortgage_calculations do |t|
      t.decimal :loan_amount
      t.decimal :interest_rate
      t.integer :term
      t.integer :period
      t.decimal :monthly_payment
      t.decimal :total_interest_period
      t.decimal :total_principal_period

      t.timestamps
    end
  end
end
