# Pine Script v6 Data Structures - Arrays, Matrices, and Maps

## Overview

Pine Script v6 provides three powerful data structures for handling complex data operations:
- **Arrays**: Dynamic collections of elements (same type)
- **Matrices**: Two-dimensional collections for mathematical operations
- **Maps**: Key-value pairs for efficient data lookup

These data structures enable advanced trading calculations, data storage, and algorithmic operations that would be impossible with simple variables.

---

## Arrays

Arrays are dynamic collections that can store elements of the same type. They provide efficient ways to manage historical data, calculations, and complex operations.

### Array Types

Pine Script supports arrays of all basic types:
- `array<int>` - Integer arrays
- `array<float>` - Floating-point arrays
- `array<bool>` - Boolean arrays
- `array<string>` - String arrays
- `array<color>` - Color arrays

### Array Creation

```pinescript
//@version=6
indicator("Array Creation Examples", overlay=true)

// Create arrays of different types
var prices = array.new<float>()           // Empty float array
var volumes = array.new<int>(10)          // Int array with initial size 10
var signals = array.new<bool>(5, true)   // Bool array, size 5, all elements = true
var labels = array.new<string>()         // Empty string array
var colors = array.new<color>(3, color.blue) // Color array with 3 blue elements

// Alternative creation syntax
var price_history = array.new_float()
var volume_history = array.new_int()
var signal_history = array.new_bool()
```

### Array Manipulation

#### Adding Elements

```pinescript
//@version=6
indicator("Array Manipulation - Adding", overlay=true)

var price_array = array.new<float>()

if barstate.isconfirmed
    // Add to end of array
    array.push(price_array, close)
    
    // Add to beginning of array
    array.unshift(price_array, open)
    
    // Insert at specific position (index 1)
    array.insert(price_array, 1, high)
    
    // Limit array size to last 100 bars
    if array.size(price_array) > 100
        array.shift(price_array) // Remove first element
```

#### Removing Elements

```pinescript
//@version=6
indicator("Array Manipulation - Removing", overlay=true)

var data_array = array.new<float>()

if barstate.isconfirmed and array.size(data_array) > 0
    // Remove last element
    last_value = array.pop(data_array)
    
    // Remove first element
    first_value = array.shift(data_array)
    
    // Remove element at specific index
    if array.size(data_array) > 5
        array.remove(data_array, 2) // Remove element at index 2
    
    // Clear entire array
    // array.clear(data_array)
```

### Array Access and Information

```pinescript
//@version=6
indicator("Array Access", overlay=true)

var price_data = array.new<float>()

if barstate.isconfirmed
    array.push(price_data, close)
    
    if array.size(price_data) > 10
        // Get element at index
        current_price = array.get(price_data, array.size(price_data) - 1) // Last element
        old_price = array.get(price_data, 0) // First element
        
        // Set element at index
        array.set(price_data, 5, (high + low) / 2)
        
        // Check if value exists
        contains_current = array.includes(price_data, close)
        
        // Get array information
        size = array.size(price_data)
        is_empty = size == 0
        
        // Display info
        if barstate.islast
            label.new(bar_index, high, 
                     "Array Size: " + str.tostring(size) + 
                     "\nContains Close: " + str.tostring(contains_current))
```

### Array Operations and Statistics

```pinescript
//@version=6
indicator("Array Statistics", overlay=true)

var returns = array.new<float>()
length = input.int(20, "Calculation Length")

if barstate.isconfirmed
    // Calculate return
    if bar_index > 0
        return_pct = (close - close[1]) / close[1] * 100
        array.push(returns, return_pct)
    
    // Maintain array size
    if array.size(returns) > length
        array.shift(returns)
    
    if array.size(returns) >= length
        // Statistical operations
        total_return = array.sum(returns)
        avg_return = array.avg(returns)
        min_return = array.min(returns)
        max_return = array.max(returns)
        median_return = array.median(returns)
        
        // Volatility calculation
        variance = 0.0
        for i = 0 to array.size(returns) - 1
            diff = array.get(returns, i) - avg_return
            variance := variance + diff * diff
        volatility = math.sqrt(variance / array.size(returns))
        
        // Display statistics
        if barstate.islast
            var table stats_table = table.new(position.top_right, 2, 6, bgcolor=color.white, border_width=1)
            table.cell(stats_table, 0, 0, "Metric", text_color=color.black, bgcolor=color.gray)
            table.cell(stats_table, 1, 0, "Value", text_color=color.black, bgcolor=color.gray)
            table.cell(stats_table, 0, 1, "Avg Return", text_color=color.black)
            table.cell(stats_table, 1, 1, str.tostring(avg_return, "#.##") + "%", text_color=color.black)
            table.cell(stats_table, 0, 2, "Min Return", text_color=color.black)
            table.cell(stats_table, 1, 2, str.tostring(min_return, "#.##") + "%", text_color=color.black)
            table.cell(stats_table, 0, 3, "Max Return", text_color=color.black)
            table.cell(stats_table, 1, 3, str.tostring(max_return, "#.##") + "%", text_color=color.black)
            table.cell(stats_table, 0, 4, "Volatility", text_color=color.black)
            table.cell(stats_table, 1, 4, str.tostring(volatility, "#.##") + "%", text_color=color.black)
```

