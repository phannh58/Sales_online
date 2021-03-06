class Admin::ProductsController < ApplicationController
  load_and_authorize_resource
  before_action :load_categories, only: [:new, :create, :edit, :update]

  def new
    @product.image_products.build
  end

  def index
    @products = Product.all.order("created_at DESC").paginate page: params[:page],
      per_page: Settings.category.per_page
  end

  def create
    @product = Product.new product_params
    respond_to do |format|
      if @product.save
        format.json {head :no_content}
        format.js
        format.html do
          redirect_to admin_products_path
        end
      else
        format.json {render json: @product.errors.full_messages,
          status: :unprocessable_entity}
        format.js
      end
    end
  end

  def show
    @comments = @product.comments.order("created_at DESC")
    @comment = Comment.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @product.update_attributes product_params
        format.json {head :no_content}
        format.js
      else
        format.js
        format.json {render json: @product.errors.full_messages,
          status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.js
      format.html {redirect_to products_url}
      format.json {head :no_content}
    end
  end

  private
  def load_categories
    @categories = Category.all
  end

  def product_params
    params.require(:product).permit :name, :price, :description, :category_id,
      :sale_off, image_products_attributes: [:id, :product_id, :image]
  end
end
