class RulebooksController < ApplicationController
  before_action :authenticate_user!
  def new
    @rulebook = current_user.rulebooks.new
  end
  def create
    @rulebook = current_user.rulebooks.new(params.require(:rulebook).permit(:title, :description, :code, :permission))
    begin
      task_code = Radius::Radius.new.compile(@rulebook.code)
    rescue => e
      flash.now[:alert] = e
      render 'new' and return
    end
    @rulebook.task_code = task_code
    if @rulebook.save
      redirect_to @rulebook, notice: 'Created successfully'
    else
      flash.now[:alert] = 'title is empty'
      render 'new'
    end
  end
  def edit
    @rulebook = Rulebook.find(params[:id])
    redirect_to @rulebook unless @rulebook.user.id == current_user.id
  end
  def update
    @rulebook = Rulebook.find(params[:id])
    redirect_to @rulebook unless @rulebook.user.id == current_user.id

    begin
      task_code = Radius::Radius.new.compile(params[:rulebook][:code])
    rescue => e
      flash.now[:alert] = e
      @rulebook.code = params[:rulebook][:code]
      render 'new' and return
    end
    @rulebook.update_attribute(:task_code, task_code)
    if @rulebook.update_attributes(params.require(:rulebook).permit(:title, :description, :code, :permission))
      redirect_to @rulebook, notice: 'Updated successfully'
    else
      flash.now[:alert] = 'title is empty'
      render 'new'
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