### Array Sorting and Advanced Operations

```pinescript
//@version=6
indicator("Array Advanced Operations", overlay=true)

var price_levels = array.new<float>()
var sorted_prices = array.new<float>()

if barstate.isconfirmed
    // Collect significant price levels
    if high > high[1] and high > high[-1] // Local high
        array.push(price_levels, high)
    if low < low[1] and low < low[-1] // Local low
        array.push(price_levels, low)
    
    // Maintain reasonable array size
    if array.size(price_levels) > 50
        array.shift(price_levels)
    
    if array.size(price_levels) > 10
        // Copy and sort array
        array.clear(sorted_prices)
        array.concat(sorted_prices, price_levels) // Copy elements
        array.sort(sorted_prices, order.ascending)
        
        // Get price quartiles
        size = array.size(sorted_prices)
        q1_index = math.floor(size * 0.25)
        q2_index = math.floor(size * 0.50)
        q3_index = math.floor(size * 0.75)
        
        q1_price = array.get(sorted_prices, q1_index)
        q2_price = array.get(sorted_prices, q2_index) // Median
        q3_price = array.get(sorted_prices, q3_index)
        
        // Create slice of top quartile
        top_quartile = array.slice(sorted_prices, q3_index, size)
        
        // Join array elements into string for display
        price_string = array.join(array.slice(sorted_prices, 0, math.min(5, size)), ", ")
        
        // Display results
        if barstate.islast
            label.new(bar_index, high * 1.02, 
                     "Price Levels Analysis\n" +
                     "Q1: " + str.tostring(q1_price, "#.##") + "\n" +
                     "Median: " + str.tostring(q2_price, "#.##") + "\n" +
                     "Q3: " + str.tostring(q3_price, "#.##") + "\n" +
                     "Sample: " + price_string,
                     style=label.style_label_down)
```

---

## Matrices

Matrices are two-dimensional arrays perfect for mathematical operations, correlation analysis, and complex calculations.

### Matrix Creation and Basic Operations

```pinescript
//@version=6
indicator("Matrix Basics", overlay=true)

// Create matrices
var correlation_matrix = matrix.new<float>(3, 3, 0.0) // 3x3 matrix filled with zeros
var price_matrix = matrix.new<float>(5, 4) // 5x4 matrix (uninitialized)

// Matrix dimensions
rows = matrix.rows(correlation_matrix)
cols = matrix.columns(correlation_matrix)

if barstate.isconfirmed
    // Set matrix elements
    matrix.set(correlation_matrix, 0, 0, 1.0) // Self-correlation
    matrix.set(correlation_matrix, 1, 1, 1.0)
    matrix.set(correlation_matrix, 2, 2, 1.0)
    
    // Get matrix elements
    value = matrix.get(correlation_matrix, 0, 1)
    
    // Display matrix info
    if barstate.islast
        label.new(bar_index, high, 
                 "Matrix: " + str.tostring(rows) + "x" + str.tostring(cols))
```

### Price Correlation Matrix

