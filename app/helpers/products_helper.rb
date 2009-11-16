module ProductsHelper
  def categorized(i)
      if @product
         @product.auction.categories.include?(i)
      else
        false
      end
   end
end
