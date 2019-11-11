# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :line, default: { format: :json } do
    resources :messages, only: :create
  end
end
