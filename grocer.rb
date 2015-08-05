def consolidate_cart(cart:[])
  # code here
  new_cart = {}
  cart.each do |x|
    if new_cart.has_key?(x.keys[0]) == false
      new_cart[x.keys[0]] = x[x.keys[0]]
      new_cart[x.keys[0]][:count] = 1
    else
      new_cart[x.keys[0]][:count] += 1
    end
  end
  new_cart
end

def apply_coupons(cart:[], coupons:[])
  # code here
  ##I need to make better comments going forward
    coupons.each do |x|
      if (cart.has_key?(x.values[0]) && cart[x.values[0]][:count] >= x.values[1])
        cart["#{x.values[0]} W/COUPON"] = {:price => x.values[2],:clearance => cart[x.values[0]][:clearance],:count => 0}
        while cart[x.values[0]][:count] >= x.values[1]
          cart[x.values[0]][:count]  -= x.values[1]
          cart["#{x.values[0]} W/COUPON"][:count] += 1
        end    
      end
    end
  return cart
end

def apply_clearance(cart:[])
  # code here
  cart.each do |x,y|
    if y[:clearance] == true
      cart[x][:price] = (cart[x][:price]*0.8).round(2)
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  # code here
  new_cart = consolidate_cart(cart:cart)
  new_cart = apply_coupons(cart:new_cart, coupons:coupons)
  new_cart = apply_clearance(cart:new_cart)

  total = 0
  new_cart.each do |x,y|
    total += y.values[0]*y.values[2]
  end
  if total >= 100
    total *= 0.9
  end 
  total
  
end



