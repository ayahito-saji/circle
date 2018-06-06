class PagesController < ApplicationController
  def index
    if user_signed_in? && current_user.room
      render 'room'
    else
      render 'index'
    end
  end
end
