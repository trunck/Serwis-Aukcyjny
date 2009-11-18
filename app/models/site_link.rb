require 'validates_uri_existance'
class SiteLink < ActiveRecord::Base
  validates_uri_existence_of :url, :with => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix,
 :message => "Format adresu jest niepoprawny lub taka strona nie istnieje (nie odpowiada)."
  has_one :auction, :as => :auctionable, :autosave => true
  has_many :categories, :through => :auction
  accepts_nested_attributes_for :auction, :allow_destroy => true
  named_scope :active, :include => :auction, :condition => {'auctions.activated' => true }
  #named_scope :auction, :include => :auction
  
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
end
