class CalculationsController < ApplicationController
  def index
    # This action will just render the form
  end

  def calculate
    # Input parameters
    loan_amount = params[:loan_amount].to_f
    interest_rate = params[:interest_rate].to_f
    term = params[:term].to_i
    period = params[:period].to_i

    # Calculation logic
    monthly_interest_rate = interest_rate / 12 / 100
    total_months = term * 12
    period_months = period * 12

    monthly_payment = if (1 + monthly_interest_rate) ** total_months == 1
                        0
                      else
                        loan_amount * (monthly_interest_rate * (1 + monthly_interest_rate) ** total_months) / ((1 + monthly_interest_rate) ** total_months - 1)
                      end

    # Initialize variables for loop
    remaining_balance = loan_amount
    total_interest_period = 0
    total_principal_period = 0
    payments_schedule = []

    # Calculate monthly details for the period
    1.upto(period_months) do |month|
      monthly_interest = remaining_balance * monthly_interest_rate
      monthly_principal = monthly_payment - monthly_interest
      remaining_balance -= monthly_principal

      break if remaining_balance <= 0

      total_interest_period += monthly_interest
      total_principal_period += monthly_principal

      payments_schedule << { month: month, payment: monthly_payment, interest: monthly_interest, principal: monthly_principal, balance: remaining_balance }
    end

    calculation = MortgageCalculation.create(
      loan_amount: loan_amount,
      interest_rate: interest_rate,
      term: term,
      period: period,
      monthly_payment: monthly_payment,
      total_interest_period: total_interest_period,
      total_principal_period: total_principal_period
    )

    # Redirect to the results action with the ID
    redirect_to action: :results, id: calculation.id
  end

  def results
    @calculation = MortgageCalculation.find(params[:id])
  end
end
