require "pry"

def consolidate_cart(cart:[])
  cart.each do |item|
  	if item[item.keys[0]].has_key?(:count)
  		item[item.keys[0]][:count] +=1
  	else
  	    item[item.keys[0]].store(:count, 1)
  	end
  end
  cart.uniq!
  cart.each_with_object({}) do |x, answer_hash|
  	answer_hash.merge!(x)
  end
end

def apply_coupons(cart:[], coupons:[])
	if coupons ==[]
		return cart
	end
	cart.each do |food, attrs|
		if attrs[:count] < coupons[0][:num]
			cart
		end
	end
	coupon_hash = {count: 1}
	coupon_hash2 = {count: 1}
	cart.keys.each do |food|
		if food == coupons[0][:item]
			cart["#{food} W/COUPON"] = coupon_hash
			if cart[food][:clearance] == true
				coupon_hash[:clearance] = true
			else
				coupon_hash[:clearance] = false
			end
			coupon_hash[:price] = coupons[0][:cost]
			count = cart[food][:count]
			if coupons.length == 2 && coupons[0] == coupons[1] && count>coupons[0][:num]+coupons[1][:num]
				new_count = count - coupons[0][:num]*2
			    cart[food][:count] = new_count
			    coupon_hash[:count] = 2
			else 
				new_count = count - coupons[0][:num]
				cart[food][:count] = new_count
			end
    	end
    	if coupons.length == 2 && food == coupons[1][:item] && coupons[0][:item] != coupons[1][:item]
    		cart["#{food} W/COUPON"] = coupon_hash2
    		if cart[food][:clearance] == true
				coupon_hash2[:clearance] = true
			else
				coupon_hash2[:clearance] = false
			end
			coupon_hash2[:price] = coupons[1][:cost]
			count = cart[food][:count]
			new_count = count - coupons[1][:num]
			cart[food][:count] = new_count
		end
    end 
    cart
end

def apply_clearance(cart:[])
  cart.each do |food, attrs|
  	if attrs[:clearance]
  		old_price = attrs[:price]
  		new_price = old_price*0.8
  		attrs[:price] = new_price.round(1)
  	end
  end
end

def checkout(cart: [], coupons: [])
	new_cart = consolidate_cart(cart: cart)
	newer_cart = apply_coupons(cart: new_cart, coupons: coupons)
	best_cart = apply_clearance(cart: newer_cart)
	total_price = 0
	best_cart.each do |food, attrs|
		quantity = attrs[:count]
		total_price = total_price + attrs[:price]*quantity
	end
	if total_price>100
		total_price = total_price*0.9
	end
	total_price.round(2)
end



