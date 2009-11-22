
class ProductSearch < Tableless
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
  column :number_of_links_gte, :integer
  column :number_of_links_lte, :integer
  column :words_number_gte, :integer
  column :words_number_lte, :integer
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