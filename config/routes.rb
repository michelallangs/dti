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
    delete '/sair',           to: 'devise/sessions#destroy',        as: :destroy_user_session

    #passwords
    get    '/nova-senha',     to: 'devise/passwords#new',           as: :new_user_password
    post   '/nova-senha',     to: 'devise/passwords#create',        as: :user_password

    #registrations
    get    '/cancelar-conta',   to: 'users/registrations#cancel',   as: :cancel_user_registration
    get    '/cadastrar',        to: 'users/registrations#new',      as: :new_user_registration
    post   '/cadastrar',        to: 'users/registrations#create',   as: :user_registration
    get    '/editar-cadastro',  to: 'users/registrations#edit',     as: :edit_user_registration
    patch  '/editar-cadastro',  to: 'users/registrations#update',   as: false
    put    '/editar-cadastro',  to: 'users/registrations#update',   as: false
    delete '/deletar-conta',    to: 'users/registrations#destroy',  as: :destroy_user_registration
  end

  controller :users do
    get    '/usuarios',                      action: :index,             as: :users
    get    '/usuarios/novo-usuario',         action: :new,               as: :new_user
    post   '/usuarios/novo-usuario',         action: :create,            as: false
    get    '/usuarios/editar-usuario/:id',   action: :edit,              as: :edit_user
    patch  '/usuarios/editar-usuario/:id',   action: :update,            as: false
    get    '/trocar-senha/:id',              action: :edit_password,     as: :edit_user_password
    patch  '/trocar-senha/:id',              action: :update_password,   as: false
    put    '/trocar-senha/:id',              action: :update_password,   as: false
    delete '/usuarios/excluir-usuario/:id',  action: :destroy,           as: :destroy_user
    get    '/usuarios/:id',                  action: :show,              as: :user
  end

  controller :home do
    get    '/pagina-inicial',                action: :index,             as: :home
    get    '/meu-perfil',                    action: :profile,           as: :profile
  end

  controller :orders do
    get    '/os',                       action: :index,                  as: :orders
    get    '/os/abrir-os',              action: :new,                    as: :new_order
    post   '/os/abrir-os',              action: :create,                 as: false
    get    '/os/editar-os/:id',         action: :edit,                   as: :edit_order
    patch  '/os/editar-os/:id',         action: :update,                 as: false
    put    '/os/editar-os/:id',         action: :update,                 as: false
    delete '/os/excluir-os/:id',        action: :destroy,                as: :destroy_order
    get    '/os/:id',                   action: :show,                   as: :order
    get    '/os/imprimir-os/:id',       action: :print_order,            as: :print_order
    get    '/imprimir-relatorio',    action: :print_orders_report,    as: :print_orders_report
  end

  controller :stuffs do
    get    '/equipamentos',                               action: :index,             as: :stuffs
    get    '/equipamentos/cadastrar-equipamento',         action: :new,               as: :new_stuff
    post   '/equipamentos/cadastrar-equipamento',         action: :create,            as: false
    get    '/equipamentos/editar-equipamento/:id',        action: :edit,              as: :edit_stuff
    patch  '/equipamentos/editar-equipamento/:id',        action: :update,            as: false
    put    '/equipamentos/editar-equipamento/:id',        action: :update,            as: false
    delete '/equipamentos/excluir-equipamento/:id',       action: :destroy,           as: :destroy_stuff
    get    '/equipamentos/:id',                           action: :show,              as: :stuff
  end

  controller :schools do
    get    '/unidades',                           action: :index,             as: :schools
    get    '/unidades/cadastrar-unidade',         action: :new,               as: :new_school
    post   '/unidades/cadastrar-unidade',         action: :create,            as: false
    get    '/unidades/editar-unidade/:id',        action: :edit,              as: :edit_school
    patch  '/unidades/editar-unidade/:id',        action: :update,            as: false
    put    '/unidades/editar-unidade/:id',        action: :update,            as: false
    delete '/unidades/excluir-unidade/:id',       action: :destroy,           as: :destroy_school
    get    '/unidades/:id',                       action: :show,              as: :school
  end

  resources :orders do
    get :autocomplete_stuff_patrimony, :on => :collection
    get '/:slug', action: :index, on: :collection
  end

  resources :schools do
    get :autocomplete_school_name, :on => :collection
    get '/:slug', action: :index, on: :collection
  end

  resources :users do
    get :autocomplete_user_name, :on => :collection
    get '/:slug', action: :index, on: :collection
  end

  resources :stuffs do
    get '/:slug', action: :index, on: :collection
  end
end
