class ProductsController < ApplicationController
  
  
  def new
    @product = Kernel.const_get(product_type.classify).new
    
    @product.auction = Auction.new
  end
  def product_type
    params[:product_type] || "SiteLink"
  end
  
  def create
    product_type = params[:product_type] || "SiteLink"
   # a = params[:product][:auction]
    #params[:product][:auction] = Auction.create!(params[:product][:auction])
    #params[:product][:auction].user = current_user
   # params[:product][:auction] = nil
    @product = Kernel.const_get(product_type.classify).create!(params[:product])
   # params[:product][:auction] = a
    #raise (params[:product][:auction][:end].to_s) +(params[:product][:auction][:start].to_s )+ (params[:product][:auction][:description].to_s) 
   # @auction.auctionable = @product
   # @product.auction = @auction
   #@product.auction_attributes = params[:product][:auction_attributes]
   
    if @product.auction.save and @product.save
      
      flash[:notice] = "Aukcja założona pomyślnie"
      redirect_to :id => nil
    else
      render :action => "new"
    end
    #@auction.save
    #@product.save
  end
  
end
