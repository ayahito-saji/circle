class PagesController < ApplicationController
  def index
    if user_signed_in?
      redirect_to current_room_path and return
    end
  end
end
