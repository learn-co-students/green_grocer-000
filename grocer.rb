require 'pry'
def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"AVOCADO" => {:price => 3.00, :clearance => true}},

		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}},
		{"KALE" => {:price => 3.00, :clearance => false}}
	]
end


def consolidate_cart(cart)
	hash = {}
	cart.each do |array|
		array.each do |item, shash|
			shash.each do |type, num|
				hash[item] ||= {}
				hash[item][type] ||= {}
				hash[item][type] = num
				hash[item][:count] ||= 0
			end
			hash[item][:count] += 1
		end
	end
	return hash
end

consolidate_cart(items)


def apply_coupons(cart, coupons)
	coupons.each do |couponHash|
    	item = couponHash[:item]
      	if cart.has_key?(item)
				cartCount = cart[item][:count]
				couponCount = cartCount / couponHash[:num]
				newCartCount = cartCount % couponHash[:num]
	         if couponCount > 0
	            cart[item][:count] = newCartCount
	            cart["#{item} W/COUPON"] = 
	            	{
							:price=> couponHash[:cost],
							:clearance=> cart[item][:clearance],
							:count=> couponCount
						}
	         end
        	end
   	end
	cart
end

def apply_clearance(cart)
	cart.each do |item, hash|
		hash.each do |type,val|
			if cart[item][:clearance]
				cart[item][:price] = (cart[item][:price]*0.8).round(2)
			end
			break
		end
	end
end

def checkout(cart, coupons)
	total = 0

  	consolidated = consolidate_cart( cart)
  	coupons_applied = apply_coupons(consolidated, coupons)
  	clearance_applied = apply_clearance(coupons_applied)

  	new_array = consolidated.collect do |item, properties|
 	   properties[:price] * properties[:count]
  	end
  	#binding.pry

	new_array.each do |x| 
		total += x 
	end

	if total >= 100
		total = (total * 0.9).round(2)
	end
	total
end
