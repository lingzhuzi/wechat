Rails.application.routes.draw do
  namespace :wx do
    resources :apps
    resources :users
    resources :files
    resources :messages
  end

  match 'wechat/:id' => 'wx#index', via: [:get, :post]
end
