Rails.application.routes.draw do
  root 'calculations#index'
  post 'calculate', to: 'calculations#calculate'
  get 'results', to: 'calculations#results'
end
