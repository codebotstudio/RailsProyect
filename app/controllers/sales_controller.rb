class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  #after_action :set_sale_params, only: [:create]

  # GET /sales
  # GET /sales.json
  def index
    if current_user.permission_level == "1"
      @sales = Sale.all.venta_trabajador(current_user).recientes.today
    else
      @sales = Sale.all.recientes.today
    end
    # No funciona @sales = Sale.hoy
  end

  def history
    @sales = Sale.all.recientes.today
    @sales = Sale.all.ventas_entre(params[:start], params[:finish]) if (params[:start] && params[:finish]).present?
  end

  def pending
    @sales = Sale.all.pendiente
  end

  # GET /sales/1
  # GET /sales/1.json
  def show
   @sale = Sale.find(params[:id])
   @store = Store.find(@sale.store_id)
  end

  # GET /sales/new
  def new
    @sale = Sale.new
    @products = Product.all.activos
  end

  # GET /sales/1/edit
  def edit
    @products = Product.all.activos
  end

  # POST /sales
  # POST /sales.json
  def create
    @sale = Sale.new(sale_params)
    @sale.make_has_products(params[:product_id], params[:quantity])
    #@sale.save
    #@sale.save_total
    respond_to do |format|
      if @sale.save
        #@sale.save_total
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1
  # PATCH/PUT /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.json
  def destroy
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to sales_url, notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale
      @sale = Sale.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_params
      params.require(:sale).permit(:user_id, :total_price, :items, :pending)
    end

  #  def set_sale_params
  #    params[:items] = :product_id
  #  end
end
