# Pine Script v6 Indicator Structure Guide

This guide provides comprehensive templates and best practices for creating professional Pine Script v6 indicators, from basic structure to advanced multi-timeframe implementations.

## Table of Contents
1. [Indicator Declaration](#indicator-declaration)
2. [Input Organization](#input-organization)
3. [Calculation Section Best Practices](#calculation-section-best-practices)
4. [Plotting Strategies](#plotting-strategies)
5. [Alert Implementation](#alert-implementation)
6. [Standard Indicator Template](#standard-indicator-template)
7. [Multi-Timeframe Indicators](#multi-timeframe-indicators)
8. [Advanced Patterns](#advanced-patterns)

---

## Indicator Declaration

### Basic Declaration Structure
```pinescript
//@version=6
indicator(
    title="Indicator Name",
    shorttitle="Short Name",
    overlay=true,                    // or false for separate pane
    format=format.price,             // or format.volume, format.percent
    precision=2,                     // decimal places
    scale=scale.right,               // or scale.left, scale.none
    max_boxes_count=500,            // if using boxes
    max_lines_count=500,            // if using lines
    max_labels_count=500,           // if using labels
    max_bars_back=5000              // historical data access
)
```

### Declaration Examples

#### Price Overlay Indicator
```pinescript
//@version=6
indicator(
    "Advanced Moving Average", 
    "AMA",
    overlay=true,
    precision=4
)
```

#### Oscillator Indicator
```pinescript
//@version=6
indicator(
    "Custom RSI Oscillator",
    "CRSI",
    overlay=false,
    format=format.percent,
    precision=1,
    scale=scale.right
)
```

#### Volume Indicator
```pinescript
//@version=6
indicator(
    "Volume Profile Indicator",
    "VPI",
    overlay=false,
    format=format.volume,
    scale=scale.right,
    max_boxes_count=100
)
```

---

## Input Organization

### Comprehensive Input Structure
```pinescript
//@version=6
indicator("Professional Input Organization", "PIO", overlay=true)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
// INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Main Settings Group
main_length = input.int(14, "Period", minval=1, maxval=500, group="Main Settings", tooltip="Number of bars for calculation")
main_source = input.source(close, "Source", group="Main Settings", tooltip="Price source for calculations")
main_method = input.string("SMA", "Method", options=["SMA", "EMA", "WMA", "RMA"], group="Main Settings")

// Signal Settings Group
signal_enable = input.bool(true, "Enable Signals", group="Signal Settings")
signal_sensitivity = input.float(2.0, "Sensitivity", minval=0.1, maxval=5.0, step=0.1, group="Signal Settings")
signal_confirmation = input.bool(false, "Require Confirmation", group="Signal Settings", 
    tooltip="Wait for bar close before signaling")

// Visual Settings Group
show_ma = input.bool(true, "Show Moving Average", group="Visual Settings")
ma_color = input.color(color.blue, "MA Color", group="Visual Settings")
ma_width = input.int(2, "MA Line Width", minval=1, maxval=4, group="Visual Settings")
show_fill = input.bool(false, "Show Fill Area", group="Visual Settings")
fill_color = input.color(color.new(color.blue, 80), "Fill Color", group="Visual Settings")

// Alert Settings Group
alert_enable = input.bool(false, "Enable Alerts", group="Alert Settings")
alert_method = input.string("Once Per Bar", "Alert Frequency", 
    options=["All", "Once Per Bar", "Once Per Bar Close"], group="Alert Settings")

// Advanced Settings Group
advanced_offset = input.int(0, "Plot Offset", group="Advanced Settings", 
    tooltip="Shift plots by N bars")
advanced_limit = input.int(500, "Historical Limit", minval=100, maxval=5000, group="Advanced Settings")
advanced_debug = input.bool(false, "Debug Mode", group="Advanced Settings")
```

### Input Validation and Processing
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// INPUT VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Validate and process inputs
validated_length = math.max(1, math.min(500, main_length))
validated_offset = math.max(-500, math.min(500, advanced_offset))

// Create method function based on input
get_ma(src, len) =>
    switch main_method
        "SMA" => ta.sma(src, len)
        "EMA" => ta.ema(src, len)
        "WMA" => ta.wma(src, len)
        "RMA" => ta.rma(src, len)
        => ta.sma(src, len)  // default fallback

// Input-dependent colors
dynamic_color = ma_color
signal_color = signal_enable ? color.yellow : color.gray
```

---

## Calculation Section Best Practices

### Organized Calculation Structure
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// CALCULATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Core Calculations
ma_value = get_ma(main_source, validated_length)
ma_slope = ta.change(ma_value)
ma_trend = ma_slope > 0 ? 1 : ma_slope < 0 ? -1 : 0

// Secondary Calculations
price_distance = main_source - ma_value
price_distance_pct = (price_distance / ma_value) * 100
volatility = ta.atr(validated_length)

// Signal Calculations
signal_threshold = volatility * signal_sensitivity
bullish_signal = ta.crossover(main_source, ma_value + signal_threshold)
bearish_signal = ta.crossunder(main_source, ma_value - signal_threshold)

// Confirmation Logic
confirmed_bullish = signal_confirmation ? bullish_signal and barstate.isconfirmed : bullish_signal
confirmed_bearish = signal_confirmation ? bearish_signal and barstate.isconfirmed : bearish_signal

// State Management
var float last_signal_price = na
var int last_signal_bar = 0
var string last_signal_type = ""

if confirmed_bullish
    last_signal_price := main_source
    last_signal_bar := bar_index
    last_signal_type := "BULL"
    
if confirmed_bearish
    last_signal_price := main_source
    last_signal_bar := bar_index
    last_signal_type := "BEAR"
```

### Advanced Calculation Patterns
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// ADVANCED CALCULATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Multi-timeframe calculations
htf_timeframe = timeframe.period == "1" ? "5" : 
               timeframe.period == "5" ? "15" : 
               timeframe.period == "15" ? "60" : "240"

htf_ma = request.security(syminfo.tickerid, htf_timeframe, 
    get_ma(main_source, validated_length), lookahead=barmerge.lookahead_off)

// Dynamic length based on volatility
vol_adjusted_length = math.round(validated_length * (1 + volatility / main_source))
adaptive_ma = get_ma(main_source, math.max(2, math.min(100, vol_adjusted_length)))

// Statistical calculations
ma_stddev = ta.stdev(main_source - ma_value, validated_length)
upper_band = ma_value + (ma_stddev * 2)
lower_band = ma_value - (ma_stddev * 2)
band_width = upper_band - lower_band
band_position = (main_source - lower_band) / band_width

// Momentum calculations
momentum = ta.change(main_source, validated_length)
momentum_ma = get_ma(momentum, validated_length / 2)
momentum_signal = ta.cross(momentum, momentum_ma)
```

---

## Plotting Strategies

### Basic Plotting Structure
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Main indicator plot
ma_plot = plot(show_ma ? ma_value : na, 
    title="Moving Average",
    color=dynamic_color,
    linewidth=ma_width,
    offset=validated_offset)

// Price plot for reference (if overlay)
price_plot = plot(main_source, 
    title="Price",
    color=color.new(color.gray, 70),
    linewidth=1,
    display=display.none)  // Hidden reference for fill

// Fill between price and MA
fill(price_plot, ma_plot, 
    color=show_fill ? fill_color : na,
    title="Price-MA Fill")

// Trend bands
upper_plot = plot(upper_band, 
    title="Upper Band",
    color=color.new(color.red, 50),
    linewidth=1)
    
lower_plot = plot(lower_band,
    title="Lower Band", 
    color=color.new(color.green, 50),
    linewidth=1)

// Band fill
fill(upper_plot, lower_plot,
    color=color.new(color.blue, 95),
    title="Band Fill")
```

### Advanced Plotting with Conditions
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// CONDITIONAL PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Dynamic colors based on trend
trend_color = ma_trend > 0 ? color.green : ma_trend < 0 ? color.red : color.gray
plot(ma_value,
    title="Trend MA",
    color=trend_color,
    linewidth=2)

// Signal markers
plotshape(confirmed_bullish and signal_enable, 
    title="Bullish Signal",
    style=shape.triangleup,
    location=location.belowbar,
    color=color.green,
    size=size.small)

plotshape(confirmed_bearish and signal_enable,
    title="Bearish Signal", 
    style=shape.triangledown,
    location=location.abovebar,
    color=color.red,
    size=size.small)

// Background color for strong signals
bgcolor(confirmed_bullish and signal_enable ? color.new(color.green, 90) : na,
    title="Bullish Background")
bgcolor(confirmed_bearish and signal_enable ? color.new(color.red, 90) : na,
    title="Bearish Background")

// Plot characters for debugging
plotchar(advanced_debug ? band_position : na,
    title="Band Position",
    char="●",
    location=location.top,
    color=color.blue,
    size=size.tiny)
```

### Multi-Plot Indicator Example
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// MULTI-PLOT STRUCTURE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Multiple moving averages
fast_ma = get_ma(main_source, validated_length / 2)
slow_ma = get_ma(main_source, validated_length * 2)

plot(fast_ma, "Fast MA", color.blue, 1)
plot(ma_value, "Medium MA", color.orange, 2)
plot(slow_ma, "Slow MA", color.red, 1)

// Crossover signals
fast_slow_cross = ta.cross(fast_ma, slow_ma)
plotshape(ta.crossover(fast_ma, slow_ma), 
    style=shape.circle, 
    location=location.belowbar, 
    color=color.green)
plotshape(ta.crossunder(fast_ma, slow_ma), 
    style=shape.circle, 
    location=location.abovebar, 
    color=color.red)
```

---

## Alert Implementation

### Comprehensive Alert System
```pinescript
// ═══════════════════════════════════════════════════════════════════════════════════════════════
// ALERTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Alert conditions
alert_bullish = alert_enable and confirmed_bullish
alert_bearish = alert_enable and confirmed_bearish
alert_trend_change = alert_enable and ta.change(ma_trend) != 0

// Alert messages
bullish_message = str.format("BULLISH SIGNAL\nSymbol: {0}\nPrice: {1}\nMA: {2}\nTime: {3}",
    syminfo.ticker, 
    str.tostring(main_source, "0.00"),
    str.tostring(ma_value, "0.00"),
    str.format_time(time, "yyyy-MM-dd HH:mm"))

bearish_message = str.format("BEARISH SIGNAL\nSymbol: {0}\nPrice: {1}\nMA: {2}\nTime: {3}",
    syminfo.ticker,
    str.tostring(main_source, "0.00"), 
    str.tostring(ma_value, "0.00"),
    str.format_time(time, "yyyy-MM-dd HH:mm"))

trend_message = str.format("TREND CHANGE\nSymbol: {0}\nNew Trend: {1}\nPrice: {2}",
    syminfo.ticker,
    ma_trend > 0 ? "BULLISH" : ma_trend < 0 ? "BEARISH" : "NEUTRAL",
    str.tostring(main_source, "0.00"))

// Alert frequency settings
alert_freq = alert_method == "All" ? alert.freq_all :
             alert_method == "Once Per Bar" ? alert.freq_once_per_bar :
             alert.freq_once_per_bar_close

// Send alerts
alertcondition(alert_bullish, "Bullish Signal", bullish_message)
alertcondition(alert_bearish, "Bearish Signal", bearish_message)
alertcondition(alert_trend_change, "Trend Change", trend_message)

// Combined alert for automation
alertcondition(alert_bullish or alert_bearish, 
    "Any Signal", 
    "{{strategy.order.action}} signal on {{ticker}} at {{close}}")
```

---

## Standard Indicator Template

### Complete Professional Template
```pinescript
//@version=6
indicator(
    title="Professional Indicator Template",
    shorttitle="PIT",
    overlay=true,
    precision=4,
    max_labels_count=100,
    max_lines_count=50
)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                          INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Main Settings
main_length = input.int(20, "Period", minval=1, maxval=500, group="Main Settings")
main_source = input.source(close, "Source", group="Main Settings")
main_method = input.string("EMA", "Method", options=["SMA", "EMA", "WMA", "RMA"], group="Main Settings")

// Signal Settings  
signal_enable = input.bool(true, "Enable Signals", group="Signal Settings")
signal_sensitivity = input.float(1.5, "Sensitivity", minval=0.1, maxval=5.0, group="Signal Settings")

// Visual Settings
show_ma = input.bool(true, "Show MA", group="Visual Settings")
ma_color = input.color(color.blue, "MA Color", group="Visual Settings")
show_signals = input.bool(true, "Show Signal Markers", group="Visual Settings")

// Alert Settings
alert_enable = input.bool(false, "Enable Alerts", group="Alert Settings")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                       CALCULATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// MA function
get_ma(src, len) =>
    switch main_method
        "SMA" => ta.sma(src, len)
        "EMA" => ta.ema(src, len) 
        "WMA" => ta.wma(src, len)
        "RMA" => ta.rma(src, len)

// Core calculations
ma_value = get_ma(main_source, main_length)
ma_slope = ta.change(ma_value)
atr_value = ta.atr(14)

// Signal logic
threshold = atr_value * signal_sensitivity
bullish_signal = signal_enable and ta.crossover(main_source, ma_value + threshold)
bearish_signal = signal_enable and ta.crossunder(main_source, ma_value - threshold)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                         PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Main MA plot
plot(show_ma ? ma_value : na,
    title="Moving Average",
    color=ma_color,
    linewidth=2)

// Signal markers
plotshape(bullish_signal and show_signals,
    title="Bullish Signal",
    style=shape.triangleup,
    location=location.belowbar,
    color=color.green,
    size=size.small)

plotshape(bearish_signal and show_signals,
    title="Bearish Signal", 
    style=shape.triangledown,
    location=location.abovebar,
    color=color.red,
    size=size.small)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                          ALERTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

alertcondition(bullish_signal and alert_enable, "Bullish", "Bullish signal on {{ticker}}")
alertcondition(bearish_signal and alert_enable, "Bearish", "Bearish signal on {{ticker}}")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                      DEBUG TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

debug_mode = input.bool(false, "Debug Mode", group="Debug")

var table debug_table = table.new(position.top_right, 2, 6)

if debug_mode and barstate.islast
    table.clear(debug_table, 0, 0, 1, 5)
    table.cell(debug_table, 0, 0, "Debug Info", bgcolor=color.gray, text_color=color.white)
    table.cell(debug_table, 1, 0, "", bgcolor=color.gray)
    table.cell(debug_table, 0, 1, "MA Value")
    table.cell(debug_table, 1, 1, str.tostring(ma_value, "0.0000"))
    table.cell(debug_table, 0, 2, "Slope")
    table.cell(debug_table, 1, 2, str.tostring(ma_slope, "0.0000"))
    table.cell(debug_table, 0, 3, "ATR")
    table.cell(debug_table, 1, 3, str.tostring(atr_value, "0.0000"))
    table.cell(debug_table, 0, 4, "Threshold")
    table.cell(debug_table, 1, 4, str.tostring(threshold, "0.0000"))
    table.cell(debug_table, 0, 5, "Last Signal")
    table.cell(debug_table, 1, 5, bullish_signal ? "BULL" : bearish_signal ? "BEAR" : "NONE")
```

---

## Multi-Timeframe Indicators

### Advanced Multi-Timeframe Structure
```pinescript
//@version=6
indicator("Multi-Timeframe Indicator", "MTF", overlay=true)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   MTF INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Timeframe settings
mtf_enable = input.bool(true, "Enable Multi-Timeframe", group="Multi-Timeframe")
mtf_timeframe = input.timeframe("", "Higher Timeframe", group="Multi-Timeframe")
mtf_auto = input.bool(true, "Auto Select HTF", group="Multi-Timeframe", 
    tooltip="Automatically select higher timeframe based on current chart")

// Main settings
length = input.int(20, "Period", group="Main Settings")
source = input.source(close, "Source", group="Main Settings")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                MTF FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Auto timeframe selection
get_auto_timeframe() =>
    current_tf = timeframe.in_seconds("")
    if current_tf <= 60
        "5"      // 1min -> 5min
    else if current_tf <= 300
        "15"     // 5min -> 15min
    else if current_tf <= 900
        "60"     // 15min -> 1hour
    else if current_tf <= 3600
        "240"    // 1hour -> 4hour
    else if current_tf <= 14400
        "1D"     // 4hour -> Daily
    else
        "1W"     // Daily+ -> Weekly

// Determine timeframe to use
tf_to_use = mtf_auto ? get_auto_timeframe() : mtf_timeframe

// MTF calculation function
get_mtf_data(tf, src, len) =>
    request.security(syminfo.tickerid, tf, [
        ta.ema(src, len),           // HTF EMA
        ta.rsi(src, 14),           // HTF RSI  
        ta.change(src) > 0,        // HTF bullish bar
        ta.atr(14),                // HTF ATR
        time                       // HTF time
    ], lookahead=barmerge.lookahead_off)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              MTF CALCULATIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Current timeframe calculations
ctf_ema = ta.ema(source, length)
ctf_rsi = ta.rsi(source, 14)
ctf_trend = ta.change(source) > 0

// Higher timeframe calculations
[htf_ema, htf_rsi, htf_bullish, htf_atr, htf_time] = mtf_enable ? 
    get_mtf_data(tf_to_use, source, length) : 
    [ctf_ema, ctf_rsi, ctf_trend, ta.atr(14), time]

// Multi-timeframe alignment
mtf_aligned_bullish = ctf_trend and htf_bullish
mtf_aligned_bearish = not ctf_trend and not htf_bullish

// HTF trend strength
htf_trend_strength = math.abs(htf_rsi - 50) / 50

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  MTF PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Current timeframe EMA
plot(ctf_ema, "CTF EMA", color.blue, 1)

// Higher timeframe EMA (if enabled)
plot(mtf_enable ? htf_ema : na, "HTF EMA", color.orange, 2)

// MTF alignment signals
plotshape(mtf_aligned_bullish and ta.change(mtf_aligned_bullish),
    title="MTF Bullish Alignment",
    style=shape.triangleup,
    location=location.belowbar,
    color=color.green,
    size=size.normal)

plotshape(mtf_aligned_bearish and ta.change(mtf_aligned_bearish),
    title="MTF Bearish Alignment", 
    style=shape.triangledown,
    location=location.abovebar,
    color=color.red,
    size=size.normal)

// Background color for alignment
bgcolor(mtf_aligned_bullish ? color.new(color.green, 95) : 
        mtf_aligned_bearish ? color.new(color.red, 95) : na,
        title="MTF Alignment Background")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                    MTF TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

show_mtf_table = input.bool(true, "Show MTF Table", group="Display")
var table mtf_table = table.new(position.top_left, 2, 6)

if show_mtf_table and barstate.islast
    table.clear(mtf_table, 0, 0, 1, 5)
    
    table.cell(mtf_table, 0, 0, "MTF Analysis", 
        bgcolor=color.blue, text_color=color.white)
    table.cell(mtf_table, 1, 0, tf_to_use, 
        bgcolor=color.blue, text_color=color.white)
    
    table.cell(mtf_table, 0, 1, "CTF Trend")
    table.cell(mtf_table, 1, 1, ctf_trend ? "UP" : "DOWN",
        text_color=ctf_trend ? color.green : color.red)
    
    table.cell(mtf_table, 0, 2, "HTF Trend") 
    table.cell(mtf_table, 1, 2, htf_bullish ? "UP" : "DOWN",
        text_color=htf_bullish ? color.green : color.red)
    
    table.cell(mtf_table, 0, 3, "Alignment")
    alignment_text = mtf_aligned_bullish ? "BULLISH" : 
                     mtf_aligned_bearish ? "BEARISH" : "MIXED"
    alignment_color = mtf_aligned_bullish ? color.green : 
                      mtf_aligned_bearish ? color.red : color.gray
    table.cell(mtf_table, 1, 3, alignment_text, text_color=alignment_color)
    
    table.cell(mtf_table, 0, 4, "HTF RSI")
    table.cell(mtf_table, 1, 4, str.tostring(htf_rsi, "0.0"))
    
    table.cell(mtf_table, 0, 5, "Strength")
    table.cell(mtf_table, 1, 5, str.tostring(htf_trend_strength * 100, "0") + "%")
```

---

## Advanced Patterns

### Indicator with State Management
```pinescript
//@version=6
indicator("Advanced State Management", "ASM", overlay=true)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  STATE VARIABLES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Persistent state variables
var string current_state = "NEUTRAL"
var float entry_price = na
var int entry_bar = 0
var int signal_count = 0
var array<float> signal_prices = array.new<float>(0)

// State definitions
STATE_NEUTRAL = "NEUTRAL"
STATE_BULLISH = "BULLISH"  
STATE_BEARISH = "BEARISH"
STATE_WARNING = "WARNING"

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 STATE LOGIC
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Input settings
length = input.int(20, "Period")
threshold = input.float(1.5, "Threshold")

// Calculations
ema = ta.ema(close, length)
distance = (close - ema) / ema * 100
rsi = ta.rsi(close, 14)

// State transition conditions
enter_bullish = distance > threshold and rsi > 50
enter_bearish = distance < -threshold and rsi < 50
exit_to_neutral = math.abs(distance) < threshold * 0.5
enter_warning = (current_state == STATE_BULLISH and rsi > 80) or 
               (current_state == STATE_BEARISH and rsi < 20)

// State machine
if current_state == STATE_NEUTRAL
    if enter_bullish
        current_state := STATE_BULLISH
        entry_price := close
        entry_bar := bar_index
        signal_count := signal_count + 1
        array.push(signal_prices, close)
    else if enter_bearish
        current_state := STATE_BEARISH
        entry_price := close
        entry_bar := bar_index
        signal_count := signal_count + 1
        array.push(signal_prices, close)

else if current_state == STATE_BULLISH
    if enter_warning
        current_state := STATE_WARNING
    else if exit_to_neutral or distance < -threshold
        current_state := STATE_NEUTRAL
        entry_price := na

else if current_state == STATE_BEARISH
    if enter_warning
        current_state := STATE_WARNING
    else if exit_to_neutral or distance > threshold
        current_state := STATE_NEUTRAL
        entry_price := na

else if current_state == STATE_WARNING
    if exit_to_neutral
        current_state := STATE_NEUTRAL
        entry_price := na

// Keep signal history manageable
if array.size(signal_prices) > 50
    array.shift(signal_prices)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               STATE VISUALIZATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Plot EMA with state-based color
state_color = switch current_state
    STATE_BULLISH => color.green
    STATE_BEARISH => color.red
    STATE_WARNING => color.orange
    => color.gray

plot(ema, "EMA", state_color, 2)

// State change markers
state_changed = ta.change(current_state) != 0
plotshape(state_changed, style=shape.diamond, 
    location=location.abovebar, color=state_color, size=size.small)

// Background color based on state
bg_color = switch current_state
    STATE_BULLISH => color.new(color.green, 95)
    STATE_BEARISH => color.new(color.red, 95)
    STATE_WARNING => color.new(color.orange, 95)
    => na

bgcolor(bg_color, title="State Background")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  STATE TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var table state_table = table.new(position.bottom_right, 2, 7)

if barstate.islast
    table.clear(state_table, 0, 0, 1, 6)
    
    table.cell(state_table, 0, 0, "State Monitor", 
        bgcolor=color.navy, text_color=color.white)
    table.cell(state_table, 1, 0, "", bgcolor=color.navy)
    
    table.cell(state_table, 0, 1, "Current State")
    table.cell(state_table, 1, 1, current_state, text_color=state_color)
    
    table.cell(state_table, 0, 2, "Entry Price")
    table.cell(state_table, 1, 2, na(entry_price) ? "N/A" : str.tostring(entry_price, "0.00"))
    
    table.cell(state_table, 0, 3, "Distance %")
    table.cell(state_table, 1, 3, str.tostring(distance, "0.00") + "%")
    
    table.cell(state_table, 0, 4, "RSI")
    table.cell(state_table, 1, 4, str.tostring(rsi, "0.0"))
    
    table.cell(state_table, 0, 5, "Signal Count")
    table.cell(state_table, 1, 5, str.tostring(signal_count))
    
    table.cell(state_table, 0, 6, "Bars in State")
    bars_in_state = current_state != STATE_NEUTRAL ? bar_index - entry_bar : 0
    table.cell(state_table, 1, 6, str.tostring(bars_in_state))
```

## Best Practices Summary

### 1. Structure Organization
- Use clear section separators with comments
- Group related inputs logically
- Organize calculations from basic to advanced
- Place plotting after all calculations

### 2. Input Management
- Use meaningful group names and tooltips
- Validate input ranges
- Provide sensible defaults
- Use input-dependent logic for dynamic behavior

### 3. Calculation Efficiency
- Avoid redundant calculations
- Use series efficiently
- Cache expensive calculations
- Handle edge cases and `na` values

### 4. Visual Design
- Use consistent color schemes
- Provide toggle options for visual elements
- Implement proper scaling and positioning
- Add debug modes for development

### 5. Alert Implementation
- Provide comprehensive alert messages
- Use proper alert frequencies
- Include relevant context in messages
- Test alert conditions thoroughly

This comprehensive guide provides agents with professional templates and patterns for creating high-quality Pine Script v6 indicators.