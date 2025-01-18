class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :redirect_to_www

  private

  def redirect_to_www
    if request.host == 'raiselements.com'
      redirect_to "https://www.raiselements.com#{request.fullpath}", status: :moved_permanently
    end
  end
end
 