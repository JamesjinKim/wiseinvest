Rails.application.routes.draw do
  # 인증
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [ :new, :create ]

  # 관리자
  namespace :admin do
    root "users#index"
    resources :users, only: [ :index, :show, :update ] do
      member do
        patch :suspend
        patch :unsuspend
      end
    end
  end

  # 대시보드 (루트)
  root "dashboard#show"
  get "dashboard", to: "dashboard#show", as: :dashboard

  # 종목 분석
  resources :stocks, only: [ :index, :show ] do
    member do
      get :analyze
    end
  end

  # 투자 기록
  resources :investment_records do
    collection do
      get :import
      post :import
    end
  end

  # 성향 분석
  resource :profile, only: [ :show ]
  resources :surveys, only: [ :index, :create ]

  # 헬스체크
  get "up" => "rails/health#show", as: :rails_health_check
end
