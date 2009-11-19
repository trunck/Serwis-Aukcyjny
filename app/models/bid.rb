class Bid < ActiveRecord::Base
  validates_numericality_of :offered_price, :greater_than => 0
  validates_presence_of :user
  validates_presence_of :auction
  validate :offered_price_meets_minimal, :message => nil
  validate :can_bid_open_auctions, :message => "Niestety, ta aukcja już się zakończyła"
  validate :can_bid_activated_auctions, :message => "Niestety, ta aukcja nie została aktywowana"
  @@minimal_end_of_auction_interval = 180 #TODO Zrob z tego configa
  belongs_to :user
  belongs_to :auction
  named_scope :by_date, :order => "created_at DESC"
  named_scope :by_offered_price, :order => "offered_price DESC, created_at ASC"
  named_scope :by_created_at_asc, :order => "created_at ASC"
  named_scope :by_created_at_desc, :order => "created_at DESC"
  after_save :update_auction_time
  
  def can_bid_open_auctions
    auction.end >= Time.now
  end
  def can_bid_activated_auctions
    auction.end >= Time.now
  end
  def update_auction_time
    Auction.transaction do
      #a = Auction.find(self.auction_id)
      if (auction.end - created_at <= @@minimal_end_of_auction_interval)
        t = Time.now.advance(:seconds => @@minimal_end_of_auction_interval)
        #TODO zastanowic sie nad localtimem - trzeba poprawic tak zeby wszedzie sie wyswietlal i dodawal localtime !
        if auction.update_attribute :end, t
          
        else
          raise "Serious error !" #Tu sa nie przelewki, nie powinno nigdy tu wejsc...
        end
      end
    end
  end
  def offered_price_meets_minimal
    a = Auction.find(self.auction_id)
    minimal = a.minimal_bid
    if self.offered_price.to_f < a.minimal_bid.to_f
      errors.add_to_base("Musisz zalicytować przynajmniej " + a.minimal_bid.to_s)
      return false
    end
    return true
  end
end
