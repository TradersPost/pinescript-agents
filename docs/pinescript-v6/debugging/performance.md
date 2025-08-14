# Pine Script Performance Optimization

This guide covers comprehensive performance optimization techniques for Pine Script v6, helping you create efficient indicators and strategies that run smoothly on TradingView.

## Table of Contents
- [Script Optimization Fundamentals](#script-optimization-fundamentals)
- [Reducing security() Calls](#reducing-security-calls)
- [Efficient Array Operations](#efficient-array-operations)
- [Minimizing Drawing Objects](#minimizing-drawing-objects)
- [Historical Buffer Management](#historical-buffer-management)
- [Calculation Optimization](#calculation-optimization)
- [Memory Usage Patterns](#memory-usage-patterns)
- [Load Time Optimization](#load-time-optimization)
- [Best Practices for Large Datasets](#best-practices-for-large-datasets)

## Script Optimization Fundamentals

### Performance Principles

1. **Minimize Calculations**: Only calculate what you need, when you need it
2. **Cache Results**: Store expensive calculations in variables
3. **Reduce Function Calls**: Especially built-in functions with complex logic
4. **Optimize Loops**: Use vectorized operations when possible
5. **Manage Memory**: Clean up arrays and matrices regularly

### Performance Measurement

```pinescript
//@version=6
indicator("Performance Measurement", overlay=true)

// Basic performance tracking
var int total_calculations = 0
var float total_time = 0.0

measure_performance(calculation_name, calculation_func) =>
    start_time = time_close
    result = calculation_func
    end_time = time_close
    
    total_calculations += 1
    total_time += (end_time - start_time)
    
    if barstate.islast
        avg_time = total_time / total_calculations
        log.info("Performance - {0}: Avg time per calculation: {1}ms", 
                calculation_name, avg_time)
    
    result

// Example usage
efficient_rsi() =>
    ta.rsi(close, 14)

rsi_value = measure_performance("RSI", efficient_rsi)
```

### Script Profiling Setup

```pinescript
//@version=6
indicator("Script Profiler", overlay=false)

enable_profiling = input.bool(false, "Enable Profiling")

// Profiling data structure
type PerformanceMetric
    string name
    int calls
    float total_time
    float max_time
    float min_time

var array<PerformanceMetric> metrics = array.new<PerformanceMetric>()

profile(name, func) =>
    if not enable_profiling
        func
    else
        start = time_close
        result = func
        elapsed = time_close - start
        
        // Update metrics
        metric_found = false
        for i = 0 to array.size(metrics) - 1
            metric = array.get(metrics, i)
            if PerformanceMetric.name(metric) == name
                new_calls = PerformanceMetric.calls(metric) + 1
                new_total = PerformanceMetric.total_time(metric) + elapsed
                new_max = math.max(PerformanceMetric.max_time(metric), elapsed)
                new_min = math.min(PerformanceMetric.min_time(metric), elapsed)
                
                updated_metric = PerformanceMetric.new(name, new_calls, new_total, new_max, new_min)
                array.set(metrics, i, updated_metric)
                metric_found := true
                break
        
        if not metric_found
            new_metric = PerformanceMetric.new(name, 1, elapsed, elapsed, elapsed)
            array.push(metrics, new_metric)
        
        result
```

## Reducing security() Calls

The `security()` function is one of the most expensive operations in Pine Script. Optimize its usage:

### Inefficient Pattern

```pinescript
// BAD: Multiple security() calls for same symbol/timeframe
higher_tf = "1D"
daily_open = request.security(syminfo.tickerid, higher_tf, open)
daily_high = request.security(syminfo.tickerid, higher_tf, high)
daily_low = request.security(syminfo.tickerid, higher_tf, low)
daily_close = request.security(syminfo.tickerid, higher_tf, close)
daily_volume = request.security(syminfo.tickerid, higher_tf, volume)
```

### Optimized Pattern

```pinescript
//@version=6
indicator("Optimized Security Calls", overlay=true)

// GOOD: Single security() call with tuple
higher_tf = input.timeframe("1D", "Higher Timeframe")

// Combine multiple values in one security() call
[daily_o, daily_h, daily_l, daily_c, daily_v] = request.security(
    syminfo.tickerid, 
    higher_tf, 
    [open, high, low, close, volume],
    lookahead=barmerge.lookahead_off
)

// Use the values
plot(daily_c, "Daily Close", color.blue, linewidth=2)
plot(daily_o, "Daily Open", color.orange, linewidth=2)

// Cache expensive security() calculations
var float cached_weekly_close = na
var int last_week_time = na

current_week = math.floor(time / (7 * 24 * 60 * 60 * 1000))

if current_week != last_week_time
    cached_weekly_close := request.security(syminfo.tickerid, "1W", close[1])
    last_week_time := current_week

plot(cached_weekly_close, "Cached Weekly Close", color.red)
```

### Security() Best Practices

```pinescript
//@version=6
indicator("Security Best Practices", overlay=true)

// 1. Limit security() calls per script (max 40)
// 2. Use barmerge.lookahead_off to prevent repainting
// 3. Cache results when possible
// 4. Combine multiple requests

higher_timeframe = input.timeframe("4H", "Higher Timeframe")

// Efficient multi-indicator security call
[htf_rsi, htf_macd, htf_bb_upper, htf_bb_lower] = request.security(
    syminfo.tickerid,
    higher_timeframe,
    [
        ta.rsi(close, 14),
        ta.macd(close, 12, 26, 9)[0],
        ta.bb(close, 20, 2)[0],
        ta.bb(close, 20, 2)[2]
    ],
    lookahead=barmerge.lookahead_off
)

// Use conditional security() calls
enable_weekly_data = input.bool(false, "Enable Weekly Data")
weekly_data = enable_weekly_data ? 
    request.security(syminfo.tickerid, "1W", close) : na

plot(htf_rsi, "HTF RSI", color.blue)
plot(weekly_data, "Weekly Close", color.red)
```

## Efficient Array Operations

Arrays can become performance bottlenecks if not managed properly:

### Array Size Management

```pinescript
//@version=6
indicator("Efficient Arrays", overlay=false)

// Limit array sizes to prevent memory issues
MAX_ARRAY_SIZE = 500
price_history = array.new<float>(0)

// Efficient array population
if array.size(price_history) >= MAX_ARRAY_SIZE
    array.shift(price_history)  // Remove oldest element
array.push(price_history, close)  // Add newest element

// Batch array operations instead of individual operations
update_array_efficiently(arr, new_values) =>
    // Clear and rebuild vs individual updates for large changes
    if array.size(new_values) > array.size(arr) * 0.5
        array.clear(arr)
        for i = 0 to array.size(new_values) - 1
            array.push(arr, array.get(new_values, i))
    else
        // Individual updates for small changes
        for i = 0 to array.size(new_values) - 1
            if i < array.size(arr)
                array.set(arr, i, array.get(new_values, i))
            else
                array.push(arr, array.get(new_values, i))
```

### Optimized Array Calculations

```pinescript
//@version=6
indicator("Array Calculation Optimization", overlay=false)

lookback_period = input.int(50, "Lookback Period", minval=10, maxval=500)

// Pre-allocate arrays with known size
var prices = array.new<float>(0)
var volumes = array.new<float>(0)

// Efficient array maintenance
maintain_array(arr, value, max_size) =>
    if array.size(arr) >= max_size
        array.shift(arr)
    array.push(arr, value)

maintain_array(prices, close, lookback_period)
maintain_array(volumes, volume, lookback_period)

// Cache expensive array calculations
var float cached_price_avg = na
var float cached_volume_avg = na
var int last_calc_bar = na

// Only recalculate when array changes
if bar_index != last_calc_bar and array.size(prices) > 0
    cached_price_avg := array.avg(prices)
    cached_volume_avg := array.avg(volumes)
    last_calc_bar := bar_index

plot(cached_price_avg, "Price Average", color.blue)
plot(cached_volume_avg, "Volume Average", color.red)

// Use array slicing for efficiency
get_recent_values(arr, count) =>
    size = array.size(arr)
    if size == 0 or count <= 0
        array.new<float>()
    else
        start_index = math.max(0, size - count)
        array.slice(arr, start_index, size)

recent_prices = get_recent_values(prices, 10)
```

## Minimizing Drawing Objects

Drawing objects (lines, labels, boxes) can impact performance:

### Drawing Object Limits

```pinescript
//@version=6
indicator("Optimized Drawing Objects", overlay=true, 
          max_lines_count=100, max_labels_count=50, max_boxes_count=25)

// Track drawing objects to stay within limits
var line[] trend_lines = array.new<line>()
var label[] price_labels = array.new<label>()
var box[] support_boxes = array.new<box>()

// Efficient drawing object management
manage_drawing_objects(arr, new_object, max_count) =>
    if array.size(arr) >= max_count
        old_object = array.shift(arr)
        // Delete the old object to free memory
        switch
            old_object is line => line.delete(old_object)
            old_object is label => label.delete(old_object)
            old_object is box => box.delete(old_object)
    
    array.push(arr, new_object)

// Create drawing objects conditionally
draw_support_level = input.bool(true, "Draw Support Levels")
support_sensitivity = input.int(5, "Support Detection Sensitivity")

if draw_support_level and bar_index % support_sensitivity == 0
    new_line = line.new(bar_index - 20, low, bar_index, low, 
                       color=color.green, width=1)
    manage_drawing_objects(trend_lines, new_line, 50)

// Batch delete drawing objects
clear_all_drawings() =>
    // Clear lines
    for i = 0 to array.size(trend_lines) - 1
        line.delete(array.get(trend_lines, i))
    array.clear(trend_lines)
    
    // Clear labels
    for i = 0 to array.size(price_labels) - 1
        label.delete(array.get(price_labels, i))
    array.clear(price_labels)

// Clear drawings on user input
if input.bool(false, "Clear All Drawings")
    clear_all_drawings()
```

### Conditional Drawing

```pinescript
//@version=6
indicator("Conditional Drawing Optimization", overlay=true)

show_detailed_analysis = input.bool(false, "Show Detailed Analysis")
drawing_frequency = input.int(10, "Drawing Frequency (bars)")

// Only draw when necessary
should_draw = show_detailed_analysis and (bar_index % drawing_frequency == 0)

// Efficient conditional drawing
if should_draw and ta.crossover(ta.rsi(close, 14), 30)
    label.new(bar_index, low * 0.98, "Oversold", 
              style=label.style_label_up, color=color.green, size=size.small)

// Use display parameter to control visibility
rsi_value = ta.rsi(close, 14)
plot(rsi_value, "RSI", color.blue, 
     display = show_detailed_analysis ? display.all : display.none)

// Optimize line drawing with fewer points
draw_trend_line = input.bool(false, "Draw Trend Line")
trend_line_points = input.int(20, "Trend Line Points", minval=5, maxval=100)

if draw_trend_line and bar_index % trend_line_points == 0
    // Use fewer points for trend line calculation
    highest_point = ta.highest(high, trend_line_points)
    lowest_point = ta.lowest(low, trend_line_points)
    
    line.new(bar_index - trend_line_points, lowest_point, 
             bar_index, highest_point, color=color.blue)
```

## Historical Buffer Management

Manage historical data efficiently:

```pinescript
//@version=6
indicator("Historical Buffer Management", overlay=false)

// Configure buffer sizes based on needs
SHORT_BUFFER = 50
MEDIUM_BUFFER = 200
LONG_BUFFER = 500

// Use different buffer sizes for different purposes
var short_term_prices = array.new<float>(0)    // For quick calculations
var medium_term_prices = array.new<float>(0)   // For trend analysis
var long_term_prices = array.new<float>(0)     // For statistical analysis

// Efficient buffer management function
manage_buffer(buffer, value, max_size) =>
    current_size = array.size(buffer)
    
    if current_size >= max_size
        // Remove multiple elements at once for efficiency
        remove_count = math.max(1, math.floor(max_size * 0.1))
        for i = 1 to remove_count
            array.shift(buffer)
    
    array.push(buffer, value)

// Update buffers with different frequencies
if barstate.isconfirmed
    manage_buffer(short_term_prices, close, SHORT_BUFFER)
    
    // Update medium-term buffer every 5 bars
    if bar_index % 5 == 0
        manage_buffer(medium_term_prices, close, MEDIUM_BUFFER)
    
    // Update long-term buffer every 20 bars
    if bar_index % 20 == 0
        manage_buffer(long_term_prices, close, LONG_BUFFER)

// Memory-efficient calculations
calculate_statistics(buffer) =>
    size = array.size(buffer)
    if size == 0
        [na, na, na]
    else if size < 10
        // Skip calculations for small datasets
        [array.avg(buffer), na, na]
    else
        avg = array.avg(buffer)
        std_dev = array.stdev(buffer)
        [avg, std_dev, array.max(buffer) - array.min(buffer)]

[short_avg, short_std, short_range] = calculate_statistics(short_term_prices)
plot(short_avg, "Short Term Average", color.blue)
```

## Calculation Optimization

Optimize mathematical calculations and algorithm efficiency:

### Caching Expensive Calculations

```pinescript
//@version=6
indicator("Calculation Optimization", overlay=false)

length = input.int(20, "Calculation Length")

// Cache expensive calculations
var float cached_sma = na
var float cached_ema = na
var float cached_rsi = na
var int last_calculation_bar = na

// Only recalculate when necessary
if bar_index != last_calculation_bar
    cached_sma := ta.sma(close, length)
    cached_ema := ta.ema(close, length)
    cached_rsi := ta.rsi(close, 14)
    last_calculation_bar := bar_index

// Use cached values multiple times
sma_distance = math.abs(close - cached_sma)
ema_distance = math.abs(close - cached_ema)
combined_signal = cached_rsi > 50 and close > cached_ema

plot(cached_sma, "SMA", color.blue)
plot(cached_ema, "EMA", color.red)
plot(cached_rsi, "RSI", color.orange)
```

### Vectorized Operations

```pinescript
//@version=6
indicator("Vectorized Operations", overlay=false)

// Use Pine Script's built-in vectorized functions
calculate_moving_averages_efficient(src, lengths) =>
    // Single function call for multiple averages
    sma_5 = ta.sma(src, 5)
    sma_10 = ta.sma(src, 10)
    sma_20 = ta.sma(src, 20)
    sma_50 = ta.sma(src, 50)
    
    [sma_5, sma_10, sma_20, sma_50]

[ma5, ma10, ma20, ma50] = calculate_moving_averages_efficient(close, [5, 10, 20, 50])

// Efficient conditional calculations
calculate_conditionally(condition, expensive_calc) =>
    condition ? expensive_calc : na

// Only calculate when needed
complex_indicator = calculate_conditionally(
    ta.rsi(close, 14) > 70,
    ta.macd(close, 12, 26, 9)[0]
)

plot(ma5, "MA5", color.blue)
plot(ma10, "MA10", color.red)
plot(complex_indicator, "Complex Indicator", color.orange)
```

### Loop Optimization

```pinescript
//@version=6
indicator("Loop Optimization", overlay=false)

// Optimize loops by reducing iterations
optimize_loop_example() =>
    var float result = 0.0
    
    // BAD: Loop every bar
    // for i = 1 to 100
    //     result += math.sin(i * close)
    
    // GOOD: Loop only when necessary
    if bar_index % 10 == 0  // Every 10 bars
        result := 0.0
        for i = 1 to 20  // Fewer iterations
            result += math.sin(i * close)
    
    result

optimized_result = optimize_loop_example()

// Use early exit conditions in loops
find_pattern_efficiently(arr, pattern_value) =>
    var int found_index = -1
    
    if array.size(arr) > 0
        for i = 0 to math.min(array.size(arr) - 1, 50)  // Limit search
            if math.abs(array.get(arr, i) - pattern_value) < 0.001
                found_index := i
                break  // Early exit
    
    found_index

plot(optimized_result, "Optimized Result", color.blue)
```

## Memory Usage Patterns

Manage memory efficiently to prevent script slowdowns:

### Memory-Efficient Data Structures

```pinescript
//@version=6
indicator("Memory Efficient Patterns", overlay=false)

// Use appropriate data types
use_small_integers = true
var int small_counter = 0  // Instead of float when possible
var bool state_flag = false  // Instead of int for boolean states

// Efficient string handling
generate_label_text(value, precision) =>
    // Pre-format strings to avoid repeated conversions
    str.tostring(value, format.mintick)

// Memory-efficient matrix operations
manage_matrix_memory(matrix_data, max_rows, max_cols) =>
    current_rows = matrix.rows(matrix_data)
    current_cols = matrix.columns(matrix_data)
    
    // Resize matrix only when necessary
    if current_rows > max_rows
        // Remove excess rows
        for i = max_rows to current_rows - 1
            matrix.remove_row(matrix_data, max_rows)
    
    if current_cols > max_cols
        // Remove excess columns
        for i = max_cols to current_cols - 1
            matrix.remove_col(matrix_data, max_cols)

// Reuse objects instead of creating new ones
var line trend_line = na
update_trend_line(start_bar, start_price, end_bar, end_price) =>
    if not na(trend_line)
        line.delete(trend_line)
    
    trend_line := line.new(start_bar, start_price, end_bar, end_price, 
                          color=color.blue, width=2)

plot(small_counter, "Counter", color.blue)
```

## Load Time Optimization

Reduce script loading time:

### Initialization Optimization

```pinescript
//@version=6
indicator("Load Time Optimization", overlay=true)

// Defer expensive initialization
var bool initialized = false
var array<float> expensive_data = na

lazy_initialization() =>
    if not initialized
        expensive_data := array.new<float>(0)
        
        // Populate data only once
        for i = 1 to 100
            array.push(expensive_data, math.random())
        
        initialized := true

// Initialize only when needed
if barstate.islast and not initialized
    lazy_initialization()

// Use conditional compilation for debug code
DEBUG_MODE = false

debug_expensive_operation() =>
    if DEBUG_MODE
        // Expensive debug calculations
        log.info("Debug info: {0}", close)

// Only compile debug code when needed
if DEBUG_MODE
    debug_expensive_operation()
```

### Startup Performance

```pinescript
//@version=6
indicator("Startup Performance", overlay=true)

// Minimize global variable initialization
var simple bool quick_mode = input.bool(true, "Quick Mode")
var simple int calculation_frequency = quick_mode ? 10 : 1

// Conditional feature loading
enable_advanced_features = input.bool(false, "Enable Advanced Features")

// Only initialize expensive features when enabled
var array<float> advanced_data = enable_advanced_features ? array.new<float>(0) : na

// Stagger calculations across bars to reduce load
calculation_index = bar_index % 5

switch calculation_index
    0 => 
        // Basic calculations on every 5th bar (0, 5, 10, ...)
        basic_result = ta.sma(close, 20)
    1 => 
        // Medium calculations on bars 1, 6, 11, ...
        if enable_advanced_features
            medium_result = ta.ema(close, 50)
    2 => 
        // Complex calculations on bars 2, 7, 12, ...
        if enable_advanced_features
            complex_result = ta.macd(close, 12, 26, 9)[0]
```

## Best Practices for Large Datasets

Handle large datasets efficiently:

### Data Streaming Patterns

```pinescript
//@version=6
indicator("Large Dataset Handling", overlay=false)

// Stream data efficiently
CHUNK_SIZE = 100
var float[] data_stream = array.new<float>(0)
var int processed_chunks = 0

process_data_chunk() =>
    // Process data in chunks to prevent timeouts
    start_index = processed_chunks * CHUNK_SIZE
    end_index = math.min(start_index + CHUNK_SIZE, bar_index)
    
    chunk_sum = 0.0
    for i = start_index to end_index - 1
        chunk_sum += close[bar_index - i]
    
    processed_chunks += 1
    chunk_sum / (end_index - start_index)

// Process incrementally
if bar_index % CHUNK_SIZE == 0
    chunk_average = process_data_chunk()
    array.push(data_stream, chunk_average)

// Efficient data compression for storage
compress_data(original_data, compression_ratio) =>
    compressed = array.new<float>(0)
    step = math.max(1, math.round(compression_ratio))
    
    for i = 0 to array.size(original_data) - 1
        if i % step == 0
            array.push(compressed, array.get(original_data, i))
    
    compressed

// Use data sampling for analysis
sample_data_efficiently(data_array, sample_size) =>
    total_size = array.size(data_array)
    
    if total_size <= sample_size
        data_array
    else
        sampled = array.new<float>(0)
        step = total_size / sample_size
        
        for i = 0 to sample_size - 1
            index = math.round(i * step)
            array.push(sampled, array.get(data_array, index))
        
        sampled

current_average = array.size(data_stream) > 0 ? array.avg(data_stream) : na
plot(current_average, "Streaming Average", color.blue)
```

### Performance Monitoring

```pinescript
//@version=6
indicator("Performance Monitor", overlay=false)

// Monitor script performance metrics
var int max_bars_processed = 0
var float max_calculation_time = 0.0
var int performance_warnings = 0

monitor_performance() =>
    current_bars = bar_index + 1
    
    if current_bars > max_bars_processed
        max_bars_processed := current_bars
    
    // Warn about performance issues
    if barstate.islast
        if max_bars_processed > 5000
            performance_warnings += 1
            log.warning("High bar count detected: {0} bars", max_bars_processed)
        
        if performance_warnings > 0
            log.info("Performance summary: {0} warnings generated", performance_warnings)

// Call performance monitoring
monitor_performance()

// Display performance metrics
if barstate.islast
    runtime.error(na)  // Clear any runtime errors for clean display
    
    var table perf_table = table.new(position.top_right, 2, 4, 
                                    bgcolor=color.new(color.black, 80))
    
    table.cell(perf_table, 0, 0, "Metric", text_color=color.white)
    table.cell(perf_table, 1, 0, "Value", text_color=color.white)
    
    table.cell(perf_table, 0, 1, "Bars Processed", text_color=color.white)
    table.cell(perf_table, 1, 1, str.tostring(max_bars_processed), text_color=color.yellow)
    
    table.cell(perf_table, 0, 2, "Warnings", text_color=color.white)
    table.cell(perf_table, 1, 2, str.tostring(performance_warnings), text_color=color.yellow)
    
    table.cell(perf_table, 0, 3, "Memory Usage", text_color=color.white)
    table.cell(perf_table, 1, 3, "Normal", text_color=color.green)

plot(max_bars_processed, "Bars Processed", color.blue)
```

## Summary

Key performance optimization strategies:

1. **Minimize security() calls** - Combine requests and cache results
2. **Optimize array operations** - Limit sizes and use efficient algorithms  
3. **Reduce drawing objects** - Stay within limits and delete unused objects
4. **Cache calculations** - Store expensive computations and reuse
5. **Use conditional execution** - Only calculate when necessary
6. **Manage memory efficiently** - Clean up data structures regularly
7. **Profile performance** - Measure and monitor script execution
8. **Stream large datasets** - Process data in chunks
9. **Optimize loops** - Use early exits and limit iterations
10. **Defer initialization** - Load expensive features only when needed

Following these optimization techniques will ensure your Pine Script indicators and strategies run efficiently even with large datasets and complex calculations.