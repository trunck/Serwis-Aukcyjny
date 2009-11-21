include ProductsHelper
class ProductsController < ApplicationController
  #TODO ustal polityke dostepu
  def new
    @product = Kernel.const_get(product_type.classify).new
    @product.auction = @product.build_auction
    #@product.auction = Auction.new
    @cats = Category.find(:all)
    @product.auction.activation_token = ProductsHelper.random_string(20)
   # @product.auction.categories = @cats
  end
  
  def product_type
    params[:product_type] || "site_link"
  end

  def activate
    #TODO przenieś logikę z kontrolera do modelu
      @auction = Auction.find(params[:id])
      if @auction == nil
        flash[:notice] = "Aukcja o podanym numerze nie istnieje."
        redirect_to :root
        return
      end
      if !@auction.activated and @auction.end < Time.now
        s ||= @auction.auctionable.url
        begin
          open(@auction.auctionable.url) { 
            |f|
            if f.string.contains(@auction.activation_token)
              @auction.activated = true
              @auction.save
              #TODO Dodanie aukcji do kolejki w demonie zamykającym aukcje
              flash[:notice] = "Auckcja aktywowana pomyślnie"
              redirect_to :action => "show", :id => params[:id], :product_type => @auction.auctionable.class
              return
            end
          }
        rescue
          flash[:notice] = "Podany w aukcji url jest niepoprawny lub nie odpowiada"
          redirect_to :action => "show", :id => params[:id], :product_type => @auction.auctionable.class
        end
      else
        redirect_to :index
      end
  end
  
  def prepare_search
    search = params[:search] || {}
    search.merge!({:product_type => product_type, :categories => params[:categories]})
    
    @scope = Auction.prepare_search_scopes(search)
    #@scope = Auction.by_categories_name(product_type, *["sport", "turystyka"]).all()#Auction.active.prepare_search_scopes(params[:search])#Kernel.const_get(product_type.classify).prepare_search_scope(params[:search])
     
  end
  
  def index       
    prepare_search
    @products = (@scope.all).map {|t| t.auctionable }
    
  end
  
  def create
    #product_type = params[:product_type] || "site_link"
    @product = Kernel.const_get(product_type.classify).new(params[product_type.to_s])
    @t = @product.auction.end
    @product.auction.end = Time.local(@t.year, @t.mon, @t.day, @t.hour)
    #@product.build_auction(params[:product][:auction])
    #@product.auction = params[:product][:auction]
   # @product.attributes = params[product_type]
    
   # raise params[product_type][:url].to_s
   
   #@product.auction = @product.build_auction(params[product_type][:auction])
   
    @product.auction.user = User.find(current_user.id)    
   if( @product.auction.save and  @product.save )
    redirect_to :action => "show", :id => @product.id, :product_type => @product.class
   else
    render :action => "new" 
   end
    
  end
  
  def edit
    product_type = params[:product_type] || "site_link"
    
    @product = Kernel.const_get(product_type.classify).find(params[:id])
    
    #raise @product.auction.start.to_s
 # params[:product] = @product.attributes    
    #params[:product] = @product.attributes.to_a
    #params[:auction] = @product.auction.attributes.to_a
  end
  
  def update
    product_type = params[:product_type] || "site_link"
    @product = Kernel.const_get(product_type.classify).find(params[product_type.to_s][:id])
    #@product.attributes = params[:product];
    params[product_type][:auction_attributes][:categories_attributes] ||= {} 
    #@product.auction.build_categories(params[product_type][:auction_attributes][:categories_attributes])
    #@product.auction = @product.build_auction(params[product_type.to_s][:auction_attributes]);
    #@product.auction.update_attributes(params[product_type.to_s][:auction_attributes]);
    if(@product.update_attributes(params[product_type]))
      @product.auction.update_attributes(params[product_type][:auction_attributes])
      redirect_to :action => "show", :id => @product.id, :product_type => @product.class
    else
      render :action => 'edit'  
    end
    
  #  (@product.auction.update_attributes(params[product_type.to_s][:auction_attributes]) and @product.update_attributes(params[product_type.to_s])) ?
  #    redirect_to({:action => "index", :product_type => @product.class}) : render(:action => :edit)

#    if(@product.update_attributes(params[:project]))
#      redirect_to :action => "index", :product_type => @product.class
#    else
#      render :action => 'edit'
#    end
  end
  
  def show
    product_type = params[:product_type] || "site_link"
    @bid = Bid.new
    @product = Kernel.const_get(product_type.classify).find(params[:id])
  end
  
  def bid
    Bid.transaction do
     Auction.transaction do
       @product = Kernel.const_get(product_type.classify).find(params[:product_id])
       params[:bid][:offered_price] =params[:bid][:offered_price].gsub(/,/ , '.' ) if params[:bid][:offered_price]
       @bid = Bid.new(params[:bid])
       if @bid.save
         
         redirect_to :action => "show", :id => @product.id, :product_type => @product.class.to_s
       else
         #@auction = Auction.find(params[:bid][:auction_id])
         render :action => "show", :id => @product.id, :product_type => @product.class.to_s, :product_id => @product.id  
       end
     end
    end
  end
  
  def ask_for_bid_cancellation
    bid_id = params[:bid_id]
    @bid = Bid.find(bid_id)
    raise "No auction with id = #{bid_id}" if @bid == nil
    raise "Must be logged in" if current_user == nil
    #TODO obsluz te wyjatki jakos
    @bid.ask_for_cancell(current_user)
    redirect_to :action => "show", :id => params[:product_id], :product_type => params[:product_type]
  end
  
  def cancell_bid
    bid_id = params[:bid_id]
    @bid = Bid.find(bid_id)
    raise "No auction with id = #{bid_id}" if @bid == nil
    raise "Must be logged in" if current_user == nil
    #TODO obsluz te wyjatki jakos
    @bid.cancell_bid(current_user, params[:decision]);
    redirect_to :action => "show", :id => params[:product_id], :product_type => params[:product_type]
  end
  
end
