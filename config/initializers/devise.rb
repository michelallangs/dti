class TurboFailureApp < Devise::FailureApp
  def respond
    if request_format == :turbo_stream
      redirect
    else
      super
    end
  end

  def skip_format?
    %w(html turbo_stream */*).include? request_format.to_s
  end
end

Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  require 'devise/orm/active_record'
  
  config.case_insensitive_keys = [:username]

  config.strip_whitespace_keys = [:username]
  
  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 12
  
  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.sign_out_via = :get

  config.parent_controller = 'TurboDeviseController'
  
  config.navigational_formats = ['*/*', :html, :turbo_stream]

  config.warden do |manager|
    manager.failure_app = TurboFailureApp
  end
end
