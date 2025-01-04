class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :allow_iframe

  private

  def allow_iframe
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://codebrisk.co'
    response.headers['X-Frame-Options'] = 'ALLOW-FROM http://localhost:3000'
  end
end
