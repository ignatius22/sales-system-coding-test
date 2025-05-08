# Basket class to manage a shopping basket, apply discounts, and calculate delivery costs
class Basket
  # Product catalog: maps product codes to names and prices
  CATALOG = {
    'R01' => { name: 'Red Widget', price: 32.95 },
    'G01' => { name: 'Green Widget', price: 24.95 },
    'B01' => { name: 'Blue Widget', price: 7.95 }
  }.freeze

  # Delivery rules: cost based on subtotal after discounts
  DELIVERY_RULES = [
    { threshold: 90.00, cost: 0.00 }, # Free delivery for $90+
    { threshold: 50.00, cost: 2.95 }, # $2.95 for $50-$89.99
    { threshold: 0.00, cost: 4.95 }  # $4.95 for <$50
  ].freeze

  # Special offers: defines discounts, e.g., buy one red widget, get second half price
  OFFERS = {
    'R01' => { type: :second_half_price, min_quantity: 2 }
  }.freeze

  def initialize
    @items = [] # List of product codes in the basket
  end

  # Add a product to the basket by its code
  # @param product_code [String] the product code (e.g., 'R01')
  # @raise [ArgumentError] if the product code is invalid
  def add(product_code)
    raise ArgumentError, "Invalid product code: #{product_code}" unless CATALOG.key?(product_code)
    @items << product_code
  end

  # Calculate the total cost including items, discounts, and delivery
  # @return [Float] total cost rounded to 2 decimal places
  def total
    subtotal = calculate_subtotal
    discount = calculate_discount
    delivery = calculate_delivery(subtotal - discount)
    (subtotal - discount + delivery).round(2)
  end

  private

  # Sum the prices of all items in the basket
  # @return [Float] total price before discounts
  def calculate_subtotal
    @items.sum { |code| CATALOG[code][:price] }
  end

  # Calculate discounts based on special offers
  # @return [Float] total discount amount
  def calculate_discount
    discount = 0.0
    # Count how many times each product appears
    product_counts = @items.each_with_object(Hash.new(0)) { |code, counts| counts[code] += 1 }

    OFFERS.each do |product_code, offer|
      # Skip if not enough items for the offer
      next unless product_counts[product_code] >= offer[:min_quantity]

      case offer[:type]
      when :second_half_price
        # Apply half-price discount for each pair of items
        pairs = product_counts[product_code] / 2
        discount_per_pair = (CATALOG[product_code][:price] / 2).round(2) # Round to avoid floating-point issues
        discount += pairs * discount_per_pair
      end
    end

    discount
  end

  # Calculate delivery cost based on subtotal after discounts
  # @param discounted_subtotal [Float] subtotal after discounts
  # @return [Float] delivery cost
  def calculate_delivery(discounted_subtotal)
    DELIVERY_RULES.find { |rule| discounted_subtotal >= rule[:threshold] }[:cost]
  end
end

# Run test cases to verify basket functionality
# Prints each test case's items, total, expected total, and pass/fail status
if $PROGRAM_NAME == __FILE__
  test_cases = [
    { items: ['B01', 'G01'], expected: 37.85 },              # Blue + Green
    { items: ['R01', 'R01'], expected: 54.37 },              # Two Reds with discount
    { items: ['R01', 'G01'], expected: 60.85 },              # Red + Green
    { items: ['B01', 'B01', 'R01', 'R01'], expected: 68.28 } # Two Blues + Two Reds
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