```pinescript
//@version=6
indicator("Price Correlation Matrix", overlay=true)

length = input.int(20, "Calculation Period")
var price_data = matrix.new<float>(length, 4) // OHLC data
var correlation_matrix = matrix.new<float>(4, 4, 0.0)

if barstate.isconfirmed and bar_index >= length
    // Collect OHLC data in matrix
    for i = 0 to length - 1
        matrix.set(price_data, i, 0, open[length - 1 - i])
        matrix.set(price_data, i, 1, high[length - 1 - i])
        matrix.set(price_data, i, 2, low[length - 1 - i])
        matrix.set(price_data, i, 3, close[length - 1 - i])
    
    // Calculate correlation matrix
    for i = 0 to 3
        for j = 0 to 3
            if i == j
                correlation = 1.0
            else
                // Calculate correlation between columns i and j
                sum_i = 0.0
                sum_j = 0.0
                sum_ij = 0.0
                sum_i2 = 0.0
                sum_j2 = 0.0
                
                for k = 0 to length - 1
                    val_i = matrix.get(price_data, k, i)
                    val_j = matrix.get(price_data, k, j)
                    sum_i := sum_i + val_i
                    sum_j := sum_j + val_j
                    sum_ij := sum_ij + val_i * val_j
                    sum_i2 := sum_i2 + val_i * val_i
                    sum_j2 := sum_j2 + val_j * val_j
                
                numerator = length * sum_ij - sum_i * sum_j
                denominator = math.sqrt((length * sum_i2 - sum_i * sum_i) * (length * sum_j2 - sum_j * sum_j))
                correlation = denominator != 0 ? numerator / denominator : 0.0
            
            matrix.set(correlation_matrix, i, j, correlation)
    
    // Display correlation matrix
    if barstate.islast
        var table corr_table = table.new(position.bottom_right, 5, 5, bgcolor=color.white, border_width=1)
        
        // Headers
        table.cell(corr_table, 0, 0, "", bgcolor=color.gray)
        table.cell(corr_table, 1, 0, "O", bgcolor=color.gray, text_color=color.white)
        table.cell(corr_table, 2, 0, "H", bgcolor=color.gray, text_color=color.white)
        table.cell(corr_table, 3, 0, "L", bgcolor=color.gray, text_color=color.white)
        table.cell(corr_table, 4, 0, "C", bgcolor=color.gray, text_color=color.white)
        
        headers = array.from("O", "H", "L", "C")
        for i = 0 to 3
            table.cell(corr_table, 0, i + 1, array.get(headers, i), bgcolor=color.gray, text_color=color.white)
            for j = 0 to 3
                corr_value = matrix.get(correlation_matrix, i, j)
                cell_color = corr_value > 0.8 ? color.green : corr_value < 0.2 ? color.red : color.white
                table.cell(corr_table, j + 1, i + 1, str.tostring(corr_value, "#.##"), 
                          bgcolor=cell_color, text_color=color.black)
```

### Matrix Mathematical Operations

```pinescript
//@version=6
indicator("Matrix Math Operations", overlay=true)

var matrix_a = matrix.new<float>(2, 2)
var matrix_b = matrix.new<float>(2, 2)
var result_matrix = matrix.new<float>(2, 2)

if barstate.isconfirmed
    // Initialize matrices with sample data
    matrix.set(matrix_a, 0, 0, close)
    matrix.set(matrix_a, 0, 1, open)
    matrix.set(matrix_a, 1, 0, high)
    matrix.set(matrix_a, 1, 1, low)
    
    matrix.set(matrix_b, 0, 0, 1.0)
    matrix.set(matrix_b, 0, 1, 0.5)
    matrix.set(matrix_b, 1, 0, 0.5)
    matrix.set(matrix_b, 1, 1, 1.0)
    
    // Matrix operations
    matrix.mult(matrix_a, matrix_b, result_matrix) // Matrix multiplication
    
    // Alternative operations (create new matrices)
    sum_matrix = matrix.add(matrix_a, matrix_b) // Matrix addition
    diff_matrix = matrix.diff(matrix_a, matrix_b) // Matrix subtraction
    transpose_a = matrix.transpose(matrix_a) // Matrix transpose
    
    // Matrix statistics
    max_value = matrix.max(matrix_a)
    min_value = matrix.min(matrix_a)
    avg_value = matrix.avg(matrix_a)
    
    // Display results
    if barstate.islast
        result_00 = matrix.get(result_matrix, 0, 0)
        result_01 = matrix.get(result_matrix, 0, 1)
        result_10 = matrix.get(result_matrix, 1, 0)
        result_11 = matrix.get(result_matrix, 1, 1)
        
        label.new(bar_index, high, 
                 "Matrix Results:\n" +
                 "A×B = [" + str.tostring(result_00, "#.##") + ", " + str.tostring(result_01, "#.##") + "]\n" +
                 "      [" + str.tostring(result_10, "#.##") + ", " + str.tostring(result_11, "#.##") + "]\n" +
                 "Max: " + str.tostring(max_value, "#.##") + "\n" +
                 "Avg: " + str.tostring(avg_value, "#.##"))
```

