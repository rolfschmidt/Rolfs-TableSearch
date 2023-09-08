# Copyright (C) 2012-2023 Zammad Foundation, https://zammad-foundation.org/

Zammad::Application.routes.draw do
  api_path = Rails.configuration.api_path

  match api_path + '/tables', to: 'tables#all', via: :get
  match api_path + '/tables/:table', to: 'tables#index', via: :get
  match api_path + '/tables/:table/columns', to: 'tables#columns', via: :get
  match api_path + '/tables/:table/:id', to: 'tables#show', via: :get
end
