class RulebooksController < ApplicationController
  before_action :authenticate_user!
  def new
    @rulebook = current_user.rulebooks.new
  end
  def create
    @rulebook = current_user.rulebooks.new(params.require(:rulebook).permit(:title, :description, :code, :permission))
    if @rulebook.save
      redirect_to @rulebook, notice: 'Created successfully'
    else
      render 'new', notice: 'title is empty'
    end
  end
  def edit
    @rulebook = Rulebook.find(params[:id])
    redirect_to @rulebook unless @rulebook.user.id == current_user.id
  end
  def update
    @rulebook = Rulebook.find(params[:id])
    redirect_to @rulebook unless @rulebook.user.id == current_user.id
    if @rulebook.update_attributes(params.require(:rulebook).permit(:title, :description, :code, :permission))
      redirect_to @rulebook, notice: 'Updated successfully'
    else
      render 'edit', notice: 'title is empty'
    end
  end
  def destroy
    @rulebook = Rulebook.find(params[:id])
    redirect_to @rulebook unless @rulebook.user.id == current_user.id
    @rulebook.destroy
    redirect_to root_path, notice: 'Destroyed successfully'
  end
  def show
    @rulebook = Rulebook.find(params[:id])
  end
end
