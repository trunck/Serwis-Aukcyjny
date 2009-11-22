require 'validates_uri_existance'
require 'tableless.rb'
class Banner < ActiveRecord::Base
  validates_uri_existence_of :url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix, :message => "Format adresu jest niepoprawny lub taka strona nie istnieje (nie odpowiada)."
  has_one :auction, :as => :auctionable, :autosave => true
  accepts_nested_attributes_for :auction, :allow_destroy => true
  
  def Banner.searchObject(params)
    BannerSearch.new(params)
  end
  
  def self.prepare_search_scopes(params = {})
    scope = Banner.search(:all)#Auction.search(:auctionable_type => params[:product_type].classify, :activated => true)
    scope = scope.pagerank_gte(params[:pagerank_gte]) if params[:pagerank_gte].to_i > 0
    scope = scope.pagerank_lte(params[:pagerank_lte]) if params[:pagerank_lte].to_i > 0
    scope = scope.users_daily_gte(params[:users_daily_gte]) if params[:users_daily_gte].to_i > 0
    scope = scope.users_daily_lte(params[:users_daily_lte]) if params[:users_daily_lte].to_i > 0
    scope = scope.x_pos_gte(params[:x_pos_gte]) if params[:users_daily_gte].to_i > 0
    scope = scope.x_pos_lte(params[:x_pos_lte]) if params[:users_daily_lte].to_i > 0
    scope = scope.y_pos_gte(params[:y_pos_gte]) if params[:users_daily_gte].to_i > 0
    scope = scope.y_pos_lte(params[:y_pos_lte]) if params[:users_daily_lte].to_i > 0
    scope = scope.width_gte(params[:width_pos_gte]) if params[:users_daily_gte].to_i > 0
    scope = scope.height_lte(params[:height_pos_lte]) if params[:users_daily_lte].to_i > 0
    return scope
  end
end


class BannerSearch < Tableless
 # has_many :categories
  #accepts_nested_attributes_for :categories
  column :pagerank_gte, :integer
  column :pagerank_lte, :integer
  column :pagerank_lte, :integer
  column :pagerank_gte, :integer
  column :users_daily_gte, :integer
  column :users_daily_lte, :integer  
  column :x_pos_gte, :integer
  column :x_pos_lte, :integer
  column :y_pos_gte, :integer
  column :y_pos_lte, :integer
  column :width_gte, :integer
  column :width_lte, :integer
  column :height_gte, :integer
  column :height_lte, :integer
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