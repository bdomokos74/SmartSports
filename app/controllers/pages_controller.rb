class PagesController < ApplicationController
  skip_before_filter :require_login, only: [:index]
  def index
  end

  def health

  end
end
