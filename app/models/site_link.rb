class SiteLink < ActiveRecord::Base
  has_one :auction, :as => :auctionable, :autosave => true
  after_update :save_auction
  accepts_nested_attributes_for :auction
  def auction_attributes=(attributes)
    if attributes[:id].blank?
      self.auction = Auction.new(attributes)
    else
      auction = auction.detect { |t| t.id == attributes[:id].to_i}
      auction.attributes = attributes
    end
    #self.auction.build(attributes)
    #auction.auctionable = self
    #raise auction.auctionable.pagerank.to_s
  end
  def save_auction
    auction.save(false) #Tu nie ma walidacji ! walidację przed zupdatowaniem trzeba zrobić wcześniej
  end
end
