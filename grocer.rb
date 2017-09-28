


def consolidate_cart(cart)
  # code here
  count = 1
  new_hash = {}
  cart.each do |item|
    item.each do |k, v|
      if new_hash[k]
        count += 1
      else count = 1
      end
      new_hash[k] ||= {}
      new_hash[k] = v.merge!(:count => count)
    end
  end
new_hash
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    name = coupon[:item]
      if cart[name] && cart[name][:count] >= coupon[:num]
        if cart["#{name} W/COUPON"]
          cart["#{name} W/COUPON"][:count] += 1
        else
        cart["#{name} W/COUPON"] = {:count => 1, :price => coupon[:cost], :clearance => cart[name][:clearance]}
        #cart["#{name} W/COUPON"][:clearance] = cart[name][:clearance]
        end
        cart[name][:count] -= coupon[:num]
      end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance]
      new_price = info[:price] * 0.80
      info[:price] = new_price.round(2)
    end
  end
  cart
  # code here
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  with_coupons = apply_coupons(consolidated_cart, coupons)
  final = apply_clearance(with_coupons)
  total = 0
  final.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
  # code here
end



#apply_clearance(cart)
#apply_coupons(cart, coupons)
#consolidate_cart(cart)
