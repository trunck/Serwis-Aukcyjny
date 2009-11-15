class SiteLink < ActiveRecord::Base
  has_one :auction, :as => :auctionable, :autosave => true
  accepts_nested_attributes_for :auction, :allow_destroy => true
end
