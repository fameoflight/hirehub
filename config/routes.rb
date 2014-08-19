HireHub::Application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'

  resources :code_problems do
    member do
      get 'preview'
    end
  end
  resources :problems do
    member do
      get 'preview'
    end
  end

  resources :invites
  resources :collections
  resources :interviews
  resources :submissions do
    member do
      get 'preview'
    end
  end

  match 'admin_signin' => 'dashboard#admin_signin_user', :as => :admin_signin
  match 'request_invite' => 'home#request_invite', :as => :request_invite
  match 'grant_access/:beta_list_id' => 'dashboard#grant_access', :as => :grant_access
  match 'dashboard' => 'dashboard#home', :as => :dashboard_home
  match 'about' => 'home#about', :as => :about
  match 'contact' => 'home#contact', :as => :contact
  match 'demo' => 'home#demo', :as => :demo_signin
  match 'faq' => 'home#faq', :as => :faq
  match 'feedback' => 'home#feedback', :as => :feedback
  match 'recharge' => 'home#recharge_account', :as => :recharge
  match 'demo_register' => 'home#demo_register', :as => :demo_register

  match 'solve/finish/:url_hash' => 'invites#finish', :as => :invite_finish
  match 'solve/refresh/:url_hash' => 'invites#refresh_submissions', :as => :invite_refresh_submission
  match 'invite/agree/:url_hash' => 'invites#agree_submit', :as => :invite_agree
  match 'welcome/:url_hash' => 'invites#welcome_solve', :as => :welcome_solve
  match 'solve/:url_hash' => 'invites#solve', :as => :solve_invite
  match 'solve/:url_hash/:problem_id' => 'invites#solve_problem', :as => :invite_solve_problem
  match 'solve/code/:url_hash/:code_problem_id' => 'invites#solve_code_problem', :as => :invite_solve_code_problem

  match 'attend_interview/:url_hash' => 'interviews#attend', :as => :attend_interview
  match 'review_interview/:url_hash' => 'interviews#review', :as => :review_interview

  root :to => "home#index"

  authenticated :user do
    root :to => 'dashboard#home'
  end

  devise_for :users, :controllers => {:invitations => 'users/invitations'}
  resources :users, :only => :show
end
