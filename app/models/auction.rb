#require 'Date'
class Auction < ActiveRecord::Base
  has_and_belongs_to_many :categories
  belongs_to :user, :class_name => 'User', :foreign_key => "user_id" 
  belongs_to :auctionable, :polymorphic => true

  before_save :assign_roles
  
  validates_presence_of :user_id, :message => "BŁĄD ! nie da się stworzyć aukcji bez właściciela" 
  validates_presence_of :start, :end
 # validates_presence_of :user
  validate :start_must_be_after_today, :message => "Aukcja musi zacząć się najwcześniej od jutra"
  validate :start_must_be_before_end, :message => "Początek aukcji musi być przed jej końcem"
  validates_numericality_of :buy_now_price, :greater_than_or_equal_to => 0
  #validate :buy_now_price_null_or_numerical, :message => "Cena kup teraz musi być dodatnią niezerową liczbą rzeczywistą lub ma jej nie być wcale"
  validates_numericality_of :minimal_price, :greater_than_or_equal_to => 0
  acts_as_authorization_object
   def start_must_be_before_end 
     errors.add(:s, "The start of an auction can`t be blank and it must be dated at least 1 day before end") if 
        start.blank? or self.start >= self.end #(self.start.year() * 1000 + self.start.month() * 100 +self.start.day()) >= (self.end.year() * 1000 + self.end.month() * 10 +self.end.day()) 
   end

   def buy_now_price_null_or_numerical
     if !buy_now_price
       return true
     else
       return buy_now_price.valid_float? unless buy_now_price.class == Fixnum
     end
   end
   
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
  
end