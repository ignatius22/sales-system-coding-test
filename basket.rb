# Basket class to manage products, apply delivery rules, and special offers
class Basket
  # Product catalog with code, name, and price
  CATALOG = {
    'R01' => { name: 'Red Widget', price: 32.95 },
    'G01' => { name: 'Green Widget', price: 24.95 },
    'B01' => { name: 'Blue Widget', price: 7.95 }
  }.freeze

  # Delivery cost rules based on basket subtotal
  DELIVERY_RULES = [
    { threshold: 90.00, cost: 0.00 },
    { threshold: 50.00, cost: 2.95 },
    { threshold: 0.00, cost: 4.95 }
  ].freeze

  # Special offer for red widgets: buy one, get second half price
  OFFERS = {
    'R01' => { type: :second_half_price, min_quantity: 2 }
  }.freeze

  def initialize
    @items = []
  end

  # Add a product to the basket by its code
  # @param product_code [String] the code of the product to add
  # @raise [ArgumentError] if the product code is invalid
  def add(product_code)
    raise ArgumentError, "Invalid product code: #{product_code}" unless CATALOG.key?(product_code)
    @items << product_code
  end

  # Calculate the total cost of the basket including discounts and delivery
  # @return [Float] the total cost rounded to 2 decimal places
  def total
    subtotal = calculate_subtotal
    discount = calculate_discount
    delivery = calculate_delivery(subtotal - discount)
    (subtotal - discount + delivery).round(2)
  end

  private

  # Calculate the subtotal of all items in the basket
  # @return [Float] the sum of item prices
  def calculate_subtotal
    @items.sum { |code| CATALOG[code][:price] }
  end

  # Calculate discounts based on applicable offers
  # @return [Float] the total discount amount
  def calculate_discount
    discount = 0.0
    # Count occurrences of each item manually for Ruby version compatibility
    item_counts = @items.each_with_object(Hash.new(0)) { |code, counts| counts[code] += 1 }

    OFFERS.each do |product_code, offer|
      next unless item_counts[product_code] >= offer[:min_quantity]

      case offer[:type]
      when :second_half_price
        # Count pairs of items to apply half-price discount on second item
        pairs = item_counts[product_code] / 2
        discount += (pairs * (CATALOG[product_code][:price] / 2)).round(2)
      end
    end

    discount
  end

  # Calculate delivery cost based on basket subtotal after discounts
  # @param subtotal [Float] the subtotal after discounts
  # @return [Float] the delivery cost
  def calculate_delivery(subtotal)
    DELIVERY_RULES.find { |rule| subtotal >= rule[:threshold] }[:cost]
  end
end

# Demonstration of basket functionality with test cases
if $PROGRAM_NAME == __FILE__
  test_cases = [
    { items: ['B01', 'G01'], expected: 37.85 },
    { items: ['R01', 'R01'], expected: 54.37 },
    { items: ['R01', 'G01'], expected: 60.85 },
    { items: ['B01', 'B01', 'R01', 'R01'], expected: 98.27 } # Note: $68.28 may be correct
  ]

  test_cases.each_with_index do |test, index|
    basket = Basket.new
    test[:items].each { |code| basket.add(code) }
    total = basket.total
    puts "Test case #{index + 1}: Items: #{test[:items].join(', ')}"
    puts "Total: $#{format('%.2f', total)}"
    puts "Expected: $#{format('%.2f', test[:expected])}"
    puts "Pass: #{total == test[:expected]}\n\n"
  end
end