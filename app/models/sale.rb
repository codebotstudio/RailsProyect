class Sale < ActiveRecord::Base
  belongs_to :user
  after_create :save_product_id
  after_save :save_total
  has_many :has_product
  has_many :products, through: :has_product

  #scope :high_sale, -> {order("total_price DESC").limit(10)}

  #scope :today, -> {where("created_at ")}
  # Arreglar metodos TODAY
  #scope :hoy, -> { where(created_at: Date.today) }
  scope :pendiente, -> {where(pending: true)}
  scope :activeDate, -> { where(created_at: Date.today)}
  scope :recientes, -> {order("created_at DESC")}

  # SCOPE listo y funcionando
  def self.venta_trabajador(user)
    where(user_id: user.id)
  end

  # Método para ventas entre fechas 
=begin
  def self.entre_fechas(inicio, final)
    where(created_at:)
  end
=end

  #Custom setter
  def product_id=(value)
    @product_id = value
  end
  private

  def save_product_id
  	@product_id.each do |product_id|
  		HasProduct.create(product_id: product_id, sale_id: self.id)
  	end
  end

  def save_total
    item = 0
    total = 0
    self.products.each do |product|
      item += 1
      total += product.sale_price
    end
    self.update_columns(items: item)
    self.update_columns(total_price: total)
  end

end
