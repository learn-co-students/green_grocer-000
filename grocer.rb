require 'pry'

ITEMS = [
      {"AVOCADO" => {:price => 3.00, :clearance => true}},
      {"KALE" => {:price => 3.00, :clearance => false}},
      {"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
      {"ALMONDS" => {:price => 9.00, :clearance => false}},
      {"TEMPEH" => {:price => 3.00, :clearance => true}},
      {"CHEESE" => {:price => 6.50, :clearance => false}},
      {"BEER" => {:price => 13.00, :clearance => false}},
      {"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
      {"BEETS" => {:price => 2.50, :clearance => false}},
      {"SOY MILK" => {:price => 4.50, :clearance => true}}
    ]

COUPS = [
      {:item => "AVOCADO", :num => 2, :cost => 5.00},
      {:item => "BEER", :num => 2, :cost => 20.00},
      {:item => "CHEESE", :num => 3, :cost => 15.00}
    ]

def consolidate_cart(cart:[])
  # code here
  

  new_cart = {} 

  cart.each do |item|
    item.each do |food, attributes|
      if new_cart[food].nil?
        new_cart[food] = attributes
        new_cart[food][:count] = 1
      else
        new_cart[food][:count] += 1
      end
    end
  end
  new_cart
end


def apply_coupons(cart:[], coupons:[])
  
  coupons.each do |coupon|
    name = coupon[:item]
    
    if cart[name] && cart[name][:count] >= coupon[:num]
      new_name = name + " W/COUPON"
      if cart[new_name]
        cart[new_name][:count] += 1
      else
        cart[new_name] = {:price => coupon[:cost], :count => 1} 
        cart[new_name][:clearance] = cart[name][:clearance]
      end
      
      cart[name][:count] -= coupon[:num]
    end
    
  end
  cart

end

def apply_clearance(cart:[])
  # code here

  cart.each do |item, attributes|
    if attributes[:clearance] == true
      new_round_num = (attributes[:price] *= 0.8).round(2)
      attributes[:price] = new_round_num
    end
  end

end


def checkout(cart: [], coupons: [])
  # code here


  total = 0
  new_cart = consolidate_cart(:cart=>cart)
  new_cart = apply_coupons(:cart=>new_cart, :coupons=>coupons)
  new_cart = apply_clearance(:cart=>new_cart)
  
  new_cart.each do |item, attributes|
    total += attributes[:price] * attributes[:count]
  end
  
  if total > 100
    total = (total * 0.9).round(2)
  end
  total

end

#apply_coupons(ITEMS, COUPS)


