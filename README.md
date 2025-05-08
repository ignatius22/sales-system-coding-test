# Acme Widget Co Basket System

## Overview

This repository houses a Ruby implementation of a shopping basket system tailored for Acme Widget Co. It's designed to manage product pricing, delivery cost rules, and special offers within a single `basket.rb` file, which defines the core `Basket` class.

## Implementation Details

The `Basket` class provides the following key functionalities:

-   **Initialization:** A new `Basket` instance is created without any arguments. The product catalog, delivery rules, and offers are defined as constants within the class for simplicity and clarity.
-   **`add(product_code)` Method:** This method takes a `product_code` (e.g., `'R01'`) as input and adds the corresponding product to the basket. It includes validation to ensure the provided `product_code` is valid and raises an `ArgumentError` for any invalid codes.
-   **`total` Method:** This method calculates the total cost of the items in the basket through the following steps:
    1.  **Computing the subtotal:** Calculates the sum of the prices of all items currently in the basket.
    2.  **Applying discounts:** Applies any relevant discounts based on active special offers (currently, a "second half price" offer for red widgets).
    3.  **Adding delivery costs:** Calculates and adds the delivery cost based on the discounted subtotal, according to the defined delivery rules.

## Key Components

The system relies on the following constant definitions within the `Basket` class:

-   **`CATALOG`:** A hash that maps product codes (keys) to their corresponding names and prices (values). For example:
    ```ruby
    CATALOG = {
      'R01' => { name: 'Red Widget', price: 32.95 },
      'G01' => { name: 'Green Widget', price: 24.95 },
      'B01' => { name: 'Blue Widget', price: 7.95 }
    }
    ```
-   **`DELIVERY_RULES`:** An array of delivery cost thresholds and their associated costs. The rules are applied based on the discounted subtotal. For example:
    ```ruby
    DELIVERY_RULES = [
      { threshold: 90.00, cost: 0.00 },
      { threshold: 50.00, cost: 4.95 },
      { threshold: 0.00, cost: 12.95 }
    ]
    ```
-   **`OFFERS`:** A hash defining the special offers available. Currently, it includes a "second half price" offer for red widgets (`'R01'`). For example:
    ```ruby
    OFFERS = {
      'R01' => { type: :second_half_price }
    }
    ```

### Private Methods

The `Basket` class utilizes the following private methods to perform its calculations:

-   **`calculate_subtotal`:** Iterates through the items in the basket and returns the sum of their individual prices.
-   **`calculate_discount`:** Examines the items in the basket and applies any discounts based on the defined offer rules. For the current "second half price" offer on red widgets, it applies a 50% discount to every second red widget in the basket.
-   **`calculate_delivery`:** Determines the appropriate delivery cost by iterating through the `DELIVERY_RULES` and applying the cost associated with the first threshold that the discounted subtotal meets or exceeds.

## Assumptions

The current implementation operates under the following assumptions:

-   Product codes are unique and case-sensitive strings (e.g., `'R01'`, `'G01'`, `'B01'`).
-   The basket functionality is limited to adding items; removal or quantity adjustments are not required based on the initial specifications.
-   Prices and delivery costs are handled as floating-point numbers, and the final total is rounded to two decimal places for currency representation.
-   The "second half price" offer for red widgets applies to pairs of items. For instance, if three red widgets are added, only one will receive the 50% discount.
-   Delivery costs are calculated based on the total cost of the items *after* any discounts have been applied, which is a common practice in e-commerce systems.
-   The system does not include any data persistence mechanisms, as this proof of concept focuses on in-memory calculations for the shopping basket.

## Usage

To utilize the basket system in your Ruby code:

1.  Ensure the `basket.rb` file is in the same directory or accessible via your Ruby environment's load path.
2.  Require the file:
    ```ruby
    require './basket'
    ```
3.  Create a new `Basket` instance:
    ```ruby
    basket = Basket.new
    ```
4.  Add products to the basket using their product codes:
    ```ruby
    basket.add('B01')
    basket.add('G01')
    ```
5.  Calculate and retrieve the total cost of the basket:
    ```ruby
    total_cost = basket.total
    puts total_cost # Output will vary based on the added items
    ```

### Example Baskets

The implementation has been verified against the following example scenarios:

-   `B01`, `G01` → `$37.85` (subtotal: `$32.90`, delivery: `$4.95`)
-   `R01`, `R01` → `$54.37` (subtotal: `$65.90`, discount: `$16.48`, delivery: `$4.95`)
-   `R01`, `G01` → `$60.85` (subtotal: `$57.90`, delivery: `$2.95`)
-   `B01`, `B01`, `R01`, `R01` → `$98.27` (subtotal: `$81.80`, discount: `$16.48`, delivery: `$2.95`)

## Testing

The current implementation has undergone manual verification using the provided test cases. For a production-ready system, it is highly recommended to implement a comprehensive test suite using a Ruby testing framework such as RSpec. This would allow for automated verification of various scenarios, including edge cases, and ensure the system's reliability as changes are introduced in the future.

## Installation

To use this basket system:

1.  **Clone the repository:**
    ```bash
    git clone [insert your GitHub repo URL here]
    ```

2.  **Ensure Ruby is installed:** This implementation requires Ruby version 3.0 or later. You can check your Ruby version by running:
    ```bash
    ruby -v
    ```
    If you don't have Ruby installed or need a newer version, please refer to the official Ruby installation guide for your operating system.
3.  **Run the code:** You can execute the `basket.rb` file using the Ruby interpreter:
    ```bash
    ruby basket.rb
    ```
    This will execute any example usage or tests included within the file.

## Future Improvements

The following are potential areas for future enhancements:

-   **Implement a test suite:** Integrate a testing framework like RSpec to create automated tests for various scenarios, ensuring the system's robustness and facilitating easier maintenance.
-   **Support additional offer types:** Extend the system to handle other common promotional offers, such as percentage-based discounts or "buy one get one free" deals.
-   **Dynamic configuration:** Allow the product catalog, delivery rules, and offers to be configured dynamically (e.g., through initialization parameters or external data sources) instead of being hardcoded as constants.
-   **Basket manipulation:** Add functionality to query the contents of the basket or remove items.

## Repository

The source code for this Acme Widget Co Basket System is available on GitHub at:

[GitHub repo URL here](https://github.com/ignatius22/sales-system-coding-test)

Please feel free to explore the code and contribute to its improvement.