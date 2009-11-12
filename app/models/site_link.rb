class SiteLink < ActiveRecord::Base
  has_one :auction, :as => :auctionable, :autosave => true
  
  def auction_attributes=(attributes)
    auction= Auction.create!(attributes)
    auction.auctionable = self
  end
end
