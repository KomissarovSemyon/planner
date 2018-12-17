# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resources :meetings do
      resources :comments
    end
    devise_for :users
    get 'active-sessions', to: 'meetings#active_sessions'
    root to: 'home#index'
    resources :users, only: [:index]
  end
end
