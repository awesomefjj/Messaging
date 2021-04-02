Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get :healthz, to: 'application#healthz'
  mount API::Root => '/'
  mount GrapeSwaggerRails::Engine => '/api/tm-docs'
end
