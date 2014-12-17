Rails.application.routes.draw do
  get 'home/index'

  get 'home/about_us'

  get 'home/contact_us'

  devise_for :users, class_name: "User"

  resources :apps
  resources :key_words
  resources :users
  resources :files
  resources :messages do
    collection do
      get 'all'
      post 'send_message'
    end
  end

  match 'wechat/:id' => 'wx#index', via: [:get, :post]
  match 'weixin_app' => 'wx#index', via: [:get, :post]

  root 'home#index'
end
