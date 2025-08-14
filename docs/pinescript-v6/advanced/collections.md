# Pine Script v6 Collections Comprehensive Guide

Collections in Pine Script v6 (arrays, matrices, and maps) provide powerful data structures for complex analysis and calculations. This guide covers advanced techniques, performance optimization, and real-world applications.

## Table of Contents
1. [Advanced Array Techniques](#advanced-array-techniques)
2. [Matrix Operations for Analysis](#matrix-operations-for-analysis)
3. [Map Usage Patterns](#map-usage-patterns)
4. [Nested Data Structures](#nested-data-structures)
5. [Collection Performance](#collection-performance)
6. [Memory Management](#memory-management)
7. [Sorting and Searching](#sorting-and-searching)
8. [Statistical Operations](#statistical-operations)
9. [Real-World Applications](#real-world-applications)

---

## Advanced Array Techniques

### Dynamic Array Management
```pinescript
//@version=6
indicator("Advanced Array Management", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              DYNAMIC ARRAY SIZING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Dynamic price history with automatic size management
var price_history = array.new<float>()
var volume_history = array.new<float>()
max_history_size = 500

// Function to maintain array size
maintain_array_size(arr, max_size) =>
    while array.size(arr) > max_size
        array.shift(arr)  // Remove oldest element

// Add new data and maintain size
array.push(price_history, close)
array.push(volume_history, volume)
maintain_array_size(price_history, max_history_size)
maintain_array_size(volume_history, max_history_size)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              SLIDING WINDOW OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Sliding window for complex calculations
sliding_window_calc(source_array, window_size, calc_type) =>
    if array.size(source_array) < window_size
        na
    else
        # Extract last N elements
        window_data = array.new<float>()
        start_index = array.size(source_array) - window_size
        
        for i = start_index to array.size(source_array) - 1
            array.push(window_data, array.get(source_array, i))
        
        # Perform calculation based on type
        switch calc_type
            "mean" => array.avg(window_data)
            "median" => array.median(window_data)
            "std" => array.stdev(window_data)
            "range" => array.max(window_data) - array.min(window_data)
            "slope" => calculate_slope(window_data)
            => na

// Custom slope calculation
calculate_slope(data_array) =>
    size = array.size(data_array)
    if size < 2
        na
    else
        sum_x = 0.0
        sum_y = 0.0
        sum_xy = 0.0
        sum_x_squared = 0.0
        
        for i = 0 to size - 1
            x = i + 1  // X values: 1, 2, 3, ...
            y = array.get(data_array, i)
            
            sum_x += x
            sum_y += y
            sum_xy += x * y
            sum_x_squared += x * x
        
        # Linear regression slope formula
        denominator = size * sum_x_squared - sum_x * sum_x
        denominator == 0 ? na : (size * sum_xy - sum_x * sum_y) / denominator

// Calculate various metrics
price_20_mean = sliding_window_calc(price_history, 20, "mean")
price_20_slope = sliding_window_calc(price_history, 20, "slope")
volume_20_std = sliding_window_calc(volume_history, 20, "std")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              ARRAY TRANSFORMATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Transform arrays with custom functions
transform_array(source_array, transform_type) =>
    if array.size(source_array) == 0
        array.new<float>()
    else
        result = array.new<float>()
        
        for i = 0 to array.size(source_array) - 1
            value = array.get(source_array, i)
            transformed_value = switch transform_type
                "log" => value > 0 ? math.log(value) : na
                "sqrt" => value >= 0 ? math.sqrt(value) : na
                "normalize" => normalize_value(value, source_array)
                "percentile_rank" => percentile_rank(value, source_array)
                "z_score" => z_score(value, source_array)
                => value
            
            array.push(result, transformed_value)
        
        result

// Helper functions for transformations
normalize_value(value, reference_array) =>
    min_val = array.min(reference_array)
    max_val = array.max(reference_array)
    range_val = max_val - min_val
    range_val == 0 ? 0.5 : (value - min_val) / range_val

percentile_rank(value, reference_array) =>
    count_below = 0
    total_count = array.size(reference_array)
    
    for i = 0 to total_count - 1
        if array.get(reference_array, i) < value
            count_below += 1
    
    count_below / total_count * 100

z_score(value, reference_array) =>
    mean_val = array.avg(reference_array)
    std_val = array.stdev(reference_array)
    std_val == 0 ? 0 : (value - mean_val) / std_val

// Apply transformations
log_prices = transform_array(price_history, "log")
normalized_volume = transform_array(volume_history, "normalize")

// Plot results
plot(price_20_slope, "Price Slope", color.blue)
plot(z_score(close, price_history), "Current Z-Score", color.red)
```

### Multi-Dimensional Arrays
```pinescript
//@version=6
indicator("Multi-Dimensional Arrays", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                           MULTI-TIMEFRAME DATA STORAGE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Store OHLCV data for multiple timeframes
var mtf_data = array.new<array<float>>()

// Initialize arrays for different timeframes
init_mtf_storage() =>
    timeframes = array.from("5", "15", "60", "240", "1D")
    
    for i = 0 to array.size(timeframes) - 1
        tf_data = array.new<float>()  // Will store [O, H, L, C, V]
        array.push(mtf_data, tf_data)

// Initialize on first bar
if barstate.isfirst
    init_mtf_storage()

// Function to update MTF data
update_mtf_data(tf_index, ohlcv_data) =>
    if array.size(mtf_data) > tf_index
        tf_array = array.get(mtf_data, tf_index)
        array.clear(tf_array)
        
        # Add OHLCV values
        for i = 0 to array.size(ohlcv_data) - 1
            array.push(tf_array, array.get(ohlcv_data, i))

// Get data for different timeframes (example with 5-minute)
[mtf_5m_o, mtf_5m_h, mtf_5m_l, mtf_5m_c, mtf_5m_v] = request.security(
    syminfo.tickerid, "5", [open, high, low, close, volume])

if not na(mtf_5m_c)
    ohlcv_5m = array.from(mtf_5m_o, mtf_5m_h, mtf_5m_l, mtf_5m_c, mtf_5m_v)
    update_mtf_data(0, ohlcv_5m)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               CORRELATION MATRIX
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Store price data for multiple symbols
var symbol_prices = map.new<string, array<float>>()

// Symbol list for correlation analysis
symbols = array.from("SPY", "QQQ", "IWM", "DIA")

// Initialize symbol price arrays
init_symbol_storage() =>
    for i = 0 to array.size(symbols) - 1
        symbol = array.get(symbols, i)
        price_array = array.new<float>()
        map.put(symbol_prices, symbol, price_array)

if barstate.isfirst
    init_symbol_storage()

// Update symbol prices
update_symbol_prices() =>
    for i = 0 to array.size(symbols) - 1
        symbol = array.get(symbols, i)
        symbol_close = request.security(symbol, timeframe.period, close)
        
        if not na(symbol_close) and map.contains(symbol_prices, symbol)
            price_array = map.get(symbol_prices, symbol)
            array.push(price_array, symbol_close)
            
            # Maintain max size
            if array.size(price_array) > 100
                array.shift(price_array)

update_symbol_prices()

// Calculate correlation matrix
calculate_correlation_matrix() =>
    correlation_matrix = array.new<array<float>>()
    symbol_count = array.size(symbols)
    
    for i = 0 to symbol_count - 1
        correlation_row = array.new<float>()
        symbol1 = array.get(symbols, i)
        
        for j = 0 to symbol_count - 1
            symbol2 = array.get(symbols, j)
            
            if i == j
                array.push(correlation_row, 1.0)  // Self-correlation
            else
                prices1 = map.get(symbol_prices, symbol1)
                prices2 = map.get(symbol_prices, symbol2)
                
                if array.size(prices1) > 10 and array.size(prices2) > 10
                    corr = calculate_correlation(prices1, prices2)
                    array.push(correlation_row, corr)
                else
                    array.push(correlation_row, na)
        
        array.push(correlation_matrix, correlation_row)
    
    correlation_matrix

// Helper function to calculate correlation
calculate_correlation(array1, array2) =>
    size1 = array.size(array1)
    size2 = array.size(array2)
    min_size = math.min(size1, size2)
    
    if min_size < 2
        na
    else
        # Calculate means
        sum1 = 0.0
        sum2 = 0.0
        for i = 0 to min_size - 1
            sum1 += array.get(array1, size1 - min_size + i)
            sum2 += array.get(array2, size2 - min_size + i)
        
        mean1 = sum1 / min_size
        mean2 = sum2 / min_size
        
        # Calculate correlation
        numerator = 0.0
        sum_sq1 = 0.0
        sum_sq2 = 0.0
        
        for i = 0 to min_size - 1
            val1 = array.get(array1, size1 - min_size + i) - mean1
            val2 = array.get(array2, size2 - min_size + i) - mean2
            
            numerator += val1 * val2
            sum_sq1 += val1 * val1
            sum_sq2 += val2 * val2
        
        denominator = math.sqrt(sum_sq1 * sum_sq2)
        denominator == 0 ? na : numerator / denominator

// Get correlation matrix
correlation_matrix = calculate_correlation_matrix()
```

---

## Matrix Operations for Analysis

### Financial Matrix Calculations
```pinescript
//@version=6
indicator("Matrix Financial Analysis", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PORTFOLIO COVARIANCE MATRIX
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Create returns matrix for portfolio analysis
var returns_matrix = matrix.new<float>()
var asset_names = array.from("AAPL", "GOOGL", "MSFT", "TSLA")
lookback_period = 50

// Initialize matrix on first bar
if barstate.isfirst
    # Initialize with proper dimensions
    returns_matrix := matrix.new<float>(lookback_period, array.size(asset_names), na)

// Function to add new returns data
add_returns_row(returns_data) =>
    # Shift all rows up
    for row = 0 to matrix.rows(returns_matrix) - 2
        for col = 0 to matrix.columns(returns_matrix) - 1
            next_value = matrix.get(returns_matrix, row + 1, col)
            matrix.set(returns_matrix, row, col, next_value)
    
    # Add new data to last row
    for col = 0 to array.size(returns_data) - 1
        if array.size(returns_data) > col
            matrix.set(returns_matrix, matrix.rows(returns_matrix) - 1, col, 
                      array.get(returns_data, col))

// Get returns for all assets
get_asset_returns() =>
    returns_data = array.new<float>()
    
    for i = 0 to array.size(asset_names) - 1
        asset = array.get(asset_names, i)
        asset_close = request.security(asset, timeframe.period, close)
        asset_return = request.security(asset, timeframe.period, ta.change(close) / close[1])
        
        if not na(asset_return)
            array.push(returns_data, asset_return)
        else
            array.push(returns_data, 0.0)
    
    returns_data

# Update returns matrix
if not na(close)
    current_returns = get_asset_returns()
    add_returns_row(current_returns)

// Calculate covariance matrix
calculate_covariance_matrix() =>
    num_assets = matrix.columns(returns_matrix)
    cov_matrix = matrix.new<float>(num_assets, num_assets, 0.0)
    
    # Calculate means for each asset
    means = array.new<float>()
    for col = 0 to num_assets - 1
        sum = 0.0
        count = 0
        
        for row = 0 to matrix.rows(returns_matrix) - 1
            value = matrix.get(returns_matrix, row, col)
            if not na(value)
                sum += value
                count += 1
        
        mean_return = count > 0 ? sum / count : 0.0
        array.push(means, mean_return)
    
    # Calculate covariances
    for i = 0 to num_assets - 1
        for j = 0 to num_assets - 1
            covariance = 0.0
            count = 0
            mean_i = array.get(means, i)
            mean_j = array.get(means, j)
            
            for row = 0 to matrix.rows(returns_matrix) - 1
                return_i = matrix.get(returns_matrix, row, i)
                return_j = matrix.get(returns_matrix, row, j)
                
                if not na(return_i) and not na(return_j)
                    covariance += (return_i - mean_i) * (return_j - mean_j)
                    count += 1
            
            final_covariance = count > 1 ? covariance / (count - 1) : 0.0
            matrix.set(cov_matrix, i, j, final_covariance)
    
    cov_matrix

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PRINCIPAL COMPONENT ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simplified PCA for dimensionality reduction
perform_pca(data_matrix) =>
    # This is a simplified version - full PCA requires eigenvalue decomposition
    # which is complex to implement in Pine Script
    
    rows = matrix.rows(data_matrix)
    cols = matrix.columns(data_matrix)
    
    # Center the data (subtract means)
    centered_matrix = matrix.copy(data_matrix)
    
    for col = 0 to cols - 1
        # Calculate column mean
        sum = 0.0
        count = 0
        for row = 0 to rows - 1
            value = matrix.get(data_matrix, row, col)
            if not na(value)
                sum += value
                count += 1
        
        mean_val = count > 0 ? sum / count : 0.0
        
        # Subtract mean from each element
        for row = 0 to rows - 1
            current_value = matrix.get(centered_matrix, row, col)
            if not na(current_value)
                matrix.set(centered_matrix, row, col, current_value - mean_val)
    
    centered_matrix

// Calculate principal components
pca_matrix = perform_pca(returns_matrix)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               TECHNICAL MATRIX OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Create price pattern matrix for pattern recognition
var pattern_matrix = matrix.new<float>()
pattern_length = 10
pattern_count = 20

if barstate.isfirst
    pattern_matrix := matrix.new<float>(pattern_count, pattern_length, na)

// Add new price pattern
add_price_pattern() =>
    # Create current pattern
    current_pattern = array.new<float>()
    for i = pattern_length - 1 to 0
        if bar_index >= i
            normalized_price = close[i] / close[pattern_length - 1]  # Normalize to first price
            array.push(current_pattern, normalized_price)
    
    # Shift patterns up
    for row = 0 to matrix.rows(pattern_matrix) - 2
        for col = 0 to matrix.columns(pattern_matrix) - 1
            next_value = matrix.get(pattern_matrix, row + 1, col)
            matrix.set(pattern_matrix, row, col, next_value)
    
    # Add new pattern to last row
    for col = 0 to array.size(current_pattern) - 1
        pattern_value = array.get(current_pattern, col)
        matrix.set(pattern_matrix, matrix.rows(pattern_matrix) - 1, col, pattern_value)

# Update pattern matrix every 5 bars
if bar_index % 5 == 0 and bar_index >= pattern_length
    add_price_pattern()

// Find similar patterns
find_similar_patterns(current_pattern, similarity_threshold = 0.95) =>
    similar_patterns = array.new<int>()
    
    if array.size(current_pattern) == matrix.columns(pattern_matrix)
        for row = 0 to matrix.rows(pattern_matrix) - 1
            correlation = 0.0
            sum_x = 0.0
            sum_y = 0.0
            sum_xy = 0.0
            sum_x2 = 0.0
            sum_y2 = 0.0
            count = 0
            
            for col = 0 to matrix.columns(pattern_matrix) - 1
                x = array.get(current_pattern, col)
                y = matrix.get(pattern_matrix, row, col)
                
                if not na(x) and not na(y)
                    sum_x += x
                    sum_y += y
                    sum_xy += x * y
                    sum_x2 += x * x
                    sum_y2 += y * y
                    count += 1
            
            if count > 0
                n = count
                numerator = n * sum_xy - sum_x * sum_y
                denominator = math.sqrt((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y))
                
                if denominator != 0
                    correlation := numerator / denominator
                    
                    if correlation >= similarity_threshold
                        array.push(similar_patterns, row)
    
    similar_patterns
```

---

## Map Usage Patterns

### Advanced Map Applications
```pinescript
//@version=6
indicator("Advanced Map Usage", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               SYMBOL TRACKING SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Multi-dimensional symbol tracking using nested maps
var symbol_data = map.new<string, map<string, float>>()
var symbol_arrays = map.new<string, map<string, array<float>>>()

// Initialize symbol tracking
init_symbol_tracking() =>
    symbols = array.from("AAPL", "GOOGL", "MSFT", "AMZN", "TSLA")
    metrics = array.from("price", "volume", "rsi", "macd", "atr")
    
    for i = 0 to array.size(symbols) - 1
        symbol = array.get(symbols, i)
        
        # Initialize current data map
        current_data = map.new<string, float>()
        for j = 0 to array.size(metrics) - 1
            metric = array.get(metrics, j)
            map.put(current_data, metric, na)
        map.put(symbol_data, symbol, current_data)
        
        # Initialize historical data arrays
        historical_data = map.new<string, array<float>>()
        for j = 0 to array.size(metrics) - 1
            metric = array.get(metrics, j)
            map.put(historical_data, metric, array.new<float>())
        map.put(symbol_arrays, symbol, historical_data)

if barstate.isfirst
    init_symbol_tracking()

// Update symbol data
update_symbol_data(symbol, price, volume_val, rsi_val, macd_val, atr_val) =>
    if map.contains(symbol_data, symbol)
        current_data = map.get(symbol_data, symbol)
        historical_data = map.get(symbol_arrays, symbol)
        
        # Update current values
        map.put(current_data, "price", price)
        map.put(current_data, "volume", volume_val)
        map.put(current_data, "rsi", rsi_val)
        map.put(current_data, "macd", macd_val)
        map.put(current_data, "atr", atr_val)
        
        # Add to historical arrays
        metrics = array.from("price", "volume", "rsi", "macd", "atr")
        values = array.from(price, volume_val, rsi_val, macd_val, atr_val)
        
        for i = 0 to array.size(metrics) - 1
            metric = array.get(metrics, i)
            value = array.get(values, i)
            
            if map.contains(historical_data, metric)
                metric_array = map.get(historical_data, metric)
                array.push(metric_array, value)
                
                # Maintain array size
                if array.size(metric_array) > 100
                    array.shift(metric_array)

// Get data for multiple symbols
symbols_to_track = array.from("AAPL", "GOOGL", "MSFT")

for i = 0 to array.size(symbols_to_track) - 1
    symbol = array.get(symbols_to_track, i)
    
    [sym_close, sym_volume] = request.security(symbol, timeframe.period, [close, volume])
    sym_rsi = request.security(symbol, timeframe.period, ta.rsi(close, 14))
    sym_macd = request.security(symbol, timeframe.period, ta.macd(close, 12, 26, 9))
    sym_atr = request.security(symbol, timeframe.period, ta.atr(14))
    
    if not na(sym_close)
        update_symbol_data(symbol, sym_close, sym_volume, sym_rsi, sym_macd, sym_atr)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   CACHE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Advanced caching system for expensive calculations
var calculation_cache = map.new<string, map<string, float>>()
var cache_timestamps = map.new<string, int>()
cache_ttl = 300000  // Cache time-to-live in milliseconds

// Cache management functions
is_cache_valid(cache_key) =>
    if map.contains(cache_timestamps, cache_key)
        cache_time = map.get(cache_timestamps, cache_key)
        (time - cache_time) < cache_ttl
    else
        false

get_from_cache(cache_key, data_key) =>
    if is_cache_valid(cache_key) and map.contains(calculation_cache, cache_key)
        cache_data = map.get(calculation_cache, cache_key)
        if map.contains(cache_data, data_key)
            map.get(cache_data, data_key)
        else
            na
    else
        na

put_to_cache(cache_key, data_key, value) =>
    # Get or create cache entry
    cache_data = map.contains(calculation_cache, cache_key) ? 
                map.get(calculation_cache, cache_key) : 
                map.new<string, float>()
    
    # Update data
    map.put(cache_data, data_key, value)
    map.put(calculation_cache, cache_key, cache_data)
    map.put(cache_timestamps, cache_key, time)

// Example: Cached correlation calculation
calculate_cached_correlation(symbol1, symbol2, period) =>
    cache_key = symbol1 + "_" + symbol2 + "_" + str.tostring(period)
    cached_result = get_from_cache(cache_key, "correlation")
    
    if not na(cached_result)
        cached_result
    else
        # Perform expensive calculation
        [price1, price2] = request.security(symbol1, timeframe.period, [close, close], 
                          lookahead=barmerge.lookahead_off)
        correlation = ta.correlation(ta.change(price1), ta.change(price2), period)
        
        # Cache result
        put_to_cache(cache_key, "correlation", correlation)
        correlation

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               STATE MACHINE USING MAPS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Trading state machine using maps
var trading_state = map.new<string, string>()
var state_data = map.new<string, float>()

// Initialize state machine
init_state_machine() =>
    map.put(trading_state, "current_state", "waiting")
    map.put(trading_state, "previous_state", "waiting")
    map.put(state_data, "entry_price", 0.0)
    map.put(state_data, "stop_loss", 0.0)
    map.put(state_data, "take_profit", 0.0)
    map.put(state_data, "position_size", 0.0)

if barstate.isfirst
    init_state_machine()

// State transition function
transition_state(new_state, transition_data = na) =>
    current = map.get(trading_state, "current_state")
    map.put(trading_state, "previous_state", current)
    map.put(trading_state, "current_state", new_state)
    
    # Update state data if provided
    if not na(transition_data)
        for i = 0 to array.size(transition_data) - 1
            data_pair = array.get(transition_data, i)
            if array.size(data_pair) >= 2
                key = array.get(data_pair, 0)
                value = array.get(data_pair, 1)
                map.put(state_data, key, value)

// Get current state
get_current_state() =>
    map.get(trading_state, "current_state")

// State machine logic
current_state = get_current_state()

# Example state transitions
buy_signal = ta.crossover(ta.sma(close, 10), ta.sma(close, 20))
sell_signal = ta.crossunder(ta.sma(close, 10), ta.sma(close, 20))

if current_state == "waiting" and buy_signal
    entry_data = array.new<array<string>>()
    array.push(entry_data, array.from("entry_price", str.tostring(close)))
    array.push(entry_data, array.from("stop_loss", str.tostring(close * 0.98)))
    array.push(entry_data, array.from("take_profit", str.tostring(close * 1.05)))
    
    transition_state("long_position", entry_data)

if current_state == "long_position" and sell_signal
    transition_state("waiting")

// Get state data
entry_price = map.get(state_data, "entry_price")
current_pnl = current_state == "long_position" ? (close - entry_price) / entry_price * 100 : 0.0

plot(current_pnl, "Current P&L %", color=current_pnl > 0 ? color.green : color.red)
```

---

## Nested Data Structures

### Complex Data Organization
```pinescript
//@version=6
indicator("Nested Data Structures", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                            HIERARCHICAL MARKET DATA
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Structure: Sector -> Industry -> Symbol -> Metrics
var market_data = map.new<string, map<string, map<string, array<float>>>>()

// Initialize market structure
init_market_structure() =>
    # Technology Sector
    tech_sector = map.new<string, map<string, array<float>>>()
    
    # Software Industry
    software_industry = map.new<string, array<float>>()
    map.put(software_industry, "MSFT", array.new<float>())
    map.put(software_industry, "ORCL", array.new<float>())
    map.put(tech_sector, "Software", software_industry)
    
    # Hardware Industry
    hardware_industry = map.new<string, array<float>>()
    map.put(hardware_industry, "AAPL", array.new<float>())
    map.put(hardware_industry, "NVDA", array.new<float>())
    map.put(tech_sector, "Hardware", hardware_industry)
    
    map.put(market_data, "Technology", tech_sector)
    
    # Financial Sector
    finance_sector = map.new<string, map<string, array<float>>>()
    
    # Banks Industry
    banks_industry = map.new<string, array<float>>()
    map.put(banks_industry, "JPM", array.new<float>())
    map.put(banks_industry, "BAC", array.new<float>())
    map.put(finance_sector, "Banks", banks_industry)
    
    map.put(market_data, "Financial", finance_sector)

if barstate.isfirst
    init_market_structure()

// Function to update nested data
update_nested_data(sector, industry, symbol, value) =>
    if map.contains(market_data, sector)
        sector_data = map.get(market_data, sector)
        
        if map.contains(sector_data, industry)
            industry_data = map.get(sector_data, industry)
            
            if map.contains(industry_data, symbol)
                symbol_array = map.get(industry_data, symbol)
                array.push(symbol_array, value)
                
                # Maintain array size
                if array.size(symbol_array) > 50
                    array.shift(symbol_array)

// Function to get nested data
get_nested_data(sector, industry, symbol) =>
    if map.contains(market_data, sector)
        sector_data = map.get(market_data, sector)
        
        if map.contains(sector_data, industry)
            industry_data = map.get(sector_data, industry)
            
            if map.contains(industry_data, symbol)
                map.get(industry_data, symbol)
            else
                array.new<float>()
        else
            array.new<float>()
    else
        array.new<float>()

// Update data for AAPL
aapl_return = request.security("AAPL", timeframe.period, ta.change(close) / close[1])
if not na(aapl_return)
    update_nested_data("Technology", "Hardware", "AAPL", aapl_return)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               MULTI-LEVEL AGGREGATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Calculate aggregated statistics at different levels
calculate_sector_performance(sector) =>
    if map.contains(market_data, sector)
        sector_data = map.get(market_data, sector)
        total_return = 0.0
        symbol_count = 0
        
        # Iterate through industries
        industry_keys = map.keys(sector_data)
        for i = 0 to array.size(industry_keys) - 1
            industry_key = array.get(industry_keys, i)
            industry_data = map.get(sector_data, industry_key)
            
            # Iterate through symbols
            symbol_keys = map.keys(industry_data)
            for j = 0 to array.size(symbol_keys) - 1
                symbol_key = array.get(symbol_keys, j)
                symbol_array = map.get(industry_data, symbol_key)
                
                if array.size(symbol_array) > 0
                    latest_return = array.get(symbol_array, array.size(symbol_array) - 1)
                    if not na(latest_return)
                        total_return += latest_return
                        symbol_count += 1
        
        symbol_count > 0 ? total_return / symbol_count : na
    else
        na

// Calculate industry performance
calculate_industry_performance(sector, industry) =>
    if map.contains(market_data, sector)
        sector_data = map.get(market_data, sector)
        
        if map.contains(sector_data, industry)
            industry_data = map.get(sector_data, industry)
            total_return = 0.0
            symbol_count = 0
            
            symbol_keys = map.keys(industry_data)
            for i = 0 to array.size(symbol_keys) - 1
                symbol_key = array.get(symbol_keys, i)
                symbol_array = map.get(industry_data, symbol_key)
                
                if array.size(symbol_array) > 0
                    latest_return = array.get(symbol_array, array.size(symbol_array) - 1)
                    if not na(latest_return)
                        total_return += latest_return
                        symbol_count += 1
            
            symbol_count > 0 ? total_return / symbol_count : na
        else
            na
    else
        na

// Get performance metrics
tech_performance = calculate_sector_performance("Technology")
hardware_performance = calculate_industry_performance("Technology", "Hardware")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                ORDER BOOK SIMULATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Nested structure for order book: Side -> Price Level -> Orders
var order_book = map.new<string, map<float, array<map<string, float>>>>()

// Initialize order book
init_order_book() =>
    bid_side = map.new<float, array<map<string, float>>>()
    ask_side = map.new<float, array<map<string, float>>>()
    
    map.put(order_book, "bids", bid_side)
    map.put(order_book, "asks", ask_side)

if barstate.isfirst
    init_order_book()

// Add order to book
add_order_to_book(side, price, quantity, order_id) =>
    if map.contains(order_book, side)
        side_data = map.get(order_book, side)
        
        # Get or create price level
        price_level_orders = map.contains(side_data, price) ? 
                            map.get(side_data, price) : 
                            array.new<map<string, float>>()
        
        # Create order
        order = map.new<string, float>()
        map.put(order, "quantity", quantity)
        map.put(order, "id", order_id)
        map.put(order, "timestamp", time)
        
        # Add order to price level
        array.push(price_level_orders, order)
        map.put(side_data, price, price_level_orders)

// Simulate order book updates
if bar_index % 10 == 0
    # Add some sample orders
    add_order_to_book("bids", close * 0.999, 100, bar_index * 1000)
    add_order_to_book("asks", close * 1.001, 150, bar_index * 1000 + 1)

plot(tech_performance * 100, "Tech Sector %", color.blue)
plot(hardware_performance * 100, "Hardware Industry %", color.green)
```

---

## Collection Performance

### Performance Optimization Techniques
```pinescript
//@version=6
indicator("Collection Performance", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PERFORMANCE BENCHMARKING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Benchmark different collection operations
var performance_metrics = map.new<string, array<float>>()

// Initialize performance tracking
init_performance_tracking() =>
    operations = array.from("array_ops", "matrix_ops", "map_ops", "nested_ops")
    for i = 0 to array.size(operations) - 1
        operation = array.get(operations, i)
        map.put(performance_metrics, operation, array.new<float>())

if barstate.isfirst
    init_performance_tracking()

// Performance measurement wrapper
measure_performance(operation_name, operation_func) =>
    start_time = timenow
    result = operation_func
    end_time = timenow
    
    execution_time = end_time - start_time
    
    if map.contains(performance_metrics, operation_name)
        metrics_array = map.get(performance_metrics, operation_name)
        array.push(metrics_array, execution_time)
        
        # Keep only last 20 measurements
        if array.size(metrics_array) > 20
            array.shift(metrics_array)
    
    result

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                EFFICIENT ARRAY OPERATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Pre-allocated arrays for better performance
var large_array = array.new<float>()
var sorted_array = array.new<float>()

// Efficient array initialization
efficient_array_init(size, initial_value = 0.0) =>
    result = array.new<float>()
    for i = 0 to size - 1
        array.push(result, initial_value)
    result

// Batch array operations
batch_array_operations() =>
    # Clear and rebuild instead of individual operations
    array.clear(large_array)
    
    # Batch insert data
    for i = 0 to 99
        array.push(large_array, close + math.random() * 10)
    
    # Use built-in functions when possible
    avg_value = array.avg(large_array)
    max_value = array.max(large_array)
    min_value = array.min(large_array)
    
    [avg_value, max_value, min_value]

// Efficient sorting with pre-allocated space
efficient_sort() =>
    # Copy to pre-allocated array instead of creating new
    array.clear(sorted_array)
    for i = 0 to array.size(large_array) - 1
        array.push(sorted_array, array.get(large_array, i))
    
    array.sort(sorted_array, order.ascending)
    sorted_array

// Measure array operations
array_result = measure_performance("array_ops", batch_array_operations())

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                MATRIX PERFORMANCE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var performance_matrix = matrix.new<float>()

// Efficient matrix operations
efficient_matrix_ops() =>
    rows = 50
    cols = 10
    
    # Initialize matrix once
    if matrix.rows(performance_matrix) != rows or matrix.columns(performance_matrix) != cols
        performance_matrix := matrix.new<float>(rows, cols, 0.0)
    
    # Batch matrix updates
    for row = 0 to rows - 1
        for col = 0 to cols - 1
            value = (row + col) * close / 1000
            matrix.set(performance_matrix, row, col, value)
    
    # Use matrix functions for calculations
    matrix.sum(performance_matrix)

matrix_result = measure_performance("matrix_ops", efficient_matrix_ops())

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 MAP PERFORMANCE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var performance_map = map.new<string, float>()

// Efficient map operations
efficient_map_ops() =>
    # Batch map operations
    keys = array.from("key1", "key2", "key3", "key4", "key5")
    
    for i = 0 to array.size(keys) - 1
        key = array.get(keys, i)
        value = close * (i + 1)
        map.put(performance_map, key, value)
    
    # Efficient key iteration
    total = 0.0
    map_keys = map.keys(performance_map)
    for i = 0 to array.size(map_keys) - 1
        key = array.get(map_keys, i)
        total += map.get(performance_map, key)
    
    total

map_result = measure_performance("map_ops", efficient_map_ops())

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PERFORMANCE ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Get average performance metrics
get_avg_performance(operation_name) =>
    if map.contains(performance_metrics, operation_name)
        metrics_array = map.get(performance_metrics, operation_name)
        array.size(metrics_array) > 0 ? array.avg(metrics_array) : na
    else
        na

// Performance comparison
array_avg_time = get_avg_performance("array_ops")
matrix_avg_time = get_avg_performance("matrix_ops")
map_avg_time = get_avg_performance("map_ops")

// Plot performance metrics (normalized)
plot(array_avg_time, "Array Ops Time", color.blue)
plot(matrix_avg_time, "Matrix Ops Time", color.green)
plot(map_avg_time, "Map Ops Time", color.red)
```

---

## Memory Management

### Efficient Memory Usage
```pinescript
//@version=6
indicator("Memory Management", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              MEMORY POOL MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Object pool for arrays to reduce allocation/deallocation
var array_pool = array.new<array<float>>()
var pool_size = 10

// Initialize array pool
init_array_pool() =>
    for i = 0 to pool_size - 1
        pooled_array = array.new<float>()
        array.push(array_pool, pooled_array)

if barstate.isfirst
    init_array_pool()

// Get array from pool
get_pooled_array() =>
    if array.size(array_pool) > 0
        array.pop(array_pool)
    else
        array.new<float>()  # Fallback if pool is empty

// Return array to pool
return_to_pool(arr) =>
    array.clear(arr)  # Clear contents
    if array.size(array_pool) < pool_size
        array.push(array_pool, arr)

// Example usage of pooled arrays
temp_array = get_pooled_array()
for i = 0 to 19
    array.push(temp_array, close + i)

result = array.avg(temp_array)
return_to_pool(temp_array)  # Return to pool when done

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               CIRCULAR BUFFERS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Efficient circular buffer implementation
var circular_buffer = array.new<float>()
var buffer_head = 0
buffer_capacity = 100

// Initialize circular buffer
init_circular_buffer(capacity) =>
    array.clear(circular_buffer)
    for i = 0 to capacity - 1
        array.push(circular_buffer, na)
    buffer_head := 0

if barstate.isfirst
    init_circular_buffer(buffer_capacity)

// Add to circular buffer
add_to_circular_buffer(value) =>
    array.set(circular_buffer, buffer_head, value)
    buffer_head := (buffer_head + 1) % buffer_capacity

// Get from circular buffer (relative to head)
get_from_circular_buffer(offset) =>
    if offset >= 0 and offset < buffer_capacity
        index = (buffer_head - 1 - offset + buffer_capacity) % buffer_capacity
        array.get(circular_buffer, index)
    else
        na

// Use circular buffer
add_to_circular_buffer(close)
recent_close = get_from_circular_buffer(0)  # Most recent
old_close = get_from_circular_buffer(10)    # 10 bars ago

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               MEMORY USAGE TRACKING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Approximate memory usage tracking
var memory_stats = map.new<string, int>()

// Track collection sizes
track_memory_usage() =>
    # Array memory (approximate)
    array_count = 5  # Number of main arrays
    avg_array_size = 100
    array_memory = array_count * avg_array_size * 8  # 8 bytes per float
    
    # Map memory (approximate)
    map_count = 3
    avg_map_entries = 50
    map_memory = map_count * avg_map_entries * 32  # Estimated overhead
    
    # Matrix memory (approximate)
    matrix_memory = 50 * 10 * 8  # rows * cols * bytes per element
    
    map.put(memory_stats, "arrays", array_memory)
    map.put(memory_stats, "maps", map_memory)
    map.put(memory_stats, "matrices", matrix_memory)
    
    array_memory + map_memory + matrix_memory

total_memory = track_memory_usage()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               CLEANUP STRATEGIES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Periodic cleanup to prevent memory leaks
var cleanup_counter = 0
cleanup_interval = 100

# Cleanup function
perform_cleanup() =>
    # Clear temporary arrays
    if array.size(array_pool) > pool_size
        for i = pool_size to array.size(array_pool) - 1
            array.pop(array_pool)
    
    # Clean up old map entries
    # (Implementation depends on specific map usage)
    
    # Reset counters
    cleanup_counter := 0

# Periodic cleanup
cleanup_counter += 1
if cleanup_counter >= cleanup_interval
    perform_cleanup()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              LAZY INITIALIZATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Lazy initialization to save memory
var lazy_arrays = map.new<string, array<float>>()

// Get or create array lazily
get_or_create_array(array_name) =>
    if map.contains(lazy_arrays, array_name)
        map.get(lazy_arrays, array_name)
    else
        new_array = array.new<float>()
        map.put(lazy_arrays, array_name, new_array)
        new_array

# Example usage
price_array = get_or_create_array("prices")
volume_array = get_or_create_array("volumes")

array.push(price_array, close)
array.push(volume_array, volume)

# Only create arrays when needed
rsi_array = bar_index > 100 ? get_or_create_array("rsi") : na

plot(total_memory / 1024, "Memory Usage (KB)", color.blue)
plot(array.size(circular_buffer), "Circular Buffer Size", color.green)
```

---

## Sorting and Searching

### Advanced Sorting Algorithms
```pinescript
//@version=6
indicator("Advanced Sorting and Searching", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               CUSTOM SORTING ALGORITHMS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Quick sort implementation for Pine Script
quick_sort(arr, low, high) =>
    if low < high
        pi = partition(arr, low, high)
        quick_sort(arr, low, pi - 1)
        quick_sort(arr, pi + 1, high)

partition(arr, low, high) =>
    pivot = array.get(arr, high)
    i = low - 1
    
    for j = low to high - 1
        if array.get(arr, j) <= pivot
            i += 1
            # Swap elements
            temp = array.get(arr, i)
            array.set(arr, i, array.get(arr, j))
            array.set(arr, j, temp)
    
    # Place pivot in correct position
    temp = array.get(arr, i + 1)
    array.set(arr, i + 1, array.get(arr, high))
    array.set(arr, high, temp)
    
    i + 1

// Merge sort implementation
merge_sort(arr, left, right) =>
    if left < right
        mid = math.floor((left + right) / 2)
        merge_sort(arr, left, mid)
        merge_sort(arr, mid + 1, right)
        merge(arr, left, mid, right)

merge(arr, left, mid, right) =>
    # Create temporary arrays
    left_arr = array.new<float>()
    right_arr = array.new<float>()
    
    # Copy data to temp arrays
    for i = left to mid
        array.push(left_arr, array.get(arr, i))
    
    for j = mid + 1 to right
        array.push(right_arr, array.get(arr, j))
    
    # Merge the temp arrays back
    i = 0
    j = 0
    k = left
    
    while i < array.size(left_arr) and j < array.size(right_arr)
        if array.get(left_arr, i) <= array.get(right_arr, j)
            array.set(arr, k, array.get(left_arr, i))
            i += 1
        else
            array.set(arr, k, array.get(right_arr, j))
            j += 1
        k += 1
    
    # Copy remaining elements
    while i < array.size(left_arr)
        array.set(arr, k, array.get(left_arr, i))
        i += 1
        k += 1
    
    while j < array.size(right_arr)
        array.set(arr, k, array.get(right_arr, j))
        j += 1
        k += 1

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               BINARY SEARCH
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Binary search in sorted array
binary_search(sorted_arr, target) =>
    left = 0
    right = array.size(sorted_arr) - 1
    
    while left <= right
        mid = math.floor((left + right) / 2)
        mid_value = array.get(sorted_arr, mid)
        
        if mid_value == target
            mid  # Found target, return index
        else if mid_value < target
            left := mid + 1
        else
            right := mid - 1
    
    -1  # Target not found

// Binary search for insertion point
binary_search_insertion_point(sorted_arr, value) =>
    left = 0
    right = array.size(sorted_arr)
    
    while left < right
        mid = math.floor((left + right) / 2)
        if array.get(sorted_arr, mid) < value
            left := mid + 1
        else
            right := mid
    
    left

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               SEARCH PATTERNS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Find patterns in price data
var price_data = array.new<float>()

# Maintain price history
array.push(price_data, close)
if array.size(price_data) > 200
    array.shift(price_data)

// Pattern matching using correlation
find_similar_patterns(pattern_length, similarity_threshold = 0.8) =>
    if array.size(price_data) < pattern_length * 2
        array.new<int>()
    else
        # Current pattern (last pattern_length bars)
        current_pattern = array.new<float>()
        for i = array.size(price_data) - pattern_length to array.size(price_data) - 1
            array.push(current_pattern, array.get(price_data, i))
        
        # Search for similar patterns
        similar_indices = array.new<int>()
        
        for start_idx = 0 to array.size(price_data) - pattern_length * 2
            # Extract historical pattern
            historical_pattern = array.new<float>()
            for i = start_idx to start_idx + pattern_length - 1
                array.push(historical_pattern, array.get(price_data, i))
            
            # Calculate correlation
            correlation = calculate_pattern_correlation(current_pattern, historical_pattern)
            
            if correlation >= similarity_threshold
                array.push(similar_indices, start_idx)
        
        similar_indices

// Helper function for pattern correlation
calculate_pattern_correlation(pattern1, pattern2) =>
    if array.size(pattern1) != array.size(pattern2) or array.size(pattern1) < 2
        0.0
    else
        # Calculate means
        mean1 = array.avg(pattern1)
        mean2 = array.avg(pattern2)
        
        # Calculate correlation
        numerator = 0.0
        sum_sq1 = 0.0
        sum_sq2 = 0.0
        
        for i = 0 to array.size(pattern1) - 1
            diff1 = array.get(pattern1, i) - mean1
            diff2 = array.get(pattern2, i) - mean2
            
            numerator += diff1 * diff2
            sum_sq1 += diff1 * diff1
            sum_sq2 += diff2 * diff2
        
        denominator = math.sqrt(sum_sq1 * sum_sq2)
        denominator == 0 ? 0.0 : numerator / denominator

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               KMP STRING MATCHING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Knuth-Morris-Pratt algorithm for pattern matching in sequences
// Simplified for numeric patterns
kmp_search(text_array, pattern_array) =>
    if array.size(pattern_array) == 0 or array.size(text_array) < array.size(pattern_array)
        array.new<int>()
    else
        # Build failure function
        failure = build_failure_function(pattern_array)
        
        # Search for pattern
        matches = array.new<int>()
        i = 0  # text index
        j = 0  # pattern index
        
        while i < array.size(text_array)
            if arrays_equal_at_index(text_array, i, pattern_array, j)
                i += 1
                j += 1
                
                if j == array.size(pattern_array)
                    # Found complete match
                    array.push(matches, i - j)
                    j := array.get(failure, j - 1)
            else
                if j != 0
                    j := array.get(failure, j - 1)
                else
                    i += 1
        
        matches

# Helper function for KMP
build_failure_function(pattern) =>
    failure = array.new<int>()
    array.push(failure, 0)
    
    i = 1
    j = 0
    
    while i < array.size(pattern)
        if arrays_equal_at_index(pattern, i, pattern, j)
            j += 1
            array.push(failure, j)
            i += 1
        else
            if j != 0
                j := array.get(failure, j - 1)
            else
                array.push(failure, 0)
                i += 1
    
    failure

arrays_equal_at_index(arr1, idx1, arr2, idx2) =>
    if idx1 >= array.size(arr1) or idx2 >= array.size(arr2)
        false
    else
        math.abs(array.get(arr1, idx1) - array.get(arr2, idx2)) < 0.0001

// Example usage
pattern_matches = find_similar_patterns(10, 0.85)
plot(array.size(pattern_matches), "Similar Patterns Found", color.blue)
```

---

## Statistical Operations

### Advanced Statistical Functions
```pinescript
//@version=6
indicator("Statistical Operations on Collections", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               DESCRIPTIVE STATISTICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Comprehensive statistical analysis
var data_series = array.new<float>()

# Maintain data series
array.push(data_series, close)
if array.size(data_series) > 100
    array.shift(data_series)

// Calculate various statistical measures
calculate_statistics(data_array) =>
    if array.size(data_array) < 2
        [na, na, na, na, na, na, na, na]
    else
        # Basic measures
        mean_val = array.avg(data_array)
        median_val = array.median(data_array)
        std_dev = array.stdev(data_array)
        variance = array.variance(data_array)
        
        # Advanced measures
        skewness_val = calculate_skewness(data_array)
        kurtosis_val = calculate_kurtosis(data_array)
        range_val = array.max(data_array) - array.min(data_array)
        iqr_val = calculate_iqr(data_array)
        
        [mean_val, median_val, std_dev, variance, skewness_val, kurtosis_val, range_val, iqr_val]

// Skewness calculation
calculate_skewness(data_array) =>
    size = array.size(data_array)
    if size < 3
        na
    else
        mean_val = array.avg(data_array)
        
        # Calculate third moment
        sum_cubed_diff = 0.0
        sum_squared_diff = 0.0
        
        for i = 0 to size - 1
            diff = array.get(data_array, i) - mean_val
            sum_squared_diff += diff * diff
            sum_cubed_diff += diff * diff * diff
        
        variance = sum_squared_diff / (size - 1)
        std_dev = math.sqrt(variance)
        
        if std_dev == 0
            na
        else
            skew = (sum_cubed_diff / size) / math.pow(std_dev, 3)
            # Adjusted for sample skewness
            skew * size / ((size - 1) * (size - 2))

// Kurtosis calculation (excess kurtosis)
calculate_kurtosis(data_array) =>
    size = array.size(data_array)
    if size < 4
        na
    else
        mean_val = array.avg(data_array)
        
        # Calculate fourth moment
        sum_fourth_diff = 0.0
        sum_squared_diff = 0.0
        
        for i = 0 to size - 1
            diff = array.get(data_array, i) - mean_val
            squared_diff = diff * diff
            sum_squared_diff += squared_diff
            sum_fourth_diff += squared_diff * squared_diff
        
        variance = sum_squared_diff / size
        
        if variance == 0
            na
        else
            kurt = (sum_fourth_diff / size) / math.pow(variance, 2)
            # Excess kurtosis (subtract 3 for normal distribution)
            kurt - 3.0

// Interquartile Range (IQR)
calculate_iqr(data_array) =>
    if array.size(data_array) < 4
        na
    else
        sorted_array = array.copy(data_array)
        array.sort(sorted_array)
        
        q1 = calculate_percentile(sorted_array, 25)
        q3 = calculate_percentile(sorted_array, 75)
        
        q3 - q1

// Percentile calculation
calculate_percentile(sorted_array, percentile) =>
    size = array.size(sorted_array)
    if size == 0
        na
    else
        index = (percentile / 100.0) * (size - 1)
        
        if index == math.floor(index)
            array.get(sorted_array, int(index))
        else
            lower_index = int(math.floor(index))
            upper_index = int(math.ceil(index))
            weight = index - math.floor(index)
            
            lower_val = array.get(sorted_array, lower_index)
            upper_val = array.get(sorted_array, upper_index)
            
            lower_val + weight * (upper_val - lower_val)

// Get current statistics
[mean_val, median_val, std_dev, variance, skewness, kurtosis, range_val, iqr] = calculate_statistics(data_series)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               REGRESSION ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Linear regression on arrays
linear_regression(x_array, y_array) =>
    size_x = array.size(x_array)
    size_y = array.size(y_array)
    
    if size_x != size_y or size_x < 2
        [na, na, na]
    else
        # Calculate sums
        sum_x = 0.0
        sum_y = 0.0
        sum_xy = 0.0
        sum_x_squared = 0.0
        
        for i = 0 to size_x - 1
            x = array.get(x_array, i)
            y = array.get(y_array, i)
            
            sum_x += x
            sum_y += y
            sum_xy += x * y
            sum_x_squared += x * x
        
        n = size_x
        
        # Calculate slope and intercept
        denominator = n * sum_x_squared - sum_x * sum_x
        
        if denominator == 0
            [na, na, na]
        else
            slope = (n * sum_xy - sum_x * sum_y) / denominator
            intercept = (sum_y - slope * sum_x) / n
            
            # Calculate R-squared
            y_mean = sum_y / n
            ss_total = 0.0
            ss_residual = 0.0
            
            for i = 0 to size_x - 1
                x = array.get(x_array, i)
                y = array.get(y_array, i)
                y_predicted = slope * x + intercept
                
                ss_total += math.pow(y - y_mean, 2)
                ss_residual += math.pow(y - y_predicted, 2)
            
            r_squared = ss_total == 0 ? na : 1 - (ss_residual / ss_total)
            
            [slope, intercept, r_squared]

// Create x-axis values (time-based)
var x_values = array.new<float>()
array.push(x_values, bar_index)
if array.size(x_values) > 100
    array.shift(x_values)

# Perform regression
[slope, intercept, r_squared] = linear_regression(x_values, data_series)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               HYPOTHESIS TESTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// T-test for comparing two samples
t_test_two_samples(sample1, sample2) =>
    size1 = array.size(sample1)
    size2 = array.size(sample2)
    
    if size1 < 2 or size2 < 2
        [na, na]
    else
        mean1 = array.avg(sample1)
        mean2 = array.avg(sample2)
        var1 = array.variance(sample1)
        var2 = array.variance(sample2)
        
        # Pooled standard error
        pooled_se = math.sqrt((var1 / size1) + (var2 / size2))
        
        if pooled_se == 0
            [na, na]
        else
            # T-statistic
            t_stat = (mean1 - mean2) / pooled_se
            
            # Degrees of freedom (approximation)
            df = size1 + size2 - 2
            
            [t_stat, df]

// Chi-square goodness of fit test
chi_square_test(observed, expected) =>
    if array.size(observed) != array.size(expected) or array.size(observed) < 1
        na
    else
        chi_square = 0.0
        
        for i = 0 to array.size(observed) - 1
            obs = array.get(observed, i)
            exp = array.get(expected, i)
            
            if exp > 0
                chi_square += math.pow(obs - exp, 2) / exp
        
        chi_square

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               TIME SERIES ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Autocorrelation function
calculate_autocorrelation(data_array, lag) =>
    size = array.size(data_array)
    if size < lag + 1 or lag < 0
        na
    else
        mean_val = array.avg(data_array)
        
        # Calculate autocovariance at lag
        numerator = 0.0
        denominator = 0.0
        count = 0
        
        for i = 0 to size - lag - 1
            x_t = array.get(data_array, i) - mean_val
            x_t_lag = array.get(data_array, i + lag) - mean_val
            
            numerator += x_t * x_t_lag
            count += 1
        
        # Calculate variance (lag 0 autocovariance)
        for i = 0 to size - 1
            x_t = array.get(data_array, i) - mean_val
            denominator += x_t * x_t
        
        if denominator == 0 or count == 0
            na
        else
            (numerator / count) / (denominator / size)

# Calculate autocorrelations for different lags
autocorr_1 = calculate_autocorrelation(data_series, 1)
autocorr_5 = calculate_autocorrelation(data_series, 5)
autocorr_10 = calculate_autocorrelation(data_series, 10)

// Plot statistical measures
plot(skewness, "Skewness", color.blue)
plot(kurtosis, "Kurtosis", color.red)
plot(autocorr_1, "Autocorr(1)", color.green)
plot(r_squared, "R-Squared", color.orange)
```

---

## Real-World Applications

### Complete Trading System Using Collections
```pinescript
//@version=6
strategy("Advanced Collections Trading System", overlay=true, max_bars_back=500)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              MULTI-ASSET PORTFOLIO SYSTEM
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Portfolio data structure
var portfolio_data = map.new<string, map<string, array<float>>>()
var correlation_matrix = matrix.new<float>()
var returns_matrix = matrix.new<float>()

// Asset universe
assets = array.from("AAPL", "GOOGL", "MSFT", "AMZN", "TSLA", "SPY", "QQQ")
lookback_period = 252  // One year of trading days

// Initialize portfolio system
init_portfolio_system() =>
    for i = 0 to array.size(assets) - 1
        asset = array.get(assets, i)
        asset_data = map.new<string, array<float>>()
        
        # Create data arrays for each metric
        metrics = array.from("prices", "returns", "volatility", "rsi", "momentum")
        for j = 0 to array.size(metrics) - 1
            metric = array.get(metrics, j)
            map.put(asset_data, metric, array.new<float>())
        
        map.put(portfolio_data, asset, asset_data)
    
    # Initialize matrices
    num_assets = array.size(assets)
    correlation_matrix := matrix.new<float>(num_assets, num_assets, 0.0)
    returns_matrix := matrix.new<float>(lookback_period, num_assets, na)

if barstate.isfirst
    init_portfolio_system()

// Update portfolio data
update_portfolio_data() =>
    for i = 0 to array.size(assets) - 1
        asset = array.get(assets, i)
        
        # Get asset data
        [asset_close, asset_volume] = request.security(asset, timeframe.period, [close, volume])
        
        if not na(asset_close) and map.contains(portfolio_data, asset)
            asset_data = map.get(portfolio_data, asset)
            
            # Calculate metrics
            prices_array = map.get(asset_data, "prices")
            returns_array = map.get(asset_data, "returns")
            
            # Update prices
            array.push(prices_array, asset_close)
            if array.size(prices_array) > lookback_period
                array.shift(prices_array)
            
            # Calculate return
            if array.size(prices_array) >= 2
                prev_price = array.get(prices_array, array.size(prices_array) - 2)
                current_return = (asset_close - prev_price) / prev_price
                
                array.push(returns_array, current_return)
                if array.size(returns_array) > lookback_period
                    array.shift(returns_array)
                
                # Update returns matrix
                update_returns_matrix(i, current_return)
            
            # Calculate other metrics
            if array.size(prices_array) >= 20
                volatility_array = map.get(asset_data, "volatility")
                rsi_array = map.get(asset_data, "rsi")
                momentum_array = map.get(asset_data, "momentum")
                
                # Volatility (20-day rolling)
                recent_returns = array.slice(returns_array, 
                                           math.max(0, array.size(returns_array) - 20), 
                                           array.size(returns_array))
                vol = array.stdev(recent_returns) * math.sqrt(252)  # Annualized
                
                array.push(volatility_array, vol)
                if array.size(volatility_array) > lookback_period
                    array.shift(volatility_array)
                
                # RSI (simplified calculation)
                rsi_val = calculate_rsi_from_prices(prices_array, 14)
                array.push(rsi_array, rsi_val)
                if array.size(rsi_array) > lookback_period
                    array.shift(rsi_array)
                
                # Momentum (20-day)
                if array.size(prices_array) >= 20
                    momentum = (asset_close / array.get(prices_array, array.size(prices_array) - 20) - 1) * 100
                    array.push(momentum_array, momentum)
                    if array.size(momentum_array) > lookback_period
                        array.shift(momentum_array)

# Update returns matrix
update_returns_matrix(asset_index, return_value) =>
    # Shift all rows up
    for row = 0 to matrix.rows(returns_matrix) - 2
        for col = 0 to matrix.columns(returns_matrix) - 1
            next_value = matrix.get(returns_matrix, row + 1, col)
            matrix.set(returns_matrix, row, col, next_value)
    
    # Add new return to last row
    if asset_index < matrix.columns(returns_matrix)
        matrix.set(returns_matrix, matrix.rows(returns_matrix) - 1, asset_index, return_value)

# RSI calculation from price array
calculate_rsi_from_prices(prices_array, period) =>
    if array.size(prices_array) < period + 1
        50.0  # Default neutral RSI
    else
        gains = 0.0
        losses = 0.0
        
        for i = array.size(prices_array) - period to array.size(prices_array) - 1
            if i > 0
                change = array.get(prices_array, i) - array.get(prices_array, i - 1)
                if change > 0
                    gains += change
                else
                    losses += math.abs(change)
        
        avg_gain = gains / period
        avg_loss = losses / period
        
        if avg_loss == 0
            100.0
        else
            rs = avg_gain / avg_loss
            100 - (100 / (1 + rs))

update_portfolio_data()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               CORRELATION ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Update correlation matrix
update_correlation_matrix() =>
    num_assets = array.size(assets)
    
    for i = 0 to num_assets - 1
        for j = 0 to num_assets - 1
            if i == j
                matrix.set(correlation_matrix, i, j, 1.0)
            else
                # Extract returns for both assets
                returns_i = array.new<float>()
                returns_j = array.new<float>()
                
                for row = 0 to matrix.rows(returns_matrix) - 1
                    return_i = matrix.get(returns_matrix, row, i)
                    return_j = matrix.get(returns_matrix, row, j)
                    
                    if not na(return_i) and not na(return_j)
                        array.push(returns_i, return_i)
                        array.push(returns_j, return_j)
                
                # Calculate correlation
                if array.size(returns_i) > 10
                    correlation = calculate_correlation_arrays(returns_i, returns_j)
                    matrix.set(correlation_matrix, i, j, correlation)

calculate_correlation_arrays(arr1, arr2) =>
    if array.size(arr1) != array.size(arr2) or array.size(arr1) < 2
        0.0
    else
        mean1 = array.avg(arr1)
        mean2 = array.avg(arr2)
        
        numerator = 0.0
        sum_sq1 = 0.0
        sum_sq2 = 0.0
        
        for i = 0 to array.size(arr1) - 1
            diff1 = array.get(arr1, i) - mean1
            diff2 = array.get(arr2, i) - mean2
            
            numerator += diff1 * diff2
            sum_sq1 += diff1 * diff1
            sum_sq2 += diff2 * diff2
        
        denominator = math.sqrt(sum_sq1 * sum_sq2)
        denominator == 0 ? 0.0 : numerator / denominator

# Update correlation matrix every 10 bars
if bar_index % 10 == 0
    update_correlation_matrix()

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               PORTFOLIO OPTIMIZATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Simplified portfolio optimization
calculate_portfolio_weights() =>
    weights = array.new<float>()
    num_assets = array.size(assets)
    
    # Simplified equal-risk budgeting approach
    for i = 0 to num_assets - 1
        asset = array.get(assets, i)
        
        if map.contains(portfolio_data, asset)
            asset_data = map.get(portfolio_data, asset)
            volatility_array = map.get(asset_data, "volatility")
            
            # Use inverse volatility weighting
            if array.size(volatility_array) > 0
                vol = array.get(volatility_array, array.size(volatility_array) - 1)
                weight = vol > 0 ? 1.0 / vol : 0.0
                array.push(weights, weight)
            else
                array.push(weights, 1.0 / num_assets)  # Equal weight fallback
        else
            array.push(weights, 0.0)
    
    # Normalize weights to sum to 1
    total_weight = array.sum(weights)
    if total_weight > 0
        for i = 0 to array.size(weights) - 1
            current_weight = array.get(weights, i)
            array.set(weights, i, current_weight / total_weight)
    
    weights

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               TRADING SIGNALS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Generate trading signals based on portfolio analysis
generate_trading_signals() =>
    signals = map.new<string, float>()
    
    for i = 0 to array.size(assets) - 1
        asset = array.get(assets, i)
        
        if map.contains(portfolio_data, asset)
            asset_data = map.get(portfolio_data, asset)
            
            # Get latest metrics
            rsi_array = map.get(asset_data, "rsi")
            momentum_array = map.get(asset_data, "momentum")
            volatility_array = map.get(asset_data, "volatility")
            
            if array.size(rsi_array) > 0 and array.size(momentum_array) > 0
                rsi = array.get(rsi_array, array.size(rsi_array) - 1)
                momentum = array.get(momentum_array, array.size(momentum_array) - 1)
                
                # Simple scoring system
                score = 0.0
                
                # RSI component
                if rsi < 30
                    score += 1.0  # Oversold, bullish
                else if rsi > 70
                    score -= 1.0  # Overbought, bearish
                
                # Momentum component
                if momentum > 5
                    score += 1.0  # Strong positive momentum
                else if momentum < -5
                    score -= 1.0  # Strong negative momentum
                
                map.put(signals, asset, score)
    
    signals

# Generate signals
current_signals = generate_trading_signals()

// Simple strategy execution for SPY
spy_signal = map.contains(current_signals, "SPY") ? map.get(current_signals, "SPY") : 0.0

if spy_signal > 0.5
    strategy.entry("Long", strategy.long)
else if spy_signal < -0.5
    strategy.entry("Short", strategy.short)

# Exit conditions
if strategy.position_size > 0 and spy_signal <= 0
    strategy.close("Long")
else if strategy.position_size < 0 and spy_signal >= 0
    strategy.close("Short")

// Plot signals and metrics
plot(spy_signal, "SPY Signal", color=spy_signal > 0 ? color.green : color.red)

# Display portfolio correlation average
if matrix.rows(correlation_matrix) > 0 and matrix.columns(correlation_matrix) > 0
    avg_correlation = matrix.avg(correlation_matrix)
    plot(avg_correlation, "Avg Correlation", color.blue)
```

This comprehensive guide demonstrates the power of Pine Script v6 collections for sophisticated financial analysis, from basic array operations to complex multi-asset portfolio management systems. The examples show practical implementations that can be adapted for real trading applications.