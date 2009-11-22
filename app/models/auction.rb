#require 'Date'
class Auction < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :bids
  belongs_to :user, :class_name => 'User', :foreign_key => "user_id" 
  belongs_to :auctionable, :polymorphic => true
  named_scope :active, :conditions => { :activated => true}
  named_scope :categorised, :joins => :categories, :select => 'Distinct post.*'

  before_save :assign_roles
  accepts_nested_attributes_for :categories
 #attr_accessible :categories_ids
  validates_presence_of :user_id, :message => "BŁĄD ! nie da się stworzyć aukcji bez właściciela" 
  validates_presence_of :start, :end
 # validates_presence_of :user
  validate :start_must_be_after_today, :message => "Aukcja musi zacząć się najwcześniej od jutra"
  validate :start_must_be_before_end, :message => "Początek aukcji musi być przed jej końcem"
  validates_numericality_of :buy_now_price, :greater_than_or_equal_to => 0
  #validate :buy_now_price_null_or_numerical, :message => "Cena kup teraz musi być dodatnią niezerową liczbą rzeczywistą lub ma jej nie być wcale"
  validates_numericality_of :minimal_price, :greater_than_or_equal_to => 0
  validate :limited_bid_count_if_buy_now_auction, :message => "Nie można już złożyc oferty na tą aukcję"
  
  
  acts_as_authorization_object
   def start_must_be_before_end 
     errors.add(:s, "The start of an auction can`t be blank and it must be dated at least 1 day before end") if 
        start.blank? or self.start >= self.end #(self.start.year() * 1000 + self.start.month() * 100 +self.start.day()) >= (self.end.year() * 1000 + self.end.month() * 10 +self.end.day()) 
   end
  
  def limited_bid_count_if_buy_now_auction
    bids.count - 1 <= number_of_products
  end
  
  def notifyAuctionWinners
    raise "Not implemented yet"
  end
  
  def notifyAuctionWinner(user)
    raise "Not implemented yet"
  end
  
   def buy_now_price_null_or_numerical
     if !buy_now_price
       return true
     else
       return buy_now_price.valid_float? unless buy_now_price.class == Fixnum
     end
   end
   
   named_scope :by_type, lambda{ |type|
    {
      :conditions => ["auctions.auctionable_type = (?)", type]
    }
   }
   
   named_scope :by_categories, lambda{ |*categories|
    {
      :include => :categories, 
      :conditions => ["categories.id IN (?)", categories.map(&:id)]
    }
   }
   
   named_scope :by_auctionable_type, lambda{ |type|
    {
      :conditions => ["activated = (?) AND auctionable_type =(?)", true, type]
    }
   }
   
   named_scope :by_categories_name, lambda{ |*categories|
    {
      :include => :categories, 
      :conditions => ["categories.name IN (?)", categories]#.map(&:name)]
    }
   }
   
   named_scope :by_categories_id, lambda{ |*categories|
    {
      :include => :categories, 
      :conditions => ["categories.id IN (?)", categories]#.map(&:name)]
    }
   }
   
   named_scope :by_auctionable_id, lambda{ |ids|    
    {
      :conditions => ["auctions.auctionable_id IN (?)", ids]#.map(&:name)]
    }
   }
   
   named_scope :minimum_days_until_end_of_auction, lambda{ |*days|
    {
      :conditions => ["auctions.end - (?) >= INTERVAL '(?) days'",Time.now, days]#.map(&:name)]
    }
   }
   
   named_scope :maximum_days_until_end_of_auction, lambda{ |*days|
    {
      :conditions => ["auctions.end - (?) <= INTERVAL '(?) days'",Time.now, days]#.map(&:name)]
    }
   }
   
   def buy_now?
     return buy_now_price > 0
   end
   
   def assign_roles
    # puts "BLA"     
     if(new_record?)
        if(auctionable)
          
          auctionable.save
          self.auctionable_type = auctionable.class
          self.auctionable_id = auctionable.id
        end
      end
   end
  
  def start_must_be_after_today
    a = Time.now
      errors.add(:s, "The start of an auction can`t be dated in the past") if !start.blank? and (start.year() * 1000 + start.month() * 100 + start.day() ) < (a.year() * 1000 + a.month() *100 + a.day())
  end
  
  def user_attributes=(attributes)
    self.user = User.find(attributes)
    #auction.auctionable = self
    #raise auction.auctionable.pagerank.to_s
  end
  
  def minimal_bid
    if buy_now_price > 0
      buy_now_price
    else
      highest_bid + minimal_bidding_difference
    end
  end
  
  def highest_bid
    if buy_now_price > 0
      return buy_now_price
    end
      if(bids.count > 0) 
        t = bids.by_offered_price.all
        if(t.count == 1)
          minimal_price #+ minimal_bidding_difference  
        else
          t.fetch(1).offered_price 
        end
      else
        minimal_price  
      end
  end
  
  def bid()
    
  end
  
  def self.prepare_search_scopes(params = {})
   # product_scope = Kernel.const_get(product_type.classify).prepare_search_scopes(params)
    #products_all = product_scope.all
    
    #scope.search.find(:include => product_scope, :conditions => {})
    #Auction.auctionable_pagerank_gte(0)
    scope = Auction.search(:auctionable_type => params[:product_type].classify, :activated => true)
    
    #raise scope.size.to_s
    #scope = scope.by_auctionable_type(params[:product_type].classify)
    scope = scope.minimum_days_until_end_of_auction(params[:minimum_days_until_end_of_auction].to_i) if params[:minimum_days_until_end_of_auction].to_i > 0
    scope = scope.maximum_days_until_end_of_auction(params[:maximum_days_until_end_of_auction].to_i) if params[:maximum_days_until_end_of_auction].to_i > 0
    #TODO ACHTUNG ! powyższe dwie linijki, jeżeli nie będą mogły sparsować pól minimum_days_until... i maximum_days_until... to po prostu je zignorują bez feedbacku do użyszkodnika
    #scope.conditions.end_lte = params[:auction_end_lte] if params[:auction_end_lte]
    #sscope.conditions.auctionable_class_equals = params[:product_type].classify if params[:product_type]
    if(params != nil and params[:categories_attributes] != nil)
      temp = params[:categories_attributes].map {|t| t.to_i}#.reject {|k, v| v.to_i == 0}.to_a.map{|k, v| k}
      if(temp != nil && temp.size > 0)
        scope = scope.by_categories_id(*temp)
      end
    end
    #scope = scope.auctionable_pagerank_gte(params[:pagerank_gte], self.stringify_table(params[:product_type], true)) if params[:pagerank_gte]
 #   scope = scope.auctionable_pagerank_lte(params[:pagerank_lte]) if params[:pagerank_lte]
 #   scope = scope.auctionable_users_daily_gte(params[:users_daily_gte]) if params[:users_daily_gte]
 #   scope = scope.auctionable_users_daily_lte(params[:users_daily_lte]) if params[:users_daily_lte]
    elems = Kernel.const_get(params[:product_type].classify).prepare_search_scopes(params).all.map{|t| t.id}
    
    scope = scope.by_auctionable_id(elems)
    #TODO to jest horrendalnie niewydajne... o ile w ogole bedzie dzialac
   #scope.order_by = :created_at
   #scope.order_as = "DESC"
    
    return scope
  end
  
  

end