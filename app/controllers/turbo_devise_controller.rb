class TurboDeviseController < ApplicationController
  add_breadcrumb "meu perfil".html_safe, :profile_path, only: [:edit]
  add_breadcrumb "editar dados da conta".html_safe, :edit_user_registration_path, only: [:edit]

  class Responder < ActionController::Responder
    def to_turbo_stream
      controller.render(options.merge(formats: :html))
    rescue ActionView::MissingTemplate => error
      if get?
        raise error
      elsif has_errors? && default_action
        render rendering_options.merge(formats: :html, status: :unprocessable_entity)
      else
        redirect_to navigation_location
      end
    end
  end

  self.responder = Responder
  respond_to :html, :turbo_stream
end