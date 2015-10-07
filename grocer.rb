require 'Pry'

def consolidate_cart(cart:[])
  consolidated_cart = {}
  cart.each{|item_hash|
    item_hash.each{|item, item_info|
      if !consolidated_cart.include?(item)
        item_info[:count] = 1
        consolidated_cart[item] = item_info
      else 
        consolidated_cart[item][:count] +=  1
      end
    }
  }
  consolidated_cart
end

def apply_coupons(cart:[], coupons:[])
  coupons.each{|coupon|
    if cart.include?("#{coupon[:item]} W/COUPON")
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
      cart[coupon[:item]][:count] -= coupon[:num]
    elsif cart.include?coupon[:item]
      cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :num => coupon[:num], :count => 1}
      cart[coupon[:item]][:count] -= coupon[:num]
    end
  }
  cart
end

def apply_clearance(cart:[])
  cart.each{|item, item_info|
    if cart[item][:clearance]
      cart[item][:price] = cart[item][:price] - (cart[item][:price] * 0.2) 
    end
  }
end


def checkout(cart: [], coupons: [])
  cart_total = 0.0
  consolidated_cart = consolidate_cart(cart: cart)
  coupons_applied = apply_coupons(cart: consolidated_cart, coupons: coupons)
  final_cart = apply_clearance(cart: coupons_applied)
  final_cart.each{|item, item_info|
  if item_info[:count] < 0
    cart_total += (item_info[:count] * item_info[:price]).abs
  elsif item.include?("COUPON") && item_info[:count] > final_cart[item.split.first][:count]
    cart_total += (item_info[:count] + final_cart[item.split.first][:count]) * item_info[:price]
  else 
    cart_total += item_info[:count] * item_info[:price]
  end
  }
  if cart_total > 100
    cart_total = cart_total - (cart_total * 0.1)
  end
  cart_total
end