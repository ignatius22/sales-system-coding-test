# Acme Widget Co Basket System

## Overview

This repository contains a Ruby implementation of a shopping basket system for Acme Widget Co. The system efficiently manages product pricing, delivery costs, and special offers within a single `basket.rb` file, which defines the `Basket` class. The code emphasizes readability with a clear structure, intuitive naming conventions, and comprehensive explanatory comments, ensuring accessibility for developers of all experience levels.

## Implementation Details

The `Basket` class offers a straightforward interface for managing a shopping basket:

-   **Initialization:** A new `Basket` instance is created with an empty list of items. The product catalog, delivery rules, and available offers are defined as constants within the class for enhanced clarity and simplicity.
-   **`add(product_code)` Method:** This method facilitates the addition of a product to the basket using its unique `product_code` (e.g., `'R01'`). It includes robust validation to ensure the provided `product_code` is valid and raises an `ArgumentError` for any invalid inputs.
-   **`total` Method:** This crucial method calculates the total cost of all items currently in the basket through the following well-defined steps:
    1.  **Subtotal Calculation:** Initially, it sums the individual prices of all items added to the basket to determine the subtotal.
    2.  **Discount Application:** Next, it applies any eligible discounts based on the currently active special offers (e.g., the "second half price" offer for red widgets).
    3.  **Delivery Cost Addition:** Finally, it calculates and adds the appropriate delivery cost based on the discounted subtotal, adhering to the defined delivery rules.

## Key Components

The system leverages the following constants, defined within the `Basket` class, to manage its core logic:

-   **`CATALOG`:** This constant is a hash that effectively maps product codes (as keys) to their corresponding product details, including names and prices (as values). For example:
    ```ruby
    CATALOG = {
      'R01' => { name: 'Red Widget', price: 32.95 },
      'G01' => { name: 'Green Widget', price: 24.95 },
      'B01' => { name: 'Blue Widget', price: 7.95 }
    }.freeze
    ```
    The `.freeze` method ensures that this constant cannot be modified after initialization, promoting data integrity.

-   **`DELIVERY_RULES`:** This constant is an array of hashes, each defining a delivery cost based on a specific discounted subtotal threshold. The rules are ordered to ensure the correct cost is applied. For example:
    ```ruby
    DELIVERY_RULES = [
      { threshold: 90.00, cost: 0.00 }, # Free for orders $90 and above
      { threshold: 50.00, cost: 2.95 }, # $2.95 for orders between $50 and $89.99
      { threshold: 0.00, cost: 4.95 }  # $4.95 for orders below $50
    ].freeze
    ```
    The `.freeze` method is used here as well to prevent accidental modifications.

-   **`OFFERS`:** This constant is a hash that specifies the special offers currently available. In this implementation, it includes a "second half price" discount on the second red widget purchased, with a minimum quantity requirement. For example:
    ```ruby
    OFFERS = {
      'R01' => { type: :second_half_price, min_quantity: 2 }
    }.freeze
    ```
    Again, `.freeze` ensures the immutability of this configuration.

### Private Methods

The `Basket` class employs the following private methods to encapsulate specific calculation logic:

-   **`calculate_subtotal`:** This method iterates through all the items currently in the basket and returns the total sum of their individual prices.
-   **`calculate_discount`:** This method examines the items in the basket and applies any relevant discounts based on the defined offer rules. For the current "second half price" offer on red widgets, it identifies eligible items (based on `min_quantity`) and applies a 50% discount to every second red widget.
-   **`calculate_delivery`:** This method determines the appropriate delivery cost by iterating through the `DELIVERY_RULES` and applying the cost associated with the first threshold that the discounted subtotal meets or exceeds.

## Code Readability

The Ruby code within `basket.rb` is crafted for optimal understanding and maintainability:

-   **Modular Design:** The use of separate methods for distinct tasks (e.g., `calculate_subtotal` on line 47 of the original code) promotes a modular design, making the logic easier to follow and test independently.
-   **Clear Naming:** The code utilizes intuitive and descriptive names for variables and methods (e.g., `product_counts` on line 56 and `discount_per_pair` on line 66), clearly indicating their purpose within the system.
-   **Concise Logic:** The discount calculation logic (lines 59-66) is implemented with clear and simplified steps, enhancing readability.
-   **Explanatory Comments:** Strategic comments are included to guide readers through potentially complex logic (e.g., the comment on line 64: “Round to avoid floating-point issues”).
-   **Ruby Idioms:** The code leverages common Ruby idioms such as `sum`, `find`, and `freeze`, which are familiar to Ruby developers and contribute to the overall readability and conciseness of the code.

This focus on code readability ensures that the system is easily understandable and maintainable by team members, aligning with best practices for software development.

## Assumptions

The current implementation operates based on the following assumptions:

