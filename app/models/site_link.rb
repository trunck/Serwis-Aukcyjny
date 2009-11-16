class SiteLink < ActiveRecord::Base
  has_one :auction, :as => :auctionable, :autosave => true
  has_many :categories, :through => :auction
  accepts_nested_attributes_for :auction, :allow_destroy => true
end