---

## Maps

Maps store key-value pairs and provide efficient data lookup operations. They're perfect for storing symbol-specific data, configuration settings, or cached calculations.

### Map Creation and Basic Operations

```pinescript
//@version=6
indicator("Map Basics", overlay=true)

// Create maps of different types
var symbol_data = map.new<string, float>() // String keys, float values
var config_map = map.new<string, string>() // String keys, string values
var cache_map = map.new<int, float>() // Integer keys, float values

if barstate.isconfirmed
    // Add key-value pairs
    map.put(symbol_data, syminfo.ticker, close)
    map.put(config_map, "timeframe", timeframe.period)
    map.put(cache_map, bar_index, volume)
    
    // Check if key exists
    has_ticker = map.contains(symbol_data, syminfo.ticker)
    
    // Get value by key
    if has_ticker
        current_price = map.get(symbol_data, syminfo.ticker)
    
    // Get map information
    size = map.size(symbol_data)
    
    // Remove entries
    if map.size(cache_map) > 100
        // Remove old entries (this is simplified - in practice you'd track keys)
        oldest_key = bar_index - 100
        if map.contains(cache_map, oldest_key)
            map.remove(cache_map, oldest_key)
```

### Symbol Performance Tracker

```pinescript
//@version=6
indicator("Symbol Performance Map", overlay=true)

var performance_map = map.new<string, float>()
var base_prices = map.new<string, float>()

// Input for tracking multiple symbols
track_symbols = input.string("AAPL,GOOGL,MSFT,TSLA", "Symbols to Track (comma-separated)")
symbols_array = str.split(track_symbols, ",")

if barstate.isconfirmed
    current_symbol = syminfo.ticker
    
    // Initialize base price for current symbol if not exists
    if not map.contains(base_prices, current_symbol)
        map.put(base_prices, current_symbol, close)
    
    // Calculate performance
    base_price = map.get(base_prices, current_symbol)
    performance = (close - base_price) / base_price * 100
    map.put(performance_map, current_symbol, performance)
    
    // Display performance data
    if barstate.islast and map.size(performance_map) > 0
        var table perf_table = table.new(position.top_left, 2, map.size(performance_map) + 1, 
                                        bgcolor=color.white, border_width=1)
        
        table.cell(perf_table, 0, 0, "Symbol", bgcolor=color.gray, text_color=color.white)
        table.cell(perf_table, 1, 0, "Performance %", bgcolor=color.gray, text_color=color.white)
        
        // Get all keys and display them
        all_keys = map.keys(performance_map)
        for i = 0 to array.size(all_keys) - 1
            symbol = array.get(all_keys, i)
            perf_value = map.get(performance_map, symbol)
            cell_color = perf_value > 0 ? color.new(color.green, 80) : color.new(color.red, 80)
            
            table.cell(perf_table, 0, i + 1, symbol, text_color=color.black)
            table.cell(perf_table, 1, i + 1, str.tostring(perf_value, "#.##") + "%", 
                      bgcolor=cell_color, text_color=color.black)
```

### Configuration and Settings Map

```pinescript
//@version=6
indicator("Settings Map Example", overlay=true)

var settings_map = map.new<string, string>()
var numeric_settings = map.new<string, float>()

// Initialize default settings
if barstate.isfirst
    map.put(settings_map, "mode", "normal")
    map.put(settings_map, "alert_type", "email")
    map.put(settings_map, "display_format", "percentage")
    
    map.put(numeric_settings, "threshold", 2.0)
    map.put(numeric_settings, "lookback", 20.0)
    map.put(numeric_settings, "multiplier", 1.5)

// Function to get setting with default
get_string_setting(key, default_value) =>
    map.contains(settings_map, key) ? map.get(settings_map, key) : default_value

get_numeric_setting(key, default_value) =>
    map.contains(numeric_settings, key) ? map.get(numeric_settings, key) : default_value

// Use settings in calculations
threshold = get_numeric_setting("threshold", 2.0)
lookback_period = int(get_numeric_setting("lookback", 20.0))
display_mode = get_string_setting("mode", "normal")

// Example calculation using settings
rsi_value = ta.rsi(close, lookback_period)
signal_triggered = rsi_value > (50 + threshold) or rsi_value < (50 - threshold)

// Update settings based on market conditions
if barstate.isconfirmed
    volatility = ta.atr(14) / close * 100
    if volatility > 3.0
        map.put(settings_map, "mode", "high_volatility")
        map.put(numeric_settings, "threshold", 3.0)
    else
        map.put(settings_map, "mode", "normal")
        map.put(numeric_settings, "threshold", 2.0)

// Display current settings
if barstate.islast
    all_string_keys = map.keys(settings_map)
    all_numeric_keys = map.keys(numeric_settings)
    
    settings_text = "Current Settings:\n"
    for i = 0 to array.size(all_string_keys) - 1
        key = array.get(all_string_keys, i)
        value = map.get(settings_map, key)
        settings_text := settings_text + key + ": " + value + "\n"
    
    for i = 0 to array.size(all_numeric_keys) - 1
        key = array.get(all_numeric_keys, i)
        value = map.get(numeric_settings, key)
        settings_text := settings_text + key + ": " + str.tostring(value) + "\n"
    
    label.new(bar_index, low * 0.98, settings_text, style=label.style_label_up, size=size.small)
```

