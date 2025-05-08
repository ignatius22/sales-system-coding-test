require './basket'

basket = Basket.new
basket.add('B01')
basket.add('G01')
basket.total
puts "Custom basket total: $#{format('%.2f', basket.total)}"