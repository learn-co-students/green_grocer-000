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
  cart_with_coupons = {}
  cart.each{|item,item_info|
    if !cart_with_coupons.include?(item)
      item_info[:count] = cart[item][:count]
      cart_with_coupons[item] = item_info
    else
      cart_with_coupons[item][:count] += cart[item][:count]
    end
  }
  coupons.each{|coupon|
    item_with_coupon = "#{coupon[:item]} W/COUPON"
    if !cart_with_coupons.include?(item_with_coupon) && cart_with_coupons.include?(coupon[:item])
      cart_with_coupons[item_with_coupon] = { price: coupon[:cost], 
                                              clearance: cart_with_coupons[coupon[:item]][:clearance],
                                              num:  coupon[:num],
                                              count: 1
                                            }
    elsif cart_with_coupons.include?(item_with_coupon)
      cart_with_coupons[item_with_coupon][:count] += 1
    end
  }
  cart_with_coupons.each{|item, item_info|
    if !item.include?"W/COUPON"
      item_with_coupon = "#{item} W/COUPON"
      if cart_with_coupons.include? "#{item} W/COUPON"
        item_with_coupon_count = 0
        until cart_with_coupons[item_with_coupon][:count] <= 0 || cart_with_coupons[item][:count] <= 0
          cart_with_coupons[item_with_coupon][:count] -= 1
          cart_with_coupons[item][:count] -= cart_with_coupons[item_with_coupon][:num]
          item_with_coupon_count += 1
            if cart_with_coupons[item][:count] < 0   ### changed for negative, differance between coupons and items to be kicked back to the item
              cart_with_coupons[item][:count] = cart_with_coupons[item][:count].abs
            end
        end
        cart_with_coupons[item_with_coupon][:count] = item_with_coupon_count
      end
    end
  }
  cart_with_coupons
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
  apply_clearance(cart: apply_coupons(cart: consolidate_cart(cart: cart), coupons: coupons)).each{|item, item_info|
    if item_info.include?(:num) && item_info[:num] * item_info[:count] > consolidate_cart(cart: cart)[item.split.first].count
      cart_total += (item_info[:count].to_f/item_info[:num].to_f) * item_info[:price].to_f
    else
      cart_total += (item_info[:price] * item_info[:count])
    end
  }
  if cart_total > 100
    cart_total = cart_total - (cart_total * 0.1)
  end
  cart_total
end