# Pine Script Debugging Tools

This guide covers the essential debugging tools and techniques available in Pine Script v6 for identifying and resolving issues in your indicators and strategies.

## Table of Contents
- [plot() for Value Debugging](#plot-for-value-debugging)
- [label.new() for Debug Information](#labelnew-for-debug-information)
- [table.new() for Debug Dashboards](#tablenew-for-debug-dashboards)
- [bgcolor() for Visual Debugging](#bgcolor-for-visual-debugging)
- [log.* Functions for Console Output](#log-functions-for-console-output)
- [barstate Variables for Execution Tracking](#barstate-variables-for-execution-tracking)
- [Debug Modes with input.bool()](#debug-modes-with-inputbool)
- [Conditional Compilation Techniques](#conditional-compilation-techniques)
- [Performance Profiling Methods](#performance-profiling-methods)

## plot() for Value Debugging

The `plot()` function is the most fundamental debugging tool for visualizing numeric values:

```pinescript
//@version=6
indicator("Debug with plot()", overlay=false)

// Example: Debugging RSI calculation steps
rsi_length = input.int(14, "RSI Length")
rsi_source = input.source(close, "RSI Source")

// Step-by-step RSI calculation for debugging
price_change = ta.change(rsi_source)
gains = math.max(price_change, 0)
losses = math.abs(math.min(price_change, 0))

avg_gains = ta.rma(gains, rsi_length)
avg_losses = ta.rma(losses, rsi_length)
rs = avg_gains / avg_losses
rsi = 100 - (100 / (1 + rs))

// Debug plots
plot(gains, "Gains", color.green, display=display.data_window)
plot(losses, "Losses", color.red, display=display.data_window)
plot(avg_gains, "Avg Gains", color.lime, display=display.data_window)
plot(avg_losses, "Avg Losses", color.maroon, display=display.data_window)
plot(rs, "RS", color.blue, display=display.data_window)
plot(rsi, "RSI", color.orange, linewidth=2)
```

### Advanced plot() Debugging Techniques

```pinescript
//@version=6
indicator("Advanced Plot Debugging", overlay=true)

debug_mode = input.bool(false, "Enable Debug Mode")
debug_overlay = input.bool(true, "Show Debug on Main Chart")

// Conditional debug plotting
ema_fast = ta.ema(close, 12)
ema_slow = ta.ema(close, 26)
signal = ema_fast > ema_slow

// Only plot debug info when enabled
plot(debug_mode ? ema_fast : na, "Fast EMA", color.blue, 
     display = debug_overlay ? display.all : display.data_window)
plot(debug_mode ? ema_slow : na, "Slow EMA", color.red,
     display = debug_overlay ? display.all : display.data_window)

// Use different plot styles for debugging
plotchar(debug_mode and signal, "Signal", "▲", location.belowbar, color.green, size=size.small)
```

## label.new() for Debug Information

Labels provide precise debugging information at specific bars:

```pinescript
//@version=6
indicator("Debug with Labels", overlay=true, max_labels_count=100)

debug_enabled = input.bool(false, "Show Debug Labels")
show_every_n_bars = input.int(10, "Show Label Every N Bars", minval=1)

// Example: Debugging Bollinger Bands calculation
bb_length = input.int(20, "BB Length")
bb_mult = input.float(2.0, "BB Multiplier")

basis = ta.sma(close, bb_length)
dev = bb_mult * ta.stdev(close, bb_length)
upper = basis + dev
lower = basis - dev

// Create debug labels
if debug_enabled and bar_index % show_every_n_bars == 0
    debug_text = str.format("Bar: {0}\nClose: {1}\nBasis: {2}\nDev: {3}\nUpper: {4}\nLower: {5}",
                           bar_index, close, basis, dev, upper, lower)
    
    label.new(bar_index, high * 1.01, debug_text, 
              style=label.style_label_down, 
              color=color.yellow, 
              textcolor=color.black,
              size=size.small)

// Error condition debugging
if debug_enabled and (upper <= lower or dev <= 0)
    label.new(bar_index, high * 1.05, "ERROR: Invalid BB calculation!", 
              style=label.style_label_down, 
              color=color.red, 
              textcolor=color.white)
```

### Dynamic Label Content

```pinescript
//@version=6
indicator("Dynamic Debug Labels", overlay=true, max_labels_count=50)

debug_mode = input.bool(false, "Debug Mode")

// Track calculation states
var float prev_value = na
var int state_changes = 0

current_value = ta.rsi(close, 14)

if not na(prev_value) and math.sign(current_value - 50) != math.sign(prev_value - 50)
    state_changes += 1

if debug_mode and ta.change(current_value) != 0
    trend_text = current_value > 50 ? "BULL" : "BEAR"
    change_text = current_value > prev_value ? "↑" : "↓"
    
    label_text = str.format("{0} {1}\nRSI: {2}\nChanges: {3}",
                           trend_text, change_text, 
                           str.tostring(current_value, "#.##"),
                           state_changes)
    
    label.new(bar_index, current_value > 50 ? low * 0.99 : high * 1.01, 
              label_text,
              style = current_value > 50 ? label.style_label_up : label.style_label_down,
              color = current_value > 50 ? color.green : color.red)

prev_value := current_value
```

## table.new() for Debug Dashboards

Tables create comprehensive debug dashboards:

```pinescript
//@version=6
indicator("Debug Dashboard", overlay=true)

show_debug_table = input.bool(false, "Show Debug Table")
table_position = input.string("top_right", "Table Position", 
                              options=["top_left", "top_center", "top_right", 
                                      "middle_left", "middle_center", "middle_right",
                                      "bottom_left", "bottom_center", "bottom_right"])

// Calculate multiple indicators for dashboard
rsi_val = ta.rsi(close, 14)
macd_line = ta.macd(close, 12, 26, 9)[0]
bb_upper = ta.bb(close, 20, 2)[0]
bb_lower = ta.bb(close, 20, 2)[2]
atr_val = ta.atr(14)

// Create debug table
var table debug_table = na

if show_debug_table and barstate.islast
    debug_table := table.new(position=table_position, columns=2, rows=8, 
                            bgcolor=color.new(color.black, 80), 
                            border_width=1,
                            border_color=color.gray)
    
    // Header
    table.cell(debug_table, 0, 0, "Indicator", text_color=color.white, bgcolor=color.blue)
    table.cell(debug_table, 1, 0, "Value", text_color=color.white, bgcolor=color.blue)
    
    // Data rows
    table.cell(debug_table, 0, 1, "Symbol", text_color=color.white)
    table.cell(debug_table, 1, 1, syminfo.ticker, text_color=color.yellow)
    
    table.cell(debug_table, 0, 2, "Timeframe", text_color=color.white)
    table.cell(debug_table, 1, 2, timeframe.period, text_color=color.yellow)
    
    table.cell(debug_table, 0, 3, "Close", text_color=color.white)
    table.cell(debug_table, 1, 3, str.tostring(close, "#.####"), text_color=color.yellow)
    
    table.cell(debug_table, 0, 4, "RSI(14)", text_color=color.white)
    rsi_color = rsi_val > 70 ? color.red : rsi_val < 30 ? color.green : color.yellow
    table.cell(debug_table, 1, 4, str.tostring(rsi_val, "#.##"), text_color=rsi_color)
    
    table.cell(debug_table, 0, 5, "MACD", text_color=color.white)
    macd_color = macd_line > 0 ? color.green : color.red
    table.cell(debug_table, 1, 5, str.tostring(macd_line, "#.####"), text_color=macd_color)
    
    table.cell(debug_table, 0, 6, "BB Position", text_color=color.white)
    bb_position = (close - bb_lower) / (bb_upper - bb_lower) * 100
    bb_color = bb_position > 80 ? color.red : bb_position < 20 ? color.green : color.yellow
    table.cell(debug_table, 1, 6, str.tostring(bb_position, "#.#") + "%", text_color=bb_color)
    
    table.cell(debug_table, 0, 7, "ATR(14)", text_color=color.white)
    table.cell(debug_table, 1, 7, str.tostring(atr_val, "#.####"), text_color=color.yellow)
```

## bgcolor() for Visual Debugging

Background colors provide instant visual feedback:

```pinescript
//@version=6
indicator("Visual Debug with bgcolor", overlay=true)

debug_colors = input.bool(false, "Show Debug Colors")
color_transparency = input.int(90, "Color Transparency", minval=0, maxval=100)

// Example: Debugging trend conditions
ema_short = ta.ema(close, 10)
ema_long = ta.ema(close, 20)

bullish_trend = ema_short > ema_long
strong_bullish = bullish_trend and close > ema_short and ta.rising(ema_short, 3)
weak_bullish = bullish_trend and not strong_bullish

bearish_trend = ema_short < ema_long
strong_bearish = bearish_trend and close < ema_short and ta.falling(ema_short, 3)
weak_bearish = bearish_trend and not strong_bearish

// Apply debug colors
if debug_colors
    bgcolor(strong_bullish ? color.new(color.green, color_transparency) : 
            weak_bullish ? color.new(color.lime, color_transparency) :
            strong_bearish ? color.new(color.red, color_transparency) :
            weak_bearish ? color.new(color.orange, color_transparency) : na)

// Volume debugging
volume_sma = ta.sma(volume, 20)
high_volume = volume > volume_sma * 1.5
low_volume = volume < volume_sma * 0.5

// Volume background colors (only when price debugging is off)
if debug_colors and input.bool(false, "Show Volume Debug")
    bgcolor(high_volume ? color.new(color.purple, color_transparency) :
            low_volume ? color.new(color.gray, color_transparency) : na)
```

## log.* Functions for Console Output

Console logging for detailed debugging:

```pinescript
//@version=6
indicator("Console Debug Logging", overlay=true)

enable_logging = input.bool(false, "Enable Console Logging")
log_level = input.string("info", "Log Level", options=["error", "warning", "info"])

// Example: Debugging a custom function
debug_function(src, length) =>
    if enable_logging
        log.info("debug_function called with src={0}, length={1}", src, length)
    
    if length <= 0
        if enable_logging and log_level == "error"
            log.error("Invalid length parameter: {0}", length)
        na
    else
        sma_val = ta.sma(src, length)
        if enable_logging
            log.info("Calculated SMA: {0}", sma_val)
        sma_val

// Test the function
result = debug_function(close, 14)

// Conditional logging based on market conditions
if enable_logging and ta.change(close) > close * 0.05
    log.warning("Large price movement detected: {0}% change", 
                ta.change(close) / close[1] * 100)

// Performance logging
if enable_logging and barstate.islast
    log.info("Script completed processing {0} bars", bar_index + 1)
```

## barstate Variables for Execution Tracking

Track script execution states:

```pinescript
//@version=6
indicator("Execution Tracking", overlay=true)

show_execution_info = input.bool(false, "Show Execution Info")

// Track different execution states
var int confirmed_bars = 0
var int realtime_updates = 0
var bool first_execution = true

if barstate.isconfirmed
    confirmed_bars += 1

if barstate.isrealtime
    realtime_updates += 1

// Debug execution flow
if show_execution_info
    if barstate.isfirst and first_execution
        label.new(bar_index, high, "FIRST BAR", 
                  style=label.style_label_down, color=color.blue)
        first_execution := false
    
    if barstate.islast
        execution_info = str.format("Confirmed: {0}\nRealtime: {1}\nHistory: {2}",
                                   confirmed_bars, realtime_updates, 
                                   barstate.ishistory ? "Yes" : "No")
        
        label.new(bar_index, high * 1.05, execution_info,
                  style=label.style_label_down, color=color.yellow)
    
    if barstate.isnew
        plotchar(true, "New Bar", "●", location.abovebar, color.green, size=size.tiny)
```

## Debug Modes with input.bool()

Create comprehensive debug modes:

```pinescript
//@version=6
indicator("Comprehensive Debug Mode", overlay=true)

// Debug configuration
debug_group = "Debug Settings"
master_debug = input.bool(false, "Master Debug Mode", group=debug_group)
debug_calculations = input.bool(false, "Debug Calculations", group=debug_group)
debug_signals = input.bool(false, "Debug Signals", group=debug_group)
debug_performance = input.bool(false, "Debug Performance", group=debug_group)
debug_errors = input.bool(true, "Debug Errors", group=debug_group)

// Performance tracking
var float start_time = na
var int calculation_count = 0

if barstate.isfirst
    start_time := time

// Main calculation with debug instrumentation
calculate_signal() =>
    calculation_count += 1
    
    if master_debug and debug_calculations
        log.info("Starting calculation #{0}", calculation_count)
    
    // Simulate complex calculation
    value1 = ta.ema(close, 12)
    value2 = ta.ema(close, 26)
    signal = value1 > value2
    
    // Error checking
    if debug_errors and (na(value1) or na(value2))
        log.error("NA values detected in calculation #{0}", calculation_count)
    
    if master_debug and debug_signals
        log.info("Signal generated: {0} (EMA12: {1}, EMA26: {2})", 
                 signal, value1, value2)
    
    signal

// Execute with debugging
current_signal = calculate_signal()

// Performance reporting
if master_debug and debug_performance and barstate.islast
    elapsed_time = time - start_time
    log.info("Performance Report - Bars: {0}, Calculations: {1}, Time: {2}ms", 
             bar_index + 1, calculation_count, elapsed_time)
```

## Conditional Compilation Techniques

Use conditional compilation for debug code:

```pinescript
//@version=6
indicator("Conditional Compilation Debug", overlay=true)

// Debug compilation flags
DEBUG_MODE = true
PERFORMANCE_TRACKING = true
VERBOSE_LOGGING = false

// Conditional debug variables
var debug_data = DEBUG_MODE ? array.new<float>() : na

// Conditional function definitions
debug_log(message) =>
    if DEBUG_MODE and VERBOSE_LOGGING
        log.info(message)

performance_start() =>
    if PERFORMANCE_TRACKING
        time
    else
        na

performance_end(start_time, operation) =>
    if PERFORMANCE_TRACKING and not na(start_time)
        elapsed = time - start_time
        log.info("Operation '{0}' took {1}ms", operation, elapsed)

// Usage with conditional compilation
start_calc = performance_start()

// Main calculation
result = ta.sma(close, 20)

// Conditional debug data collection
if DEBUG_MODE
    array.push(debug_data, result)
    if array.size(debug_data) > 100
        array.shift(debug_data)

performance_end(start_calc, "SMA calculation")

// Conditional debug output
if DEBUG_MODE and barstate.islast
    avg_result = array.avg(debug_data)
    debug_log(str.format("Average SMA over last {0} bars: {1}", 
                        array.size(debug_data), avg_result))
```

## Performance Profiling Methods

Profile your script's performance:

```pinescript
//@version=6
indicator("Performance Profiler", overlay=true)

enable_profiling = input.bool(false, "Enable Performance Profiling")

// Performance tracking structure
type ProfileData
    string name
    float total_time
    int call_count
    float avg_time

var array<ProfileData> profiles = array.new<ProfileData>()

// Profiling function
profile_function(name, func) =>
    if not enable_profiling
        func
    else
        start_time = time
        result = func
        end_time = time
        elapsed = end_time - start_time
        
        // Find or create profile entry
        profile_index = -1
        for i = 0 to array.size(profiles) - 1
            profile = array.get(profiles, i)
            if ProfileData.name(profile) == name
                profile_index := i
                break
        
        if profile_index >= 0
            profile = array.get(profiles, profile_index)
            new_total = ProfileData.total_time(profile) + elapsed
            new_count = ProfileData.call_count(profile) + 1
            new_avg = new_total / new_count
            
            updated_profile = ProfileData.new(name, new_total, new_count, new_avg)
            array.set(profiles, profile_index, updated_profile)
        else
            new_profile = ProfileData.new(name, elapsed, 1, elapsed)
            array.push(profiles, new_profile)
        
        result

// Example usage
rsi_calc() =>
    ta.rsi(close, 14)

macd_calc() =>
    ta.macd(close, 12, 26, 9)[0]

// Profile the calculations
rsi_result = profile_function("RSI", rsi_calc())
macd_result = profile_function("MACD", macd_calc())

// Display profiling results
if enable_profiling and barstate.islast and array.size(profiles) > 0
    var table profile_table = table.new(position.top_left, 4, array.size(profiles) + 1,
                                       bgcolor=color.black, border_width=1)
    
    table.cell(profile_table, 0, 0, "Function", text_color=color.white, bgcolor=color.blue)
    table.cell(profile_table, 1, 0, "Calls", text_color=color.white, bgcolor=color.blue)
    table.cell(profile_table, 2, 0, "Total (ms)", text_color=color.white, bgcolor=color.blue)
    table.cell(profile_table, 3, 0, "Avg (ms)", text_color=color.white, bgcolor=color.blue)
    
    for i = 0 to array.size(profiles) - 1
        profile = array.get(profiles, i)
        table.cell(profile_table, 0, i + 1, ProfileData.name(profile), text_color=color.white)
        table.cell(profile_table, 1, i + 1, str.tostring(ProfileData.call_count(profile)), text_color=color.yellow)
        table.cell(profile_table, 2, i + 1, str.tostring(ProfileData.total_time(profile), "#.##"), text_color=color.yellow)
        table.cell(profile_table, 3, i + 1, str.tostring(ProfileData.avg_time(profile), "#.##"), text_color=color.yellow)
```

## Best Practices for Debugging

1. **Use Multiple Tools**: Combine different debugging methods for comprehensive analysis
2. **Conditional Debug Code**: Always make debug code conditional to avoid performance impact in production
3. **Structured Logging**: Use consistent log formats and levels
4. **Visual Hierarchy**: Use colors and styles to indicate debug information priority
5. **Performance Awareness**: Remove or disable debug code in production scripts
6. **Error Boundaries**: Always check for edge cases and invalid inputs
7. **State Tracking**: Monitor variable states across different execution phases

## Common Debug Patterns

```pinescript
// Pattern 1: Value validation
validate_input(value, min_val, max_val, name) =>
    if na(value)
        log.error("Input {0} is NA", name)
        false
    else if value < min_val or value > max_val
        log.warning("Input {0} ({1}) outside valid range [{2}, {3}]", 
                   name, value, min_val, max_val)
        false
    else
        true

// Pattern 2: Calculation checkpoints
checkpoint(value, stage, should_log = true) =>
    if should_log
        log.info("Checkpoint {0}: {1}", stage, value)
    
    if na(value)
        log.error("NA value at checkpoint {0}", stage)
    
    value

// Pattern 3: State change detection
detect_state_change(current_state, prev_state, state_name) =>
    if current_state != prev_state
        log.info("State change in {0}: {1} -> {2}", 
                state_name, prev_state, current_state)
        true
    else
        false
```

This comprehensive debugging toolkit will help you identify and resolve issues efficiently in your Pine Script indicators and strategies.