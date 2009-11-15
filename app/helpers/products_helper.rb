module ProductsHelper
  def categorize(i)
      if @product
         @product.interests.include?(i)
      else
        false
      end
   end
end