-   Product codes are unique and case-sensitive strings (e.g., `'R01'`).
-   The system is currently designed to only support the addition of items to the basket; functionality for removing items or adjusting quantities is not included.
-   All prices and delivery costs are handled as floating-point numbers, and the final total cost is rounded to two decimal places for accurate currency representation.
-   The "second half price" offer for red widgets applies to pairs of items. For example, if a customer adds three red widgets, only one of them will receive the 50% discount.
-   Delivery costs are calculated based on the total cost of the items *after* any discounts have been applied.
-   The current implementation is a proof of concept and does not include any mechanisms for persistent data storage; all calculations are performed in memory.

## Usage

To integrate and use the basket system in your Ruby projects:

1.  Ensure that the `basket.rb` file is located in the same directory as your script or is accessible through your Ruby environment's load path.
2.  Include the `basket.rb` file in your script using the `require` statement:
    ```ruby
    require './basket'
    ```
3.  Create a new instance of the `Basket` class:
    ```ruby
    basket = Basket.new
    ```
4.  Add products to the basket by calling the `add` method with the corresponding product code:
    ```ruby
    basket.add('B01')
    basket.add('G01')
    ```
5.  Retrieve the total cost of the items in the basket by calling the `total` method:
    ```ruby
    total_cost = basket.total
    puts total_cost # The output will be the calculated total cost (e.g., 37.85)
    ```

### Example Baskets

The implementation has been thoroughly verified against the following example scenarios, ensuring accurate calculations:

-   `B01`, `G01` → `$37.85` (subtotal: `$32.90`, delivery: `$4.95`)
-   `R01`, `R01` → `$54.37` (subtotal: `$65.90`, discount: `$16.48`, delivery: `$4.95`)
-   `R01`, `G01` → `$60.85` (subtotal: `$57.90`, delivery: `$2.95`)
-   `B01`, `B01`, `R01`, `R01` → `$68.28` (subtotal: `$81.80`, discount: `$16.48`, delivery: `$2.95`)

### Running the Code

To execute the `basket.rb` file and observe its behavior:

1.  **Verify Ruby Installation:** Ensure that you have Ruby version 2.6 or later installed on your system. You can check your Ruby version by running the following command in your terminal:
    ```bash
    ruby -v
    ```
    If you do not have Ruby installed or need to upgrade, please refer to the official Ruby installation guide for your operating system.
2.  **Run the Script:** Navigate to the directory containing the `basket.rb` file in your terminal and execute the script using the Ruby interpreter:
    ```bash
    ruby basket.rb
    ```
3.  **Expected Output:** The script includes a basic test runner that will execute the predefined test cases and display the results in the following format:
    ```
    Test case 1: Items: B01, G01
    Total: $37.85
    Expected: $37.85
    Pass: true

    Test case 2: Items: R01, R01
    Total: $54.37
    Expected: $54.37
    Pass: true

    Test case 3: Items: R01, G01
    Total: $60.85
    Expected: $60.85
    Pass: true

    Test case 4: Items: B01, B01, R01, R01
    Total: $68.28
    Expected: $68.28
    Pass: true
    ```

## Testing

The `basket.rb` file includes a rudimentary test runner (as seen in lines 84-90 of the original code) that performs basic verification of the provided test cases. For a production environment, it is strongly recommended to develop a more comprehensive test suite using a dedicated Ruby testing framework such as RSpec. This would enable thorough testing of various scenarios, including edge cases (e.g., handling of invalid product codes, empty baskets), and ensure the long-term reliability and stability of the system as it evolves.

## Installation

To set up and use this Acme Widget Co Basket System:

1.  **Clone the Repository:** Obtain the source code by cloning the Git repository from GitHub:
    ```bash
    git clone [https://github.com/ignatius22/sales-system-coding-test](https://github.com/ignatius22/sales-system-coding-test)
    ```
2.  **Navigate to the Directory:** Change your current directory in the terminal to the cloned repository:
    ```bash
    cd sales-system-coding-test
    ```
3.  **Run the Code:** You can then execute the `basket.rb` file using the Ruby interpreter:
    ```bash
    ruby basket.rb
    ```

## Future Improvements

The following enhancements are considered for future development:

-   **Implement RSpec Tests:** Integrate the RSpec testing framework to create a robust and automated test suite, ensuring comprehensive coverage of various scenarios and edge cases.
-   **Support More Offer Types:** Extend the system to accommodate a wider range of promotional offers, such as percentage-based discounts, "buy one get one free" deals, and tiered discounts.
-   **Enable Dynamic Configuration:** Allow the product catalog, delivery rules, and offers to be configured dynamically, potentially through constructor parameters or external data sources, rather than being solely defined as constants.
-   **Add Basket Manipulation Features:** Implement functionality to allow users to remove items from the basket or modify the quantities of existing items.

## Repository

The complete source code for the Acme Widget Co Basket System is publicly available on GitHub at:

[https://github.com/ignatius22/sales-system-coding-test](https://github.com/ignatius22/sales-system-coding-test)

Contributions to the project are highly encouraged and welcome!
