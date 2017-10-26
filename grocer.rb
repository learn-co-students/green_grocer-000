def consolidate_cart(cart)
  unique_items = []
  unique_items = cart.uniq
  for i in unique_items
    count = 0
    cart.each do |x|
      if x == i
        count += 1
      end
    end

    i.each do |k,v|
      v[:count] = count
    end
  end

new_cart = {}
cart = unique_items
  cart.each do |y|
    y.each {|p,q| new_cart[p] = q}
  end
return new_cart
end

def apply_coupons(cart, coupons)
    coupon_hash = {}
    coupons.each {|x| coupon_hash[x[:item]] = {:num=>x[:num],:cost=>x[:cost]}}
    w_coupon = {}
    cart.each do |k,v|
      coupon_hash.each do |ck,cv|
        if k == ck
          temp = v[:count] % cv[:num]
          w_coupon[k +' W/COUPON'] = {:price => cv[:cost],
            :clearance => v[:clearance], :count => v[:count]/cv[:num]}
          v[:count] = temp
        end
      end
    end
  w_coupon.each {|k,v| cart[k] = v}
return cart
end

def apply_clearance(cart)
  cart.each do |k,v|
  unless v[:clearance] == false
    v[:price] = (v[:price]*(0.8)).round(2)
  end
end
return cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  apply_coupons(cart,coupons)
  apply_clearance(cart)

  total = 0
  
  cart.each do |k,v|
    total += (v[:price] * v[:count])
  end

  if total > 100
    total = total * 0.9
  end
return total
end
