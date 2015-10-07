def consolidate_cart(cart:[])
  consolidated_cart = Hash.new
  cart.each {|item|
    if consolidated_cart.has_key?(item.keys[0]) then consolidated_cart[item.keys[0]][:count] +=1
    else consolidated_cart[item.keys[0]] = item[item.keys[0]] and consolidated_cart[item.keys[0]][:count] =1 end 
    }
  consolidated_cart
end

def apply_coupons(cart:[], coupons:[])
  coupon_hash = Hash.new
  if coupons.length>0 then 
      coupons.each{|coupon| 
        if cart.has_key?(coupon[:item]) then
          cart[coupon[:item]+ " W/COUPON"] = {:price => 0, :clearance => true, :count => 0}
          cart[coupon[:item]+ " W/COUPON"][:price] =  coupon[:cost]
          cart[coupon[:item]+ " W/COUPON"][:clearance] = cart[coupon[:item]][:clearance]
          cart[coupon[:item]+ " W/COUPON"][:count] += 1
          if cart[coupon[:item]][:count] >= coupon[:num] then
          cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
        end
     end
      }
  end
  cart
end

def apply_clearance(cart:[])
  cart.each {|key, value| 
    if value[:clearance] then cart[key][:price] = (cart[key][:price]*0.8).round(2) end}
  cart
end

def checkout(cart: [], coupons: [])
  newcart = consolidate_cart(cart: cart)
  newcart = apply_coupons(cart:newcart, coupons:coupons)
  newcart = apply_clearance(cart:newcart)
  total = 0
  newcart.each {|key, value| total+=newcart[key][:price]*newcart[key][:count] }
  if total > 100 then total = total*0.9
  end
  total
end

