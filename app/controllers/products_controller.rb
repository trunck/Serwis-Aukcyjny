class ProductsController < ApplicationController
  #TODO ustal polityke dostepu
  def new
    @product = Kernel.const_get(product_type.classify).new
    #@product.auction = Auction.new
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
    @product = Kernel.const_get(product_type.classify).new(params[:product])
   # params[:product][:auction] = a
    #raise (params[:product][:auction][:end].to_s) +(params[:product][:auction][:start].to_s )+ (params[:product][:auction][:description].to_s) 
   # @auction.auctionable = @product
   # @product.auction = @auction
   #@product.auction_attributes = params[:product][:auction_attributes]
   #@product.auction.user = current_user
   #@product.auction.auctionable = @product
   
   if( @product.auction.save and @product.save )
    redirect_to :action => "show", :id => @product.id, :product_type => @product.class
   else
    render :action => "new" 
   end
    
  end
  
  def edit
    product_type = params[:product_type] || "SiteLink"
    @product = Kernel.const_get(product_type.classify).find(params[:id])
    
    params[:product] = @product.attributes
    params[:product][:auction_attributes] = @product.auction.attributes
  end
  
  def update
    product_type = params[:product_type] || "SiteLink"
    @product = Kernel.const_get(product_type.classify).find(params[:id])
    if(@product.update_attributes(params[:project]))
      redirect_to :action => "index", :product_type => @product.class
    else
      render :action => 'edit'
    end
  end
  
  def show
    product_type = params[:product_type] || "SiteLink"
    
    @product = Kernel.const_get(product_type.classify).find(params[:id])
  end
  
end
