class DocumentationController < ApplicationController
  def docs_page
    if current_user.plan != "starter"
      redirect_to root_url
    end
  end

  def docs_page_updated
    if current_user.plan != "premium"
      redirect_to root_url
    end
  end
  def docs_page_free

  end
end
