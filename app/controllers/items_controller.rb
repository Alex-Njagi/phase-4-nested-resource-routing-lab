class ItemsController < ApplicationController

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
      render json: items, include: :user
  end

  def show
    item = Item.find_by(id: params[:id])
    if item
      render json: item, include: :user
    else
      render json: { errors: "Item not found" }, status: :not_found
    end
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
        if user.nil?
          render json: { error: "User not found" }, status: 404
          return
        end
      item = user.items.create(item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, status: :created
  end

  private
    def item_params
      params.permit(:name, :description, :price, :user_id)
    end

end
