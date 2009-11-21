class SponsoredArticle < ActiveRecord::Base
  validates_uri_existence_of :url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
 :message => "Format adresu jest niepoprawny lub taka strona nie istnieje (nie odpowiada)."
  has_one :auction, :as => :auctionable, :autosave => true
  has_many :categories, :through => :auction
  accepts_nested_attributes_for :auction, :allow_destroy => true
  named_scope :active, :include => :auction, :condition => {'auctions.activated' => true }
  
  def self.prepare_search_scopes(params = {})
    scope = SponsoredArticle.search(:all)#Auction.search(:auctionable_type => params[:product_type].classify, :activated => true)    
    scope = scope.pagerank_gte(params[:pagerank_gte]) if params[:pagerank_gte].to_i > 0
    scope = scope.pagerank_lte(params[:pagerank_lte]) if params[:pagerank_lte].to_i > 0
    scope = scope.users_daily_gte(params[:users_daily_gte]) if params[:users_daily_gte].to_i > 0
    scope = scope.users_daily_lte(params[:users_daily_lte]) if params[:users_daily_lte].to_i > 0
    scope = scope.words_number_gte(params[:words_number_gte]) if params[:words_number_gte].to_i > 0
    scope = scope.words_number_lte(params[:words_number_lte]) if params[:words_number_lte].to_i > 0
    return scope
  end
end
