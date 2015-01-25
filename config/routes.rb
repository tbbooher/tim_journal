Rails.application.routes.draw do

  get '/journal_entries/data(/:months)', to: 'journal_entries#data'
  put '/journal_entries/form_update/:id' => "journal_entries#form_update"
  get '/journal_entries/report(/:months)', to: 'journal_entries#report', as: :frequency_report

  get '/journal_entries/month_data(/:month_string)', to: 'journal_entries#month_data'
  get '/journal_entries/month_report(/:month_string)', to: 'journal_entries#month_report', as: :month_report
  get '/journal_entries/calendar_report(/:month_string)', to: 'journal_entries#calendar_report', as: :calendar_report

  resources :journal_entries

  resources :users

  root to: 'visitors#index'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
