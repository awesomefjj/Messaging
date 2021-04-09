class WelcomeController < ApplicationController
  def index
    flash[:notice] = "Logged is successfully"
    flash[:alert] = "Inalid email or password"
  end
end
