# Pine Script v6 Type Casting Comprehensive Guide

Type casting and type management are crucial aspects of Pine Script v6 development. This guide covers the type system, casting operations, qualifiers, and best practices for robust script development.

## Table of Contents
1. [Type System Overview](#type-system-overview)
2. [Explicit Casting](#explicit-casting)
3. [Implicit Conversions](#implicit-conversions)
4. [Series vs Simple Context](#series-vs-simple-context)
5. [Type Qualifiers](#type-qualifiers)
6. [User-Defined Types](#user-defined-types)
7. [Type Checking Functions](#type-checking-functions)
8. [Common Type Errors and Fixes](#common-type-errors-and-fixes)

---

## Type System Overview

### Built-in Types in Pine Script v6
```pinescript
//@version=6
indicator("Type System Overview", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  FUNDAMENTAL TYPES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Integer types
int_value = 42
var int persistent_int = 0

// Float types
float_value = 3.14159
var float persistent_float = 0.0

// Boolean types
bool_value = true
var bool persistent_bool = false

// String types
string_value = "Hello Pine Script"
var string persistent_string = ""

// Color types
color_value = color.blue
var color persistent_color = color.white

// Special value: na (not available)
na_value = na

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  COLLECTION TYPES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Array types
var int_array = array.new<int>()
var float_array = array.new<float>()
var string_array = array.new<string>()
var bool_array = array.new<bool>()

// Matrix types
var float_matrix = matrix.new<float>()
var int_matrix = matrix.new<int>()

// Map types
var string_to_float_map = map.new<string, float>()
var string_to_int_map = map.new<string, int>()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  DRAWING TYPES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Line type
var line current_line = na

// Label type
var label current_label = na

// Box type
var box current_box = na

// Table type
var table info_table = na

// Polyline type
var polyline current_polyline = na

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  TYPE DEMONSTRATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to demonstrate type usage
demonstrate_types() =>
    # Numeric operations
    int_result = int_value + 10
    float_result = float_value * 2.0
    
    # String operations
    concatenated = string_value + " v6"
    
    # Boolean operations
    bool_result = bool_value and true
    
    # Array operations
    array.push(int_array, int_result)
    array.push(float_array, float_result)
    array.push(string_array, concatenated)
    array.push(bool_array, bool_result)
    
    # Return multiple types
    [int_result, float_result, concatenated, bool_result]

# Execute demonstration
[demo_int, demo_float, demo_string, demo_bool] = demonstrate_types()

// Plot numeric results
plot(demo_int, "Integer Result", color.blue)
plot(demo_float, "Float Result", color.red)

// Display string and boolean results
if barstate.islast
    if na(info_table)
        info_table := table.new(position.top_right, 2, 4)
    
    table.clear(info_table, 0, 0, 1, 3)
    table.cell(info_table, 0, 0, "Type", bgcolor=color.navy, text_color=color.white)
    table.cell(info_table, 1, 0, "Value", bgcolor=color.navy, text_color=color.white)
    
    table.cell(info_table, 0, 1, "String")
    table.cell(info_table, 1, 1, demo_string)
    
    table.cell(info_table, 0, 2, "Boolean")
    table.cell(info_table, 1, 2, str.tostring(demo_bool))
    
    table.cell(info_table, 0, 3, "Array Sizes")
    table.cell(info_table, 1, 3, str.tostring(array.size(int_array)))
```

### Type Qualifiers Explained
```pinescript
//@version=6
indicator("Type Qualifiers", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  SIMPLE QUALIFIER
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simple types - values that don't change during script execution
simple int LOOKBACK_PERIOD = 20           // Compile-time constant
simple float MULTIPLIER = 2.0              // Compile-time constant
simple string TITLE = "My Indicator"       // Compile-time constant
simple bool SHOW_SIGNALS = true            // Compile-time constant

// Input values are automatically simple qualified
period = input.int(14, "Period")           // simple int
threshold = input.float(70.0, "Threshold") // simple float
source = input.source(close, "Source")     // series float (note: source can be series)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  SERIES QUALIFIER
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Series types - values that can change on each bar
series float price_data = close            // Changes each bar
series int volume_data = int(volume)       // Changes each bar
series bool signal = ta.crossover(close, ta.sma(close, 20))  // Changes each bar

// Calculated values are typically series
series float rsi_value = ta.rsi(close, period)
series float sma_value = ta.sma(close, period)
series float ema_value = ta.ema(close, period)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONST QUALIFIER
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Const types - compile-time constants (rare in practice)
// These are usually defined as simple constants
PI = 3.14159265359         // Effectively const
E = 2.71828182846          // Effectively const
GOLDEN_RATIO = 1.61803398  // Effectively const

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              QUALIFIER INTERACTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function demonstrating qualifier requirements
calculate_moving_average(series float src, simple int len) =>
    # src must be series (can change per bar)
    # len must be simple (constant during execution)
    ta.sma(src, len)

// Function with mixed qualifiers
analyze_trend(series float price, simple int short_period, simple int long_period) =>
    short_ma = ta.sma(price, short_period)
    long_ma = ta.sma(price, long_period)
    
    trend_direction = short_ma > long_ma ? 1 : short_ma < long_ma ? -1 : 0
    trend_strength = math.abs(short_ma - long_ma) / long_ma * 100
    
    [trend_direction, trend_strength]

// Usage examples
ma_10 = calculate_moving_average(close, 10)      # close is series, 10 is simple
ma_20 = calculate_moving_average(close, period)  # period is simple from input

[trend_dir, trend_str] = analyze_trend(close, 10, 20)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              QUALIFIER VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to validate qualifier compatibility
validate_qualifiers() =>
    # ✅ Valid: series can be used where series is expected
    valid_series = ta.sma(close, period)  # close is series, period is simple
    
    # ✅ Valid: simple can be used where simple is expected
    valid_simple = period + 5  # Both are simple
    
    # ✅ Valid: simple can be "promoted" to series context
    promoted_to_series = close + 1.0  # 1.0 (simple) promoted to series
    
    # ❌ Invalid: series cannot be used where simple is required
    # invalid_usage = ta.sma(close, int(volume))  # volume is series, not allowed
    
    [valid_series, valid_simple, promoted_to_series]

[val_series, val_simple, val_promoted] = validate_qualifiers()

plot(ma_10, "MA 10", color.blue)
plot(ma_20, "MA 20", color.red)
plot(trend_str, "Trend Strength", color.orange)
```

---

## Explicit Casting

### Manual Type Conversions
```pinescript
//@version=6
indicator("Explicit Type Casting", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  NUMERIC CASTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Float to Integer casting
float_price = close
int_price = int(float_price)               # Truncates decimal part
rounded_price = int(float_price + 0.5)     # Manual rounding
math_rounded = int(math.round(float_price)) # Using math.round

// Integer to Float casting
int_volume = int(volume)
float_volume = float(int_volume)           # Explicit conversion
implicit_float = int_volume * 1.0          # Implicit conversion via multiplication

// Boolean casting
bool_from_number = bool(close > open)      # Already boolean, but explicit
int_from_bool = int(close > open)          # 1 for true, 0 for false
float_from_bool = float(close > open)      # 1.0 for true, 0.0 for false

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  STRING CASTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Numbers to strings
string_from_int = str.tostring(int_price)
string_from_float = str.tostring(float_price, "0.00")  # With formatting
string_from_bool = str.tostring(close > open)

// Custom formatting for different scenarios
price_formatted = str.tostring(close, "#.####")       # Up to 4 decimal places
percentage_formatted = str.tostring(ta.change(close) / close[1] * 100, "0.00") + "%"
volume_formatted = str.tostring(volume / 1000000, "0.0") + "M"

// Strings to numbers (Pine Script v6 approach)
parse_number_from_string(string_value, default_value = 0.0) =>
    # Pine Script doesn't have direct string-to-number conversion
    # This function demonstrates the concept
    result = default_value
    
    # In practice, you'd validate the string format
    # and convert using custom logic or external data
    if string_value == "1"
        result := 1.0
    else if string_value == "2"
        result := 2.0
    # ... more conditions as needed
    
    result

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  COLOR CASTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Color from components
red_component = 255
green_component = 128
blue_component = 0
custom_color = color.rgb(red_component, green_component, blue_component)

// Color with transparency
transparent_color = color.new(color.blue, 50)  # 50% transparency

// Color from string representation (conceptual)
color_from_name(color_name) =>
    switch color_name
        "red" => color.red
        "green" => color.green
        "blue" => color.blue
        "orange" => color.orange
        "purple" => color.purple
        => color.gray

// Dynamic color based on conditions
dynamic_color = close > open ? color.green : color.red
conditional_transparency = close > ta.sma(close, 20) ? 0 : 70

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  SAFE CASTING FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Safe integer casting with validation
safe_int_cast(value, min_value = na, max_value = na) =>
    cast_result = int(value)
    
    # Apply bounds if specified
    if not na(min_value) and cast_result < min_value
        cast_result := min_value
    if not na(max_value) and cast_result > max_value
        cast_result := max_value
    
    cast_result

// Safe float casting with precision control
safe_float_cast(value, decimal_places = 4) =>
    multiplier = math.pow(10, decimal_places)
    math.round(float(value) * multiplier) / multiplier

// Safe boolean casting with null handling
safe_bool_cast(value, default_value = false) =>
    if na(value)
        default_value
    else
        bool(value)

// Demonstration of safe casting
demo_int = safe_int_cast(close, 0, 1000)           # Bounded integer
demo_float = safe_float_cast(ta.change(close), 2)  # 2 decimal places
demo_bool = safe_bool_cast(close > open, false)    # Default false if na

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  COLLECTION CASTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Array type conversions
var float_array = array.new<float>()
var int_array = array.new<int>()
var string_array = array.new<string>()

// Convert float array to int array
convert_float_to_int_array(float_arr) =>
    int_arr = array.new<int>()
    for i = 0 to array.size(float_arr) - 1
        float_val = array.get(float_arr, i)
        int_val = int(float_val)
        array.push(int_arr, int_val)
    int_arr

// Convert numeric array to string array
convert_numeric_to_string_array(numeric_arr, format_string = "0.00") =>
    string_arr = array.new<string>()
    for i = 0 to array.size(numeric_arr) - 1
        numeric_val = array.get(numeric_arr, i)
        string_val = str.tostring(numeric_val, format_string)
        array.push(string_arr, string_val)
    string_arr

// Example usage
array.push(float_array, close)
array.push(float_array, open)
array.push(float_array, high)
array.push(float_array, low)

converted_int_array = convert_float_to_int_array(float_array)
converted_string_array = convert_numeric_to_string_array(float_array, "#.##")

// Plot casting results
plot(demo_int, "Safe Int Cast", color.blue)
plot(demo_float * 1000, "Safe Float Cast x1000", color.red)  # Scaled for visibility
plot(demo_bool ? 1 : 0, "Safe Bool Cast", color.green)

// Display casting information
var table cast_table = table.new(position.bottom_left, 2, 5)

if barstate.islast
    table.clear(cast_table, 0, 0, 1, 4)
    
    table.cell(cast_table, 0, 0, "Cast Type", bgcolor=color.navy, text_color=color.white)
    table.cell(cast_table, 1, 0, "Result", bgcolor=color.navy, text_color=color.white)
    
    table.cell(cast_table, 0, 1, "Price to Int")
    table.cell(cast_table, 1, 1, str.tostring(demo_int))
    
    table.cell(cast_table, 0, 2, "Change (2 dec)")
    table.cell(cast_table, 1, 2, str.tostring(demo_float))
    
    table.cell(cast_table, 0, 3, "Bull/Bear")
    table.cell(cast_table, 1, 3, demo_bool ? "Bull" : "Bear")
    
    table.cell(cast_table, 0, 4, "Array Sizes")
    table.cell(cast_table, 1, 4, str.tostring(array.size(converted_int_array)))
```

---

## Implicit Conversions

### Automatic Type Promotion
```pinescript
//@version=6
indicator("Implicit Type Conversions", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  NUMERIC PROMOTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Integer to Float promotion
int_value = 10
float_value = 3.14

# Automatic promotion in arithmetic operations
mixed_result = int_value + float_value      # int promoted to float, result is float
division_result = int_value / 2             # Integer division becomes float division
multiplication_result = int_value * 1.5     # int promoted to float

// Boolean to Numeric promotion
bool_true = true
bool_false = false

# Boolean arithmetic (treated as 1 and 0)
bool_sum = bool_true + bool_false           # 1 + 0 = 1
bool_product = bool_true * 10               # 1 * 10 = 10
bool_to_float = bool_true * 3.14            # 1 * 3.14 = 3.14

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONTEXT PROMOTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simple to Series promotion
simple_constant = 5
series_value = close

# Simple values automatically promote to series when mixed
promoted_addition = simple_constant + series_value    # 5 promoted to series
promoted_comparison = series_value > simple_constant  # 5 promoted to series

// Function parameter promotion
calculate_rsi_custom(src, length) =>
    # Even if length is passed as literal, it's treated appropriately
    ta.rsi(src, length)

# Usage with different argument types
rsi_with_literal = calculate_rsi_custom(close, 14)     # 14 is simple
rsi_length = input.int(14, "RSI Length")
rsi_with_input = calculate_rsi_custom(close, rsi_length)  # input is simple

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONDITIONAL PROMOTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Ternary operator type promotion
condition = close > open
int_choice = condition ? 1 : 0              # Both branches same type
mixed_choice = condition ? 1 : 1.5          # int promoted to float (result is float)
string_choice = condition ? "Up" : "Down"   # Both strings, no promotion needed

// Null coalescing with promotion
nullable_value = na
default_int = 42
default_float = 3.14

# Type promotion in null coalescing
coalesced_mixed = na(nullable_value) ? default_int : default_float  # int promoted to float

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  FUNCTION CALL PROMOTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Math function promotions
math_with_int = math.sqrt(25)               # int 25 promoted to float for sqrt
math_with_mixed = math.pow(2, 3.0)          # int 2 promoted to float for pow
math_comparison = math.max(10, 10.5)        # int 10 promoted to float

// Built-in function promotions
ta_with_promotion = ta.sma(close, 20)       # 20 (simple int) used appropriately
security_with_promotion = request.security(syminfo.tickerid, "1D", close)  # String constants

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              PROMOTION RULES DEMONSTRATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

demonstrate_promotion_rules() =>
    # Rule 1: int + float = float
    rule1_result = 5 + 2.5          # Result: 7.5 (float)
    
    # Rule 2: bool arithmetic promotes to numeric
    rule2_result = true + false     # Result: 1 (int: 1 + 0)
    
    # Rule 3: simple promotes to series in series context
    rule3_result = close + 10       # 10 promoted to series
    
    # Rule 4: Conditional expressions promote to common type
    rule4_result = close > open ? 1 : 2.5  # 1 promoted to 1.0 (float)
    
    # Rule 5: Function parameters promote as needed
    rule5_result = math.pow(2, 3)   # Both promoted to float for math function
    
    [rule1_result, rule2_result, rule3_result, rule4_result, rule5_result]

[r1, r2, r3, r4, r5] = demonstrate_promotion_rules()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  PROMOTION WARNINGS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to identify potential promotion issues
identify_promotion_issues() =>
    issues = array.new<string>()
    
    # Issue 1: Unexpected float from integer division
    int_division = 10 / 3           # Results in 3.33333, not 3
    if int_division != int(int_division)
        array.push(issues, "Integer division resulted in float")
    
    # Issue 2: Boolean arithmetic might be unintended
    bool_calc = (close > open) * 100  # Might be confusing
    array.push(issues, "Boolean used in arithmetic: " + str.tostring(bool_calc))
    
    # Issue 3: Mixed types in arrays (conceptual - Pine Script handles this)
    # This would be caught at compile time in Pine Script
    
    issues

promotion_issues = identify_promotion_issues()

// Plot promotion examples
plot(mixed_result, "Mixed Int+Float", color.blue)
plot(bool_product, "Bool*10", color.red)
plot(r4, "Conditional Promotion", color.green)

// Display promotion information
var table promotion_table = table.new(position.top_left, 2, 6)

if barstate.islast
    table.clear(promotion_table, 0, 0, 1, 5)
    
    table.cell(promotion_table, 0, 0, "Promotion Type", bgcolor=color.navy, text_color=color.white)
    table.cell(promotion_table, 1, 0, "Result", bgcolor=color.navy, text_color=color.white)
    
    table.cell(promotion_table, 0, 1, "Int + Float")
    table.cell(promotion_table, 1, 1, str.tostring(r1, "0.00"))
    
    table.cell(promotion_table, 0, 2, "Bool Arithmetic")
    table.cell(promotion_table, 1, 2, str.tostring(r2))
    
    table.cell(promotion_table, 0, 3, "Simple to Series")
    table.cell(promotion_table, 1, 3, str.tostring(r3, "0.00"))
    
    table.cell(promotion_table, 0, 4, "Conditional Mix")
    table.cell(promotion_table, 1, 4, str.tostring(r4, "0.00"))
    
    table.cell(promotion_table, 0, 5, "Math Function")
    table.cell(promotion_table, 1, 5, str.tostring(r5, "0.00"))
```

---

## Series vs Simple Context

### Understanding Execution Contexts
```pinescript
//@version=6
indicator("Series vs Simple Context", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONTEXT DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simple context - values determined at compile time or script initialization
simple int BARS_LOOKBACK = 50              # Compile-time constant
period_input = input.int(20, "Period")     # Input value (simple)
timeframe_input = input.timeframe("1D")    # Input value (simple)

// Series context - values that change with each bar
series float current_price = close         # Changes each bar
series float price_change = ta.change(close)  # Calculated each bar
series bool is_green_bar = close > open    # Boolean series

// Variable context - can be reassigned
var float accumulated_volume = 0.0          # Persistent variable
var int bar_count = 0                       # Persistent counter

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONTEXT REQUIREMENTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Functions requiring simple parameters
calculate_sma(series float source, simple int length) =>
    # length must be simple - cannot change during execution
    # source can be series - changes with each bar
    ta.sma(source, length)

// Functions requiring series parameters
custom_momentum(series float src1, series float src2) =>
    # Both parameters must be series (or promotable to series)
    (src1 - src2) / src2 * 100

// Mixed requirements function
advanced_calculation(series float source, simple int period, simple float multiplier) =>
    base_ma = ta.sma(source, period)        # period must be simple
    deviation = ta.stdev(source, period)    # period must be simple
    upper_band = base_ma + deviation * multiplier  # multiplier can be simple
    lower_band = base_ma - deviation * multiplier
    
    [base_ma, upper_band, lower_band]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONTEXT VIOLATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Demonstrate context violations and solutions
demonstrate_context_issues() =>
    # ❌ This would cause an error - series used where simple required
    # dynamic_period = int(ta.rsi(close, 14) / 5)  # RSI is series
    # invalid_sma = ta.sma(close, dynamic_period)   # Error: series used for length
    
    # ✅ Solution 1: Use var to make it effectively simple
    var int adaptive_period = 20
    if bar_index == 100  # Only change once, making it effectively simple
        adaptive_period := 25
    
    valid_sma_1 = ta.sma(close, adaptive_period)
    
    # ✅ Solution 2: Use conditional logic with simple values
    market_volatile = ta.atr(14) > ta.sma(ta.atr(14), 20)
    chosen_period = market_volatile ? 10 : 20  # Both 10 and 20 are simple
    valid_sma_2 = ta.sma(close, chosen_period)
    
    # ✅ Solution 3: Pre-calculate and store
    var float stored_calculation = na
    if barstate.isconfirmed
        # Calculate complex value and store
        rsi_val = ta.rsi(close, 14)
        stored_calculation := rsi_val > 70 ? 1.0 : rsi_val < 30 ? -1.0 : 0.0
    
    [valid_sma_1, valid_sma_2, stored_calculation]

[sma1, sma2, stored] = demonstrate_context_issues()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  SERIES HISTORY ACCESS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Working with series history
analyze_series_history() =>
    # Current and historical values
    current_close = close               # Current bar
    previous_close = close[1]           # Previous bar
    close_5_bars_ago = close[5]         # 5 bars ago
    
    # Historical calculations
    price_momentum_1 = (current_close - previous_close) / previous_close * 100
    price_momentum_5 = (current_close - close_5_bars_ago) / close_5_bars_ago * 100
    
    # Series operations with history
    highest_10 = ta.highest(close, 10)  # Highest close in last 10 bars
    lowest_10 = ta.lowest(close, 10)    # Lowest close in last 10 bars
    
    # Custom historical analysis
    var float max_seen = 0.0
    var float min_seen = 999999.0
    max_seen := math.max(max_seen, current_close)
    min_seen := math.min(min_seen, current_close)
    
    [price_momentum_1, price_momentum_5, highest_10, lowest_10, max_seen, min_seen]

[mom1, mom5, high10, low10, max_ever, min_ever] = analyze_series_history()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONTEXT BEST PRACTICES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function demonstrating best practices
implement_best_practices() =>
    # 1. Use clear variable naming to indicate context
    simple int SIGNAL_THRESHOLD = 50                    # Clear it's a constant
    series float current_rsi = ta.rsi(close, 14)        # Clear it's series
    var bool signal_triggered = false                   # Clear it's persistent
    
    # 2. Validate inputs and provide defaults
    safe_period = period_input > 0 ? period_input : 20
    safe_multiplier = math.max(0.1, math.min(5.0, 2.0))  # Bounded multiplier
    
    # 3. Use var for state management
    var int consecutive_signals = 0
    
    if current_rsi > SIGNAL_THRESHOLD
        consecutive_signals += 1
        if not signal_triggered
            signal_triggered := true
    else
        consecutive_signals := 0
        signal_triggered := false
    
    # 4. Document context requirements in comments
    ## This function requires:
    ## - source: series float (price data)
    ## - period: simple int (lookback period)
    ## Returns: series float (calculated value)
    calculated_value = ta.ema(close, safe_period)
    
    [current_rsi, consecutive_signals, signal_triggered, calculated_value]

[rsi_val, signals, triggered, ema_val] = implement_best_practices()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CONTEXT DEBUGGING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Debug context issues
debug_context_info() =>
    debug_info = array.new<string>()
    
    # Check for common context issues
    if barstate.isconfirmed
        array.push(debug_info, "Bar confirmed - safe for var updates")
    else
        array.push(debug_info, "Bar not confirmed - avoid var updates")
    
    if barstate.islast
        array.push(debug_info, "Last bar - good for final calculations")
    
    if bar_index < BARS_LOOKBACK
        array.push(debug_info, "Insufficient history for full calculation")
    
    debug_info

debug_messages = debug_context_info()

// Update persistent counters
bar_count += 1
accumulated_volume += volume

// Plot series values
plot(sma1, "Adaptive SMA 1", color.blue)
plot(sma2, "Adaptive SMA 2", color.red)
plot(mom1, "1-Bar Momentum", color.green)
plot(rsi_val, "RSI", color.purple)

// Display context information
var table context_table = table.new(position.bottom_right, 2, 7)

if barstate.islast
    table.clear(context_table, 0, 0, 1, 6)
    
    table.cell(context_table, 0, 0, "Context Info", bgcolor=color.navy, text_color=color.white)
    table.cell(context_table, 1, 0, "Value", bgcolor=color.navy, text_color=color.white)
    
    table.cell(context_table, 0, 1, "Bar Count")
    table.cell(context_table, 1, 1, str.tostring(bar_count))
    
    table.cell(context_table, 0, 2, "Signals Count")
    table.cell(context_table, 1, 2, str.tostring(signals))
    
    table.cell(context_table, 0, 3, "Signal Active")
    table.cell(context_table, 1, 3, triggered ? "Yes" : "No")
    
    table.cell(context_table, 0, 4, "Acc. Volume")
    table.cell(context_table, 1, 4, str.tostring(accumulated_volume / 1000000, "0.1") + "M")
    
    table.cell(context_table, 0, 5, "Max Price")
    table.cell(context_table, 1, 5, str.tostring(max_ever, "0.00"))
    
    table.cell(context_table, 0, 6, "Min Price")
    table.cell(context_table, 1, 6, str.tostring(min_ever, "0.00"))
```

---

## Type Qualifiers

### Advanced Qualifier Usage
```pinescript
//@version=6
indicator("Advanced Type Qualifiers", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  QUALIFIER COMBINATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Input qualifiers (automatically simple)
input_period = input.int(20, "MA Period", minval=1, maxval=100)
input_source = input.source(close, "Price Source")
input_multiplier = input.float(2.0, "Multiplier", minval=0.1, maxval=5.0)

// Const-like declarations (effectively simple)
MAX_LOOKBACK = 500
DEFAULT_PERIOD = 14
PI_CONSTANT = 3.14159265359

// Variable qualifiers with explicit types
var simple int initialization_count = 0
var series float running_total = 0.0
var bool first_run = true

// Complex qualifier scenarios
var array<float> price_history = array.new<float>()
var map<string, float> indicator_cache = map.new<string, float>()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  FUNCTION SIGNATURES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Strict qualifier enforcement
strict_moving_average(series float src, simple int len, simple string type = "SMA") =>
    # All parameters have explicit qualifiers
    # src: must be series (changes per bar)
    # len: must be simple (constant during execution)
    # type: must be simple (constant string)
    
    result = switch type
        "SMA" => ta.sma(src, len)
        "EMA" => ta.ema(src, len)
        "WMA" => ta.wma(src, len)
        => ta.sma(src, len)  # Default to SMA
    
    result

// Mixed qualifier function
analyze_with_mixed_qualifiers(series float price_data, 
                             simple int short_period,
                             simple int long_period, 
                             series float volume_data) =>
    # Price and volume are series (change per bar)
    # Periods are simple (constant)
    
    short_ma = ta.sma(price_data, short_period)
    long_ma = ta.sma(price_data, long_period)
    volume_ma = ta.sma(volume_data, short_period)
    
    trend_signal = short_ma > long_ma ? 1 : -1
    volume_confirmation = volume_data > volume_ma
    
    [trend_signal, volume_confirmation, short_ma, long_ma]

// Dynamic qualifier adaptation
adaptive_calculation(series float src, simple bool use_adaptive = false) =>
    # Demonstrate how to handle optional complexity
    base_period = input_period
    
    if use_adaptive
        # Use var to maintain simple context while allowing updates
        var int adaptive_period = base_period
        
        # Adapt period based on volatility (only update occasionally)
        if bar_index % 20 == 0  # Update every 20 bars
            volatility = ta.atr(14)
            avg_volatility = ta.sma(ta.atr(14), 50)
            
            if volatility > avg_volatility * 1.5
                adaptive_period := int(base_period * 0.7)  # Shorter period for high volatility
            else if volatility < avg_volatility * 0.5
                adaptive_period := int(base_period * 1.3)  # Longer period for low volatility
            else
                adaptive_period := base_period
        
        ta.sma(src, adaptive_period)
    else
        ta.sma(src, base_period)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  QUALIFIER VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Runtime qualifier validation
validate_qualifiers_runtime() =>
    issues = array.new<string>()
    
    # Check if inputs are within expected ranges (simple validation)
    if input_period < 1 or input_period > MAX_LOOKBACK
        array.push(issues, "Period out of valid range")
    
    if input_multiplier <= 0
        array.push(issues, "Multiplier must be positive")
    
    # Check series data availability
    if bar_index < input_period
        array.push(issues, "Insufficient data for calculation")
    
    # Check for na values in series
    if na(input_source)
        array.push(issues, "Source data contains na values")
    
    issues

// Compile-time qualifier checking (conceptual)
check_qualifier_compatibility() =>
    # This demonstrates the concepts Pine Script checks at compile time
    
    compatibility_score = 0
    
    # ✅ Compatible: series used where series expected
    test1 = ta.sma(close, input_period)  # close is series, input_period is simple
    if not na(test1)
        compatibility_score += 1
    
    # ✅ Compatible: simple promoted to series
    test2 = close + 1.0  # 1.0 (simple) promoted to series
    if not na(test2)
        compatibility_score += 1
    
    # ✅ Compatible: var maintaining simple context
    var int test_var = 10
    test3 = ta.sma(close, test_var)
    if not na(test3)
        compatibility_score += 1
    
    # Return compatibility assessment
    compatibility_score >= 3

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  ADVANCED QUALIFIER PATTERNS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Conditional qualifier management
manage_conditional_qualifiers() =>
    # Use var for values that need to persist but remain simple
    var float threshold_value = 50.0
    var string current_mode = "normal"
    
    # Update mode based on market conditions (maintaining simple context)
    if barstate.isconfirmed  # Only update on confirmed bars
        current_rsi = ta.rsi(close, 14)
        
        if current_rsi > 80
            current_mode := "overbought"
            threshold_value := 75.0
        else if current_rsi < 20
            current_mode := "oversold" 
            threshold_value := 25.0
        else
            current_mode := "normal"
            threshold_value := 50.0
    
    # Use the managed values (they remain simple)
    signal = ta.rsi(close, 14) > threshold_value
    
    [signal, current_mode, threshold_value]

// Template function with generic qualifiers
create_custom_indicator(series float data_source, 
                       simple int calculation_period,
                       simple float sensitivity = 1.0,
                       simple string method = "standard") =>
    # Validate inputs
    validated_period = math.max(1, math.min(MAX_LOOKBACK, calculation_period))
    validated_sensitivity = math.max(0.1, math.min(5.0, sensitivity))
    
    # Base calculation
    base_value = ta.sma(data_source, validated_period)
    
    # Apply method-specific processing
    processed_value = switch method
        "standard" => base_value
        "smoothed" => ta.ema(base_value, int(validated_period / 2))
        "sensitive" => base_value * validated_sensitivity
        => base_value
    
    # Return with metadata
    [processed_value, validated_period, validated_sensitivity, method]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  QUALIFIER DEMONSTRATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

# Initialize persistent state
if first_run
    initialization_count := 1
    first_run := false

# Update running totals
running_total += close
array.push(price_history, close)

# Maintain array size
if array.size(price_history) > 100
    array.shift(price_history)

# Execute functions with different qualifier patterns
strict_sma = strict_moving_average(close, input_period, "EMA")
[trend_sig, vol_conf, short_ma, long_ma] = analyze_with_mixed_qualifiers(close, 10, 20, volume)
adaptive_sma = adaptive_calculation(close, true)
[signal_result, mode_result, threshold_result] = manage_conditional_qualifiers()
[custom_indicator, used_period, used_sensitivity, used_method] = create_custom_indicator(close, input_period)

# Validate qualifiers
runtime_issues = validate_qualifiers_runtime()
compatibility_ok = check_qualifier_compatibility()

# Plot results
plot(strict_sma, "Strict SMA", color.blue)
plot(adaptive_sma, "Adaptive SMA", color.red)
plot(custom_indicator, "Custom Indicator", color.green)
plot(signal_result ? 1 : 0, "Signal", color.orange)

# Display qualifier information
var table qualifier_table = table.new(position.top_right, 2, 6)

if barstate.islast
    table.clear(qualifier_table, 0, 0, 1, 5)
    
    table.cell(qualifier_table, 0, 0, "Qualifier Info", bgcolor=color.navy, text_color=color.white)
    table.cell(qualifier_table, 1, 0, "Value", bgcolor=color.navy, text_color=color.white)
    
    table.cell(qualifier_table, 0, 1, "Init Count")
    table.cell(qualifier_table, 1, 1, str.tostring(initialization_count))
    
    table.cell(qualifier_table, 0, 2, "History Size")
    table.cell(qualifier_table, 1, 2, str.tostring(array.size(price_history)))
    
    table.cell(qualifier_table, 0, 3, "Current Mode")
    table.cell(qualifier_table, 1, 3, mode_result)
    
    table.cell(qualifier_table, 0, 4, "Threshold")
    table.cell(qualifier_table, 1, 4, str.tostring(threshold_result, "0.0"))
    
    table.cell(qualifier_table, 0, 5, "Compatibility")
    table.cell(qualifier_table, 1, 5, compatibility_ok ? "✓" : "✗")
```

---

## User-Defined Types

### Custom Type Creation and Usage
```pinescript
//@version=6
indicator("User-Defined Types", overlay=false, max_labels_count=100)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  BASIC TYPE DEFINITIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simple data structure
type Point
    float x
    float y

// Trading signal type
type TradingSignal
    string signal_type      // "BUY", "SELL", "HOLD"
    float strength         // 0.0 to 1.0
    float confidence       // 0.0 to 1.0
    int timestamp
    float price
    string reason

// Market data structure
type MarketData
    float open_price
    float high_price
    float low_price
    float close_price
    float volume
    float atr
    float rsi
    bool is_bullish

// Complex indicator result
type IndicatorResult
    float value
    float upper_bound
    float lower_bound
    string status          // "NORMAL", "OVERBOUGHT", "OVERSOLD"
    array<float> history
    int calculation_bars

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  TYPE CONSTRUCTORS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Point constructor
create_point(float x_coord, float y_coord) =>
    Point.new(x_coord, y_coord)

// Trading signal constructor with validation
create_trading_signal(string sig_type, float str, float conf, float price_val, string reason_text = "") =>
    # Validate inputs
    validated_strength = math.max(0.0, math.min(1.0, str))
    validated_confidence = math.max(0.0, math.min(1.0, conf))
    validated_type = sig_type == "BUY" or sig_type == "SELL" or sig_type == "HOLD" ? sig_type : "HOLD"
    
    TradingSignal.new(
        signal_type = validated_type,
        strength = validated_strength,
        confidence = validated_confidence,
        timestamp = time,
        price = price_val,
        reason = reason_text
    )

// Market data constructor
create_market_data(float o, float h, float l, float c, float v) =>
    MarketData.new(
        open_price = o,
        high_price = h,
        low_price = l,
        close_price = c,
        volume = v,
        atr = ta.atr(14),
        rsi = ta.rsi(c, 14),
        is_bullish = c > o
    )

// Indicator result constructor
create_indicator_result(float val, float upper, float lower, int bars_used) =>
    # Determine status based on position
    status_text = val > upper ? "OVERBOUGHT" : val < lower ? "OVERSOLD" : "NORMAL"
    
    # Create history array
    history_array = array.new<float>()
    array.push(history_array, val)
    
    IndicatorResult.new(
        value = val,
        upper_bound = upper,
        lower_bound = lower,
        status = status_text,
        history = history_array,
        calculation_bars = bars_used
    )

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  TYPE METHODS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Point methods
method distance_from_origin(Point this) =>
    math.sqrt(this.x * this.x + this.y * this.y)

method distance_to_point(Point this, Point other) =>
    dx = this.x - other.x
    dy = this.y - other.y
    math.sqrt(dx * dx + dy * dy)

method move_point(Point this, float dx, float dy) =>
    this.x += dx
    this.y += dy

// Trading signal methods
method is_strong_signal(TradingSignal this) =>
    this.strength > 0.7 and this.confidence > 0.8

method get_signal_quality(TradingSignal this) =>
    quality_score = (this.strength + this.confidence) / 2
    if quality_score > 0.8
        "EXCELLENT"
    else if quality_score > 0.6
        "GOOD"
    else if quality_score > 0.4
        "FAIR"
    else
        "POOR"

method update_signal_strength(TradingSignal this, float new_strength) =>
    this.strength := math.max(0.0, math.min(1.0, new_strength))

// Market data methods
method get_price_range(MarketData this) =>
    this.high_price - this.low_price

method get_body_size(MarketData this) =>
    math.abs(this.close_price - this.open_price)

method is_doji(MarketData this) =>
    body_size = this.get_body_size()
    price_range = this.get_price_range()
    body_size < (price_range * 0.1)  # Body is less than 10% of range

method get_candle_type(MarketData this) =>
    if this.is_doji()
        "DOJI"
    else if this.is_bullish
        body_ratio = this.get_body_size() / this.get_price_range()
        body_ratio > 0.7 ? "STRONG_BULL" : "BULL"
    else
        body_ratio = this.get_body_size() / this.get_price_range()
        body_ratio > 0.7 ? "STRONG_BEAR" : "BEAR"

// Indicator result methods
method add_to_history(IndicatorResult this, float new_value) =>
    array.push(this.history, new_value)
    # Maintain history size
    if array.size(this.history) > 50
        array.shift(this.history)

method get_trend_direction(IndicatorResult this) =>
    if array.size(this.history) >= 2
        current = array.get(this.history, array.size(this.history) - 1)
        previous = array.get(this.history, array.size(this.history) - 2)
        current > previous ? 1 : current < previous ? -1 : 0
    else
        0

method is_diverging(IndicatorResult this, array<float> price_data) =>
    # Simplified divergence detection
    if array.size(this.history) >= 3 and array.size(price_data) >= 3
        indicator_trend = this.get_trend_direction()
        
        # Get price trend
        current_price = array.get(price_data, array.size(price_data) - 1)
        previous_price = array.get(price_data, array.size(price_data) - 2)
        price_trend = current_price > previous_price ? 1 : current_price < previous_price ? -1 : 0
        
        # Check for divergence
        indicator_trend != 0 and price_trend != 0 and indicator_trend != price_trend
    else
        false

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  COMPLEX TYPE USAGE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Portfolio type for managing multiple positions
type Portfolio
    array<TradingSignal> signals
    float total_pnl
    int win_count
    int loss_count
    float win_rate

// Portfolio methods
method add_signal(Portfolio this, TradingSignal signal) =>
    array.push(this.signals, signal)

method calculate_performance(Portfolio this) =>
    total_trades = this.win_count + this.loss_count
    this.win_rate := total_trades > 0 ? this.win_count / total_trades * 100 : 0.0

method get_recent_signals(Portfolio this, int count) =>
    recent = array.new<TradingSignal>()
    signal_count = array.size(this.signals)
    start_index = math.max(0, signal_count - count)
    
    for i = start_index to signal_count - 1
        signal = array.get(this.signals, i)
        array.push(recent, signal)
    
    recent

// Strategy configuration type
type StrategyConfig
    string name
    int rsi_period
    float rsi_overbought
    float rsi_oversold
    int ma_period
    float stop_loss_pct
    float take_profit_pct
    bool use_volume_filter

method validate_config(StrategyConfig this) =>
    issues = array.new<string>()
    
    if this.rsi_period < 5 or this.rsi_period > 50
        array.push(issues, "RSI period should be 5-50")
    
    if this.rsi_overbought <= this.rsi_oversold
        array.push(issues, "Overbought level must be > oversold level")
    
    if this.stop_loss_pct <= 0 or this.stop_loss_pct > 20
        array.push(issues, "Stop loss should be 0-20%")
    
    array.size(issues) == 0

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  TYPE INSTANCES AND USAGE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Create type instances
var portfolio = Portfolio.new(
    signals = array.new<TradingSignal>(),
    total_pnl = 0.0,
    win_count = 0,
    loss_count = 0,
    win_rate = 0.0
)

var strategy_config = StrategyConfig.new(
    name = "RSI Mean Reversion",
    rsi_period = 14,
    rsi_overbought = 70.0,
    rsi_oversold = 30.0,
    ma_period = 20,
    stop_loss_pct = 2.0,
    take_profit_pct = 4.0,
    use_volume_filter = true
)

# Validate configuration
config_valid = strategy_config.validate_config()

# Create current market data
current_market = create_market_data(open, high, low, close, volume)

# Create indicator result
current_rsi = ta.rsi(close, strategy_config.rsi_period)
rsi_result = create_indicator_result(
    current_rsi, 
    strategy_config.rsi_overbought, 
    strategy_config.rsi_oversold, 
    strategy_config.rsi_period
)

# Update indicator history
rsi_result.add_to_history(current_rsi)

# Generate trading signals
if current_rsi < strategy_config.rsi_oversold
    buy_signal = create_trading_signal(
        "BUY", 
        (strategy_config.rsi_oversold - current_rsi) / strategy_config.rsi_oversold,
        0.8,
        close,
        "RSI Oversold"
    )
    portfolio.add_signal(buy_signal)

if current_rsi > strategy_config.rsi_overbought
    sell_signal = create_trading_signal(
        "SELL",
        (current_rsi - strategy_config.rsi_overbought) / (100 - strategy_config.rsi_overbought),
        0.8,
        close,
        "RSI Overbought"
    )
    portfolio.add_signal(sell_signal)

# Update portfolio performance
portfolio.calculate_performance()

# Get analysis results
candle_type = current_market.get_candle_type()
trend_direction = rsi_result.get_trend_direction()
is_strong = array.size(portfolio.signals) > 0 ? 
           array.get(portfolio.signals, array.size(portfolio.signals) - 1).is_strong_signal() : false

# Plot type-based results
plot(current_rsi, "RSI", color.blue)
plot(rsi_result.upper_bound, "Overbought", color.red)
plot(rsi_result.lower_bound, "Oversold", color.green)

# Display type information
var table type_table = table.new(position.bottom_right, 2, 6)

if barstate.islast
    table.clear(type_table, 0, 0, 1, 5)
    
    table.cell(type_table, 0, 0, "Type Analysis", bgcolor=color.navy, text_color=color.white)
    table.cell(type_table, 1, 0, "Value", bgcolor=color.navy, text_color=color.white)
    
    table.cell(type_table, 0, 1, "Candle Type")
    table.cell(type_table, 1, 1, candle_type)
    
    table.cell(type_table, 0, 2, "RSI Status")
    table.cell(type_table, 1, 2, rsi_result.status)
    
    table.cell(type_table, 0, 3, "Trend Dir")
    table.cell(type_table, 1, 3, trend_direction > 0 ? "↑" : trend_direction < 0 ? "↓" : "→")
    
    table.cell(type_table, 0, 4, "Total Signals")
    table.cell(type_table, 1, 4, str.tostring(array.size(portfolio.signals)))
    
    table.cell(type_table, 0, 5, "Config Valid")
    table.cell(type_table, 1, 5, config_valid ? "✓" : "✗")
```

---

## Type Checking Functions

### Runtime Type Validation
```pinescript
//@version=6
indicator("Type Checking Functions", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  BUILT-IN TYPE CHECKING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Basic na checking
check_na_values() =>
    price_is_na = na(close)
    volume_is_na = na(volume)
    calculated_na = na(ta.rsi(close, 14))
    
    # Count na occurrences
    var int na_count = 0
    if price_is_na or volume_is_na or calculated_na
        na_count += 1
    
    [price_is_na, volume_is_na, calculated_na, na_count]

// Number validation
validate_numbers() =>
    is_valid_close = not na(close) and close > 0
    is_valid_volume = not na(volume) and volume >= 0
    is_finite_calculation = not na(ta.change(close)) and math.abs(ta.change(close)) < math.max_number
    
    # Range validation
    price_in_range = close > 0 and close < 1000000  # Reasonable price range
    volume_reasonable = volume >= 0 and volume < 1000000000  # Reasonable volume
    
    [is_valid_close, is_valid_volume, is_finite_calculation, price_in_range, volume_reasonable]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  CUSTOM TYPE VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Validate array types and contents
validate_array(array<float> arr, float min_val = na, float max_val = na) =>
    if array.size(arr) == 0
        [false, "Array is empty"]
    else
        all_valid = true
        issue_description = ""
        
        for i = 0 to array.size(arr) - 1
            value = array.get(arr, i)
            
            if na(value)
                all_valid := false
                issue_description := "Contains na values"
                break
            
            if not na(min_val) and value < min_val
                all_valid := false
                issue_description := "Value below minimum: " + str.tostring(value)
                break
            
            if not na(max_val) and value > max_val
                all_valid := false
                issue_description := "Value above maximum: " + str.tostring(value)
                break
        
        [all_valid, issue_description]

// Validate string contents
validate_string(string text, array<string> allowed_values = na) =>
    if na(text) or str.length(text) == 0
        [false, "String is empty or na"]
    else if not na(allowed_values)
        is_allowed = false
        for i = 0 to array.size(allowed_values) - 1
            if text == array.get(allowed_values, i)
                is_allowed := true
                break
        
        if is_allowed
            [true, "Valid"]
        else
            [false, "Not in allowed values"]
    else
        [true, "Valid"]

// Validate color values
validate_color(color col) =>
    # Pine Script doesn't allow direct color inspection
    # This is a conceptual validation
    is_valid = not na(col)
    description = is_valid ? "Valid color" : "Invalid color"
    [is_valid, description]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  SERIES VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Validate series data consistency
validate_series_data(series float data, simple int lookback = 10) =>
    if bar_index < lookback
        [false, "Insufficient data"]
    else
        # Check for consistent data availability
        missing_count = 0
        extreme_count = 0
        
        for i = 0 to lookback - 1
            historical_value = data[i]
            
            if na(historical_value)
                missing_count += 1
            else
                # Check for extreme values (potential data errors)
                if math.abs(historical_value) > 1000000
                    extreme_count += 1
        
        is_valid = missing_count == 0 and extreme_count == 0
        description = is_valid ? "Valid series" : 
                     "Missing: " + str.tostring(missing_count) + ", Extreme: " + str.tostring(extreme_count)
        
        [is_valid, description]

// Validate series relationships
validate_series_relationship(series float data1, series float data2, string relationship_type) =>
    if na(data1) or na(data2)
        [false, "One or both series contain na"]
    else
        relationship_valid = switch relationship_type
            "positive_correlation" => data1 > data1[1] and data2 > data2[1] or data1 < data1[1] and data2 < data2[1]
            "greater_than" => data1 > data2
            "positive_values" => data1 > 0 and data2 > 0
            => true
        
        description = relationship_valid ? "Relationship valid" : "Relationship violated: " + relationship_type
        [relationship_valid, description]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  INPUT VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Comprehensive input validation
validate_indicator_inputs(simple int period, simple float multiplier, simple string mode) =>
    issues = array.new<string>()
    
    # Validate period
    if period < 1
        array.push(issues, "Period must be positive")
    else if period > 500
        array.push(issues, "Period too large (max 500)")
    
    # Validate multiplier
    if multiplier <= 0
        array.push(issues, "Multiplier must be positive")
    else if multiplier > 10
        array.push(issues, "Multiplier too large (max 10)")
    
    # Validate mode
    allowed_modes = array.from("standard", "adaptive", "smooth")
    [mode_valid, mode_issue] = validate_string(mode, allowed_modes)
    if not mode_valid
        array.push(issues, "Invalid mode: " + mode_issue)
    
    # Return validation result
    is_all_valid = array.size(issues) == 0
    [is_all_valid, issues]

// Validate calculation inputs
validate_calculation_inputs(series float source, simple int length) =>
    source_issues = array.new<string>()
    
    # Check source data
    if na(source)
        array.push(source_issues, "Source is na")
    
    if source <= 0
        array.push(source_issues, "Source must be positive")
    
    # Check length
    if length < 1
        array.push(source_issues, "Length must be positive")
    
    if bar_index < length
        array.push(source_issues, "Insufficient bars for calculation")
    
    # Validate recent history
    if bar_index >= length
        has_na_in_history = false
        for i = 0 to length - 1
            if na(source[i])
                has_na_in_history := true
                break
        
        if has_na_in_history
            array.push(source_issues, "Na values in lookback period")
    
    [array.size(source_issues) == 0, source_issues]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  VALIDATION FRAMEWORK
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Central validation function
perform_comprehensive_validation() =>
    validation_results = map.new<string, bool>()
    validation_messages = map.new<string, string>()
    
    # Basic type validation
    [na_valid1, na_valid2, na_valid3, na_count] = check_na_values()
    overall_na_valid = not na_valid1 and not na_valid2 and not na_valid3
    map.put(validation_results, "na_check", overall_na_valid)
    map.put(validation_messages, "na_check", "Na count: " + str.tostring(na_count))
    
    # Number validation
    [num_valid1, num_valid2, num_valid3, num_valid4, num_valid5] = validate_numbers()
    overall_num_valid = num_valid1 and num_valid2 and num_valid3 and num_valid4 and num_valid5
    map.put(validation_results, "number_check", overall_num_valid)
    map.put(validation_messages, "number_check", overall_num_valid ? "All numbers valid" : "Number validation failed")
    
    # Series validation
    [series_valid, series_msg] = validate_series_data(close, 20)
    map.put(validation_results, "series_check", series_valid)
    map.put(validation_messages, "series_check", series_msg)
    
    # Input validation
    test_period = input.int(14, "Test Period")
    test_multiplier = input.float(2.0, "Test Multiplier")
    test_mode = input.string("standard", "Test Mode", options=["standard", "adaptive", "smooth"])
    
    [input_valid, input_issues] = validate_indicator_inputs(test_period, test_multiplier, test_mode)
    map.put(validation_results, "input_check", input_valid)
    map.put(validation_messages, "input_check", 
           input_valid ? "Inputs valid" : "Input issues: " + str.tostring(array.size(input_issues)))
    
    # Calculation validation
    [calc_valid, calc_issues] = validate_calculation_inputs(close, test_period)
    map.put(validation_results, "calculation_check", calc_valid)
    map.put(validation_messages, "calculation_check",
           calc_valid ? "Calculation inputs valid" : "Calc issues: " + str.tostring(array.size(calc_issues)))
    
    [validation_results, validation_messages]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  VALIDATION EXECUTION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

# Perform validation
[validation_results, validation_messages] = perform_comprehensive_validation()

# Create test array for validation
var test_array = array.new<float>()
array.push(test_array, close)
if array.size(test_array) > 20
    array.shift(test_array)

# Validate test array
[array_valid, array_msg] = validate_array(test_array, 0.0, 1000000.0)

# Test string validation
test_string = "standard"
allowed_strings = array.from("standard", "adaptive", "smooth")
[string_valid, string_msg] = validate_string(test_string, allowed_strings)

# Count validation results
var int total_validations = 0
var int passed_validations = 0

if barstate.islast
    total_validations := map.size(validation_results)
    passed_validations := 0
    
    validation_keys = map.keys(validation_results)
    for i = 0 to array.size(validation_keys) - 1
        key = array.get(validation_keys, i)
        if map.get(validation_results, key)
            passed_validations += 1

# Plot validation metrics
plot(passed_validations, "Passed Validations", color.green)
plot(total_validations, "Total Validations", color.blue)
plot(array_valid ? 1 : 0, "Array Valid", color.orange)
plot(string_valid ? 1 : 0, "String Valid", color.purple)

# Display validation results
var table validation_table = table.new(position.top_left, 2, 7)

if barstate.islast
    table.clear(validation_table, 0, 0, 1, 6)
    
    table.cell(validation_table, 0, 0, "Validation", bgcolor=color.navy, text_color=color.white)
    table.cell(validation_table, 1, 0, "Result", bgcolor=color.navy, text_color=color.white)
    
    table.cell(validation_table, 0, 1, "Overall")
    overall_pct = total_validations > 0 ? passed_validations / total_validations * 100 : 0
    table.cell(validation_table, 1, 1, str.tostring(overall_pct, "0.0") + "%")
    
    table.cell(validation_table, 0, 2, "Na Check")
    na_result = map.get(validation_results, "na_check")
    table.cell(validation_table, 1, 2, na_result ? "✓" : "✗")
    
    table.cell(validation_table, 0, 3, "Numbers")
    num_result = map.get(validation_results, "number_check")
    table.cell(validation_table, 1, 3, num_result ? "✓" : "✗")
    
    table.cell(validation_table, 0, 4, "Series")
    series_result = map.get(validation_results, "series_check")
    table.cell(validation_table, 1, 4, series_result ? "✓" : "✗")
    
    table.cell(validation_table, 0, 5, "Array")
    table.cell(validation_table, 1, 5, array_valid ? "✓" : "✗")
    
    table.cell(validation_table, 0, 6, "String")
    table.cell(validation_table, 1, 6, string_valid ? "✓" : "✗")
```

---

## Common Type Errors and Fixes

### Error Prevention and Resolution
```pinescript
//@version=6
indicator("Type Error Prevention and Fixes", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  COMMON TYPE ERRORS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Error 1: Series used where simple required
demonstrate_series_simple_error() =>
    # ❌ INCORRECT: This would cause a compilation error
    # dynamic_period = int(ta.rsi(close, 14) / 5)  # RSI is series
    # wrong_sma = ta.sma(close, dynamic_period)     # Error: series used for simple parameter
    
    # ✅ CORRECT: Use var to maintain simple context
    var int adaptive_period = 20
    if bar_index == 100  # Update only once to keep it simple
        adaptive_period := 15
    
    correct_sma = ta.sma(close, adaptive_period)
    
    # ✅ CORRECT: Use conditional with simple values
    market_condition = ta.atr(14) > ta.sma(ta.atr(14), 50)
    period_choice = market_condition ? 10 : 20  # Both values are simple
    conditional_sma = ta.sma(close, period_choice)
    
    [correct_sma, conditional_sma]

// Error 2: Type mismatch in operations
demonstrate_type_mismatch_fixes() =>
    # ❌ INCORRECT: Potential precision loss
    # int_division = 10 / 3        # Results in float, not int
    # truncated = int_division     # Implicit conversion loses precision
    
    # ✅ CORRECT: Explicit type handling
    float_division = 10.0 / 3.0    # Explicit float division
    proper_int = int(float_division + 0.5)  # Proper rounding
    
    # ❌ INCORRECT: String concatenation with numbers
    # bad_concat = "Value: " + close  # Error: can't concatenate string and float
    
    # ✅ CORRECT: Proper string conversion
    good_concat = "Value: " + str.tostring(close, "0.00")
    
    # ❌ INCORRECT: Boolean arithmetic confusion
    # confusing = (close > open) + (volume > ta.sma(volume, 20))  # Unclear intent
    
    # ✅ CORRECT: Explicit boolean handling
    bull_bar = close > open ? 1 : 0
    high_volume = volume > ta.sma(volume, 20) ? 1 : 0
    combined_score = bull_bar + high_volume
    
    [proper_int, good_concat, combined_score]

// Error 3: Na value propagation
demonstrate_na_handling() =>
    # ❌ INCORRECT: Not handling na values
    # risky_calculation = ta.rsi(close, 14) * 2  # If RSI is na, result is na
    
    # ✅ CORRECT: Explicit na handling
    rsi_value = ta.rsi(close, 14)
    safe_calculation = na(rsi_value) ? 0.0 : rsi_value * 2
    
    # ✅ CORRECT: Using nz() function
    safe_with_nz = nz(rsi_value, 50.0) * 2  # Use 50 if na
    
    # ✅ CORRECT: Conditional na checking
    conditional_safe = if na(rsi_value)
        50.0  # Default value
    else
        rsi_value > 70 ? 100.0 : rsi_value < 30 ? 0.0 : rsi_value
    
    [safe_calculation, safe_with_nz, conditional_safe]

// Error 4: Array type consistency
demonstrate_array_type_fixes() =>
    # ❌ INCORRECT: Mixing types in array operations (conceptual)
    # This would be caught at compile time in Pine Script
    
    # ✅ CORRECT: Consistent array usage
    float_array = array.new<float>()
    array.push(float_array, close)
    array.push(float_array, float(volume))  # Explicit conversion
    array.push(float_array, ta.rsi(close, 14))
    
    # ✅ CORRECT: Type-safe array operations
    if array.size(float_array) > 0
        avg_value = array.avg(float_array)
        max_value = array.max(float_array)
        [avg_value, max_value]
    else
        [0.0, 0.0]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  ERROR PREVENTION PATTERNS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Pattern 1: Defensive type checking
safe_division(float numerator, float denominator, float default_value = 0.0) =>
    if na(numerator) or na(denominator) or denominator == 0.0
        default_value
    else
        numerator / denominator

// Pattern 2: Type validation wrapper
validate_and_convert_to_int(float value, int min_value = na, int max_value = na) =>
    if na(value)
        0
    else
        int_value = int(value)
        
        # Apply bounds if specified
        if not na(min_value)
            int_value := math.max(int_value, min_value)
        if not na(max_value)
            int_value := math.min(int_value, max_value)
        
        int_value

// Pattern 3: Series context preservation
manage_adaptive_parameter(series float trigger_value, simple int base_value, 
                         simple float threshold, simple int alternative_value) =>
    # Use var to maintain simple context
    var int current_parameter = base_value
    
    # Only update on confirmed bars to maintain consistency
    if barstate.isconfirmed and not na(trigger_value)
        if trigger_value > threshold
            current_parameter := alternative_value
        else
            current_parameter := base_value
    
    current_parameter

// Pattern 4: Null-safe chaining
safe_calculation_chain(series float input_value) =>
    # Chain calculations with na checking
    step1 = na(input_value) ? 0.0 : input_value
    step2 = ta.sma(step1, 14)  # SMA handles na internally
    step3 = na(step2) ? 50.0 : step2  # Fallback for SMA result
    step4 = ta.rsi(step3, 14)
    
    # Final validation
    na(step4) ? 50.0 : step4

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  ERROR RECOVERY STRATEGIES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Strategy 1: Graceful degradation
robust_indicator_calculation(series float source, simple int period) =>
    # Multiple fallback levels
    if na(source)
        # Level 1: Use close if source is na
        working_source = close
    else
        working_source = source
    
    if period < 1 or period > 500
        # Level 2: Use safe period
        working_period = 14
    else
        working_period = period
    
    if bar_index < working_period
        # Level 3: Return neutral value if insufficient data
        50.0
    else
        # Normal calculation
        ta.rsi(working_source, working_period)

// Strategy 2: Error logging and recovery
error_logging_calculation() =>
    var array<string> error_log = array.new<string>()
    var int error_count = 0
    
    source_value = close
    period_value = 14
    
    # Validate inputs and log errors
    if na(source_value)
        array.push(error_log, "Source is na at bar " + str.tostring(bar_index))
        error_count += 1
        source_value := nz(close[1], 0.0)
    
    if period_value < 1
        array.push(error_log, "Invalid period at bar " + str.tostring(bar_index))
        error_count += 1
        period_value := 14
    
    # Perform calculation with validated inputs
    result = ta.sma(source_value, period_value)
    
    # Validate result
    if na(result)
        array.push(error_log, "Calculation result is na at bar " + str.tostring(bar_index))
        error_count += 1
        result := 0.0
    
    # Maintain log size
    if array.size(error_log) > 10
        array.shift(error_log)
    
    [result, error_count, error_log]

// Strategy 3: Type coercion utilities
create_type_coercion_utils() =>
    # Utility functions for safe type conversion
    
    # Safe string to number (conceptual - Pine Script limitation)
    safe_string_to_float = function(string_val, default_val = 0.0) =>
        # In practice, implement validation logic
        # Pine Script doesn't have direct string-to-number conversion
        switch string_val
            "1" => 1.0
            "2" => 2.0
            "10" => 10.0
            "20" => 20.0
            => default_val
    
    # Safe color creation
    safe_color_create = function(int r, int g, int b) =>
        validated_r = math.max(0, math.min(255, r))
        validated_g = math.max(0, math.min(255, g))
        validated_b = math.max(0, math.min(255, b))
        color.rgb(validated_r, validated_g, validated_b)
    
    # Safe array access
    safe_array_get = function(array<float> arr, int index, float default_val = na) =>
        if array.size(arr) == 0 or index < 0 or index >= array.size(arr)
            default_val
        else
            array.get(arr, index)
    
    "Utility functions created"

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  DEMONSTRATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

# Execute error prevention demonstrations
[correct_sma, conditional_sma] = demonstrate_series_simple_error()
[proper_int, good_concat, combined_score] = demonstrate_type_mismatch_fixes()
[safe_calc, safe_nz, conditional_safe] = demonstrate_na_handling()
[avg_val, max_val] = demonstrate_array_type_fixes()

# Execute error recovery strategies
robust_rsi = robust_indicator_calculation(close, 14)
[logged_result, error_count, error_log] = error_logging_calculation()
utils_status = create_type_coercion_utils()

# Use safe utilities
safe_div_result = safe_division(ta.change(close), close[1], 0.0)
validated_int = validate_and_convert_to_int(ta.rsi(close, 14), 0, 100)
adaptive_param = manage_adaptive_parameter(ta.atr(14), 20, ta.sma(ta.atr(14), 50), 10)
safe_chain_result = safe_calculation_chain(close)

# Plot results
plot(correct_sma, "Correct SMA", color.blue)
plot(robust_rsi, "Robust RSI", color.green)
plot(safe_chain_result, "Safe Chain", color.orange)
plot(error_count, "Error Count", color.red)

# Display error prevention results
var table error_table = table.new(position.bottom_left, 2, 6)

if barstate.islast
    table.clear(error_table, 0, 0, 1, 5)
    
    table.cell(error_table, 0, 0, "Error Prevention", bgcolor=color.navy, text_color=color.white)
    table.cell(error_table, 1, 0, "Status", bgcolor=color.navy, text_color=color.white)
    
    table.cell(error_table, 0, 1, "Type Errors")
    table.cell(error_table, 1, 1, error_count > 0 ? str.tostring(error_count) : "None")
    
    table.cell(error_table, 0, 2, "Safe Division")
    table.cell(error_table, 1, 2, str.tostring(safe_div_result, "0.4"))
    
    table.cell(error_table, 0, 3, "Validated Int")
    table.cell(error_table, 1, 3, str.tostring(validated_int))
    
    table.cell(error_table, 0, 4, "Adaptive Param")
    table.cell(error_table, 1, 4, str.tostring(adaptive_param))
    
    table.cell(error_table, 0, 5, "Combined Score")
    table.cell(error_table, 1, 5, str.tostring(combined_score))
```

This comprehensive guide provides Pine Script v6 developers with everything needed to understand and work effectively with the type system, from basic concepts to advanced error prevention strategies. Proper type management is essential for creating robust, efficient, and maintainable Pine Script indicators and strategies.