require 'validates_uri_existance'
class SiteLink < ActiveRecord::Base
  validates_uri_existence_of :url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
 :message => "Format adresu jest niepoprawny lub taka strona nie istnieje (nie odpowiada)."
  has_one :auction, :as => :auctionable, :autosave => true
  has_many :categories, :through => :auction
  accepts_nested_attributes_for :auction, :allow_destroy => true
  named_scope :active, :include => :auction, :condition => {'auctions.activated' => true }
  #named_scope :auction, :include => :auction
  def SiteLink.searchObject(params)
    SiteLinkSearch.new(params)
  end
  named_scope :pagerank_gte, lambda{ |pagerank|
    {
      :conditions => ["site_links.pagerank >= (?)", pagerank]
    }
   } 
   
   named_scope :pagerank_lte, lambda{ |pagerank|
    {
      :conditions => ["site_links.pagerank <= (?)", pagerank]
    }
   }
   
   named_scope :users_daily_gte, lambda{ |users_daily|
    {
      :conditions => ["site_links.users_daily >= (?)", users_daily]
    }
   } 
   
   named_scope :users_daily_lte, lambda{ |users_daily|
    {
      :conditions => ["site_links.users_daily <= (?)", users_daily]
    }
   }
   named_scope :by_categories_name, lambda{ |*categories|
    {
      :include => :categories, 
      :conditions => ["categories.name IN (?)", categories]#.map(&:name)]
    }
   }
   named_scope :by_catss, lambda{ |*categories|
    {
      :include => :auction,       
      :conditions => ["auctions.auctionable_type = (?)", self.class.to_s]
    }
   }
   
    def self.prepare_search_scopes(params = {})
 #   product_scope = Kernel.const_get(params[:product_type].classify)#.prepare_search_scopes(params)
 #   products_all = product_scope.all
    
  #  scope.search.find(:include => product_scope, :conditions => {})
    #Auction.auctionable_pagerank_gte(0)
    scope = SiteLink.search(:all)#Auction.search(:auctionable_type => params[:product_type].classify, :activated => true)
    #auct_scope = (Auction.prepare_search_scopes(params))
 #   scope = scope.by_categories_name({})#.auction_prepare_search_scopes(params)
    #raise scope.size.to_s
    #scope = scope.by_auctionable_type(params[:product_type].classify)
##    #scope = scope.auction_minimum_days_until_end_of_auction(params[:minimum_days_until_end_of_auction].to_i) if params[:minimum_days_until_end_of_auction].to_i > 0
##    #scope = scope.auction_maximum_days_until_end_of_auction(params[:maximum_days_until_end_of_auction].to_i) if params[:maximum_days_until_end_of_auction].to_i > 0
    #TODO ACHTUNG ! powyższe dwie linijki, jeżeli nie będą mogły sparsować pól minimum_days_until... i maximum_days_until... to po prostu je zignorują bez feedbacku do użyszkodnika
    #scope.conditions.end_lte = params[:auction_end_lte] if params[:auction_end_lte]
    #scope.conditions.auctionable_class_equals = params[:product_type].classify if params[:product_type]
    
    scope = scope.pagerank_gte(params[:pagerank_gte]) if params[:pagerank_gte].to_i > 0
    scope = scope.pagerank_lte(params[:pagerank_lte]) if params[:pagerank_lte].to_i > 0
    scope = scope.users_daily_gte(params[:users_daily_gte]) if params[:users_daily_gte].to_i > 0
    scope = scope.users_daily_lte(params[:users_daily_lte]) if params[:users_daily_lte].to_i > 0
    
#    if(params[:categories])    
#      temp = params[:categories].reject {|k, v| v.to_i == 0}.to_a.map{|k, v| k}
#      
#      if(temp =! nil && temp.size > 0)
#        
#        scope = scope.auction_by_categories_name(*(temp))
#      end
#    end
    
   #scope.order_by = :created_at
   #scope.order_as = "DESC"
    
    return scope
  end
   
end

class SiteLinkSearch < Tableless
 # has_many :categories
  #accepts_nested_attributes_for :categories
  column :pagerank_gte, :integer
  column :pagerank_lte, :integer
  column :pagerank_lte, :integer
  column :pagerank_gte, :integer
  column :users_daily_gte, :integer
  column :users_daily_lte, :integer
  column :minimum_days_until_end_of_auction, :integer
  column :maximum_days_until_end_of_auction, :integer
  column :product_type, :string
  @cats
  def categories_attributes=(atr)
    @cats = []
    @cats.push(atr)
  end
  #@categories = Category.all#.map{|t| t.name}
  def categories=(cat)
  #  @categories = {} 
  # @categories.merge(cat)
  end
  def categories
    @cats
  end
end