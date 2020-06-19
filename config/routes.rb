Rails.application.routes.draw do
  resources :contributions  do 
    member do
      put 'point'
    end
    member do
      put 'desvotar'
    end
     resources :comments
  end
  resources :comments  do 
    member do
      put 'vote'
    end
    member do
      put 'unvote'
    end
  end
  root 'contributions#index'
  post 'comments' => 'comments#create'
  get 'contributions' => 'contributions#index'
  get 'news' => 'contributions#index'
  get 'submit' => 'contributions#submit' 
  get 'newest' => 'contributions#newest'
  get 'threads' => 'contributions#threads'
  get 'item' => 'contributions#show'
  get 'ask' => 'contributions#ask'
  get 'submitted' => "users#submitted"
  get 'upvoted' => 'contributions#upvoted'
  get 'upvotedcomment' => "comments#upvotedcomments"
  get 'user' => "users#show"
  patch 'user' => "users#update"
  get 'newcomments' => "comments#newcomments"
  get 'reply' => "comments#add_comment"
  #links of api
  post 'api/v1/login' => "users#login"
  get 'api/v1/user' => "users#show"
  patch 'api/v1/user'  => "users#update"
  get 'api/v1/user/:id/submitted' => "users#submitted"
  get 'api/v1/user/:id/threads' => 'contributions#threads'
  get 'api/v1/user/upvoted' => 'contributions#upvoted'
  get 'api/v1/user/upvotedcomment' => "comments#upvotedcomments"
  get 'api/v1/comments' => 'comments#newcomments'
  post 'api/v1/comments' => 'comments#create'
  get 'api/v1/comments/:id' => 'comments#show'
  post 'api/v1/contributions'=> 'contributions#create'
  post 'api/v1/contributions/:id/vote' => 'contributions#point'
  delete 'api/v1/contributions/:id/vote' => 'contributions#desvotar'
  post 'api/v1/comments/:id/vote' => 'comments#vote'
  delete 'api/v1/comments/:id/vote' => 'comments#unvote'
  get 'api/v1/contributions' => 'contributions#get_contributions'
  get 'api/v1/contributions/:id' => 'contributions#show'
  get 'api/v1/contributions/:id/comments' => 'contributions#get_comments'
  get 'api/v1/comments/:id/replies' => 'comments#get_comments'
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks"}

end