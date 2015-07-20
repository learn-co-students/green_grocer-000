def consolidate_cart(cart:[])
  # code here
  cart.each_with_object({}) do |item, res|
	key = item.keys[0]
	res.has_key?(key) ? res[key][:count] += 1 : res[key] = item[key].each_with_object({:count => 1}) { |(k,v), res_2| res_2[k] = v }
  end
end

def apply_coupons(cart:[], coupons:[])
  # code here
  cart.class == Array ? con_cart = consolidate_cart(cart: cart) : con_cart = cart
  coupons.each_with_object(con_cart) do |item, res|
    # here (k, v) are key and value of the con_cart's item, which can be couponed
	k, v = res.detect { |k,v| k == item[:item] }
	if k != nil && v[:count] >= item[:num] then
      times = v[:count] / item[:num]
	  res["#{k} W/COUPON"] = { :count => times, :price => item[:cost], :clearance => res[k][:clearance] }
      v[:count] -= times * item[:num]
	  #res.delete(k) if v[:count] == 0
	end
  end  
end

def apply_clearance(cart:[])
  # code here
  cart.class == Array ? con_cart = consolidate_cart(cart: cart) : con_cart = cart
  con_cart.each { |k,v| v[:price] = v[:price] / 10 * 8 if v[:clearance] }
end

def checkout(cart: [], coupons: [])
  # code here
  con_cart = consolidate_cart(cart: cart)
  con_cart_coup = apply_coupons(cart: con_cart, coupons: coupons)
  con_cart_clear = apply_clearance(cart: con_cart_coup)
  
  total = con_cart_clear.reduce(0) { |res, (k, v)| res + v[:price] * v[:count] }
  total > 100 ? total / 10 * 9 : total
end
