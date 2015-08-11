
def consolidate_cart(cart:[])
  cart.each do |outerhash|
    if outerhash[outerhash.keys[0]].has_key?(:count)
        outerhash[outerhash.keys[0]][:count] +=1
    else
        outerhash[outerhash.keys[0]].store(:count, 1)
    end
  end
  cart.uniq!
  cart.each_with_object({}) do |x, answer_hash|
    answer_hash.merge!(x)
  end
end

def apply_coupons(cart:[], coupons:[])
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) == true && (cart[(coupon[:item])][:count].to_i >= (coupon[:num]).to_i) == true && !(cart.has_key?("#{(coupon[:item])}" + " W/COUPON"))
      cart[(coupon[:item])][:count] -= (coupon[:num])
      cart["#{(coupon[:item])}" + " W/COUPON"] = {:price => (coupon[:cost]), :clearance => (cart[(coupon[:item])][:clearance]), :count => 1 }
    elsif cart.has_key?("#{(coupon[:item])}" + " W/COUPON")  && (cart[(coupon[:item])][:count].to_i >= (coupon[:num]).to_i)
      cart["#{(coupon[:item])}" + " W/COUPON"][:count] += 1
      cart[(coupon[:item])][:count] -= (coupon[:num])
    else
    end
  end
  cart
end

def apply_clearance(cart:[])
  cart.each_key do |groceryItem|
    if cart[groceryItem][:clearance]
      original = cart[groceryItem][:price]
      final = original * 0.80
      cart[groceryItem][:price] = final.round(2)
    else
    end
  end
  cart
end

def checkout(cart: [], coupons: [])
  total = 0
  newCart = consolidate_cart(cart: cart)
  newerCart = apply_coupons(cart: newCart, coupons: coupons)
  newestCart = apply_clearance(cart: newerCart)
  # binding.pry
  newerCart.each do |groceryItem, innerHash|
    total += (innerHash[:price] * innerHash[:count])
  end
  if total > 100
    total =total * 0.90.round(2)
  else
  end
  return total
end











