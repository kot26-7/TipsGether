class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:search]

  def index
  end

  def search
  end
end
