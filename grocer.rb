def consolidate_cart(cart)
  # code here
 new_hash = {}
  cart.each do |item_hashes|
    item_hashes.each do |item, details|
      new_hash[item] ||= details
      new_hash[item][:count] ||= 0
      new_hash[item][:count] += 1
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  # code here
  new_cart = cart
  coupons.each do |coupon|
    couponed_item = coupon[:item] 
    if cart[couponed_item] != nil
      coupon_cost = coupon[:cost] 
      orginal_item_remainder =  cart[couponed_item][:count] - coupon[:num] 
      if orginal_item_remainder >= 0
        new_coupon_name = couponed_item + " W/COUPON"
        new_cart[new_coupon_name] ||= {}
        new_cart[new_coupon_name][:price] = coupon_cost
        new_cart[new_coupon_name][:clearance] = cart[couponed_item][:clearance]
        new_cart[new_coupon_name][:count] ||= 0
        new_cart[new_coupon_name][:count] += 1
        new_cart[couponed_item][:count] = orginal_item_remainder
      end
    end
  end
  new_cart
end

def apply_clearance(cart)
  # code here
  new_cart = {}
  cart.each do |item, details|
    if details != nil
      new_cart[item] ||= details
      new_cart[item][:price] = new_cart[item][:price] - new_cart[item][:price] * 0.20 if new_cart[item][:clearance]
    end
  end
  new_cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  total = 0
  final_cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  total = total * 0.9 if total > 100
  total
end