---

## Performance Optimization and Memory Management

### Best Practices

1. **Array Size Management**
```pinescript
//@version=6
indicator("Array Size Management", overlay=true)

var price_history = array.new<float>()
MAX_SIZE = 500 // Pine Script limit

if barstate.isconfirmed
    array.push(price_history, close)
    
    // Efficient size management
    if array.size(price_history) > MAX_SIZE
        array.shift(price_history) // Remove oldest element
```

2. **Matrix Memory Efficiency**
```pinescript
//@version=6
indicator("Matrix Memory Efficiency", overlay=true)

// Reuse matrices instead of creating new ones
var working_matrix = matrix.new<float>(10, 10)
var result_matrix = matrix.new<float>(10, 10)

// Clear and reuse instead of creating new
if barstate.isconfirmed
    // Fill with new data
    for i = 0 to 9
        for j = 0 to 9
            matrix.set(working_matrix, i, j, math.random(0, 100))
```

3. **Map Cleanup Strategies**
```pinescript
//@version=6
indicator("Map Cleanup", overlay=true)

var data_cache = map.new<int, float>()
var access_times = map.new<int, int>()
MAX_CACHE_SIZE = 100

if barstate.isconfirmed
    // Add new data
    map.put(data_cache, bar_index, close)
    map.put(access_times, bar_index, timenow)
    
    // Cleanup old entries
    if map.size(data_cache) > MAX_CACHE_SIZE
        oldest_time = timenow - 86400000 // 24 hours ago
        keys_to_remove = array.new<int>()
        
        all_keys = map.keys(access_times)
        for i = 0 to array.size(all_keys) - 1
            key = array.get(all_keys, i)
            if map.get(access_times, key) < oldest_time
                array.push(keys_to_remove, key)
        
        // Remove old entries
        for i = 0 to array.size(keys_to_remove) - 1
            key = array.get(keys_to_remove, i)
            map.remove(data_cache, key)
            map.remove(access_times, key)
```

### Performance Tips

1. **Use appropriate data structure for the task:**
   - Arrays for sequential data and time series
   - Matrices for mathematical calculations and correlations
   - Maps for key-value lookups and caching

2. **Manage memory actively:**
   - Limit array/matrix sizes
   - Clean up old map entries
   - Reuse objects when possible

3. **Optimize access patterns:**
   - Use `array.get()` with known indices
   - Cache frequently accessed map values
   - Avoid unnecessary iterations

4. **Pine Script Limits:**
   - Maximum 500 elements in arrays
   - Maximum 100,000 matrix elements total
   - Maximum 10,000 map entries
   - Consider these limits in your design

---

## Common Use Cases

### 1. Rolling Correlation Analysis
```pinescript
// Use matrices to calculate rolling correlations between multiple assets
var correlation_data = matrix.new<float>(20, 2) // 20 periods, 2 assets
```

### 2. Multi-Symbol Performance Tracking
```pinescript
// Use maps to track performance across different symbols
var symbol_performance = map.new<string, float>()
```

### 3. Custom Indicator Value Storage
```pinescript
// Use arrays to store custom calculations over time
var custom_indicator = array.new<float>()
```

### 4. Configuration Management
```pinescript
// Use maps for dynamic configuration management
var config = map.new<string, string>()
```

### 5. Statistical Analysis
```pinescript
// Use arrays for statistical calculations
var returns_array = array.new<float>()
// Calculate mean, variance, skewness, kurtosis
```

This comprehensive guide covers all major aspects of Pine Script v6 data structures. Use these examples as starting points for your own implementations, always considering performance and memory management in your designs.