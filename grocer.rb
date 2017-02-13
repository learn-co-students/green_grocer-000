require 'pry'

def consolidate_cart(cart)
  return_cart = {}
  cart.each do |item|
    item.each do |item_name, price_clearance_details|
      price = price_clearance_details[:price]
      clearance = price_clearance_details[:clearance]
      if return_cart[item_name] 
        return_cart[item_name][:count] += 1
      else 
        return_cart[item_name] = {price: price, clearance: clearance, count: 1}
      end
    end
  end
  return_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    item_hash = cart[item_name]
    if item_hash     
      cart_number = item_hash[:count]
      coupon_number = coupon[:num]
      
      if cart_number >= coupon_number
        item_name_with_coupon = "#{item_name} W/COUPON"
        if cart[item_name_with_coupon]
          cart[item_name_with_coupon][:count] += 1
        else 
          coupon_price = coupon[:cost]
          clearance = cart[item_name][:clearance]
          coupon_number_combined = 1

          cart[item_name_with_coupon] = {:price => coupon_price, :clearance => clearance, :count => coupon_number_combined}
        end
        cart[item_name][:count] -= coupon_number
      end
      
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item_name, item_details|
    if item_details[:clearance]
      original_price = cart[item_name][:price] 
      clearance_price = (original_price * 0.8).round(1)
      cart[item_name][:price] = clearance_price
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total_due = 0.0
  cart.each do |item_name, item_details|
    item_price = item_details[:price]
    item_count = item_details[:count]
    total_due += (item_price * item_count)
  end
  if total_due > 100.0 
    total_due = (total_due * 0.9)
  end
  total_due.round(2)

  # binding.pry
end

  # Apply coupon discounts if the proper number of items are present.
  # for each coupon, check if item in cart
  #   if number of item >= number of coupon
  #     apply coupons
  # coupon {:item=>"BEER", :num=>2, :cost=>20.0}
  # cart 