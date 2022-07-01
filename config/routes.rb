Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :passwords, :registrations]

  as :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
    
    #sessions
    get    '/entrar',         to: 'devise/sessions#new',            as: :new_user_session
    post   '/entrar',         to: 'devise/sessions#create',         as: :user_session
    # get    '/sair',           to: 'devise/sessions#destroy',        as: :destroy_user_session
    delete '/sair',           to: 'devise/sessions#destroy',        as: :destroy_user_session

    #passwords
    get    '/nova-senha',       to: 'devise/passwords#new',           as: :new_user_password
    post   '/nova-senha',       to: 'devise/passwords#create',        as: :user_password
    get    '/trocar-senha',     to: 'devise/passwords#edit',          as: :edit_user_password
    patch  '/trocar-senha',     to: 'devise/passwords#update',        as: false
    put    '/trocar-senha',     to: 'devise/passwords#update',        as: false

    #registrations
    get    '/cancelar-conta',   to: 'users/registrations#cancel',   as: :cancel_user_registration
    get    '/cadastrar',        to: 'users/registrations#new',      as: :new_user_registration
    post   '/cadastrar',        to: 'users/registrations#create',   as: :user_registration
    get    '/editar-cadastro',  to: 'users/registrations#edit',     as: :edit_user_registration
    patch  '/editar-cadastro',  to: 'users/registrations#update',   as: false
    put    '/editar-cadastro',  to: 'users/registrations#update',   as: false
    delete '/deletar-conta',    to: 'users/registrations#destroy',  as: :destroy_user_registration
  end

  controller :home do
    get    '/pagina-inicial',                action: :index,             as: :home
    get    '/meu-perfil',                    action: :profile,           as: :profile
  end

  controller :orders do
    get    '/chamados',                      action: :index,             as: :orders
    get    '/chamados/abrir-chamado',        action: :new,               as: :new_order
    post   '/chamados/abrir-chamado',        action: :create,            as: false
    get    '/chamados/editar-chamado/:id',   action: :edit,              as: :edit_order
    patch  '/chamados/editar-chamado/:id',   action: :update,            as: false
    put    '/chamados/editar-chamado/:id',   action: :update,            as: false
    delete '/chamados/excluir-chamado/:id',  action: :destroy,           as: :destroy_order
    get '/chamados/:id',                     action: :show,              as: :order
  end
end
