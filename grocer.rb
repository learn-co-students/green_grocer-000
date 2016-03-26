def consolidate_cart(cart:[])
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

def apply_coupons(cart:[], coupons:[])
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

def apply_clearance(cart:[])
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

def checkout(cart: [], coupons:[])
  # code here
  cons = consolidate_cart(cart: cart)
  applied = apply_coupons(cart: cons, coupons: coupons)
  clear = apply_clearance(cart:applied)
  total = 0
  clear.each do |item, details|
      total += clear[item][:price] * clear[item][:count]
  end
  if total > 100
    discount = total * 0.1
    total = total - discount
  end
  total
end



# When checking out, follow these steps *in order*:

# * Apply coupon discounts if the proper number of items are present.

# * Apply 20% discount if items are on clearance.

# * If, after applying the coupon discounts and the clearance discounts, the cart's total is over $100, then apply a 10% discount.

# ### Named Parameters

# The method signature for the checkout method is 
# `consolidate_cart(cart:[])`. This, along with the checkout method uses a ruby 2.0 feature called [Named Parameters](http://brainspec.com/blog/2012/10/08/keyword-arguments-ruby-2-0/).

# Named parameters give you more expressive code since you are specifying what each parameter is for. Another benefit is the order you pass your parameters doesn't matter!
# `checkout(cart: [], coupons: [])` is the same as `checkout(coupons: [], cart: [])`

