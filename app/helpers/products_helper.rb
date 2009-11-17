module ProductsHelper
  def categorized(i)
      if @product
         @product.auction.categories.include?(i)
      else
        false
      end
  end
  
  def ProductsHelper.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
    def activate_url(auction_id)
      "http://" + request.env['HTTP_HOST'] + url_for(:controller => 'products', :action => 'activate', :id => auction_id)
    end
end
