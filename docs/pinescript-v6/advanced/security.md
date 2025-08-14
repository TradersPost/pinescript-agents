# Pine Script v6 Request.Security() Comprehensive Guide

The `request.security()` function is one of the most powerful features in Pine Script v6, enabling access to data from different symbols, timeframes, and data types. This guide covers everything from basic usage to advanced patterns.

## Table of Contents
1. [Request.Security() Overview](#requestsecurity-overview)
2. [Avoiding Repainting with Lookahead](#avoiding-repainting-with-lookahead)
3. [Multiple Timeframe Data](#multiple-timeframe-data)
4. [Multiple Symbol Data](#multiple-symbol-data)
5. [Lower Timeframe Data Access](#lower-timeframe-data-access)
6. [Security Function Limits](#security-function-limits)
7. [Common Patterns and Examples](#common-patterns-and-examples)
8. [Advanced Techniques](#advanced-techniques)

---

## Request.Security() Overview

### Basic Syntax
```pinescript
request.security(symbol, timeframe, expression, 
    gaps=barmerge.gaps_off, 
    lookahead=barmerge.lookahead_off, 
    ignore_invalid_symbol=false,
    currency=syminfo.currency)
```

### Parameters Explained
- **symbol**: The symbol identifier (ticker)
- **timeframe**: The timeframe to request data from
- **expression**: The data/calculation to retrieve
- **gaps**: How to handle gaps in data
- **lookahead**: Controls repainting behavior
- **ignore_invalid_symbol**: Handle invalid symbols gracefully
- **currency**: Currency conversion for multi-currency data

### Basic Examples

#### Simple Higher Timeframe Close
```pinescript
//@version=6
indicator("HTF Close Example", overlay=true)

// Get daily close on any timeframe
daily_close = request.security(syminfo.tickerid, "1D", close)
plot(daily_close, "Daily Close", color.blue, 2)

// Current timeframe close for comparison
plot(close, "Current Close", color.gray, 1)
```

#### Multiple Data Points
```pinescript
//@version=6
indicator("Multiple HTF Data", overlay=true)

// Get multiple OHLC values from 4-hour timeframe
[htf_open, htf_high, htf_low, htf_close] = request.security(
    syminfo.tickerid, "240", [open, high, low, close])

// Plot HTF candle levels
plot(htf_open, "4H Open", color.yellow)
plot(htf_high, "4H High", color.green)
plot(htf_low, "4H Low", color.red)
plot(htf_close, "4H Close", color.blue, 2)
```

---

## Avoiding Repainting with Lookahead

### Understanding Repainting
Repainting occurs when historical and real-time calculations differ, causing indicators to "repaint" their past values as new data becomes available.

### The Lookahead Problem
```pinescript
//@version=6
indicator("Repainting Example", overlay=true)

// ❌ THIS REPAINTS - Gets future data in historical calculations
repainting_daily = request.security(syminfo.tickerid, "1D", close)

// ✅ NON-REPAINTING - Uses confirmed data only
non_repainting_daily = request.security(syminfo.tickerid, "1D", close[1])

// ✅ NON-REPAINTING - Uses lookahead_on (for specific cases)
lookahead_daily = request.security(syminfo.tickerid, "1D", close, 
    lookahead=barmerge.lookahead_on)

plot(repainting_daily, "Repainting", color.red)
plot(non_repainting_daily, "Non-Repainting", color.green)
plot(lookahead_daily, "Lookahead", color.blue)
```

### Lookahead Settings Explained

#### barmerge.lookahead_off (Default)
- Safe for real-time trading
- May show different historical vs real-time values
- Recommended for most use cases

#### barmerge.lookahead_on
- Consistent historical and real-time values
- **WARNING**: Uses future data in backtesting
- Only use for display purposes, never for trading logic

### Professional Non-Repainting Patterns

#### Pattern 1: Historical Offset
```pinescript
//@version=6
indicator("Non-Repainting HTF", overlay=true)

// Function to get confirmed HTF data
get_htf_confirmed(tf, expression) =>
    request.security(syminfo.tickerid, tf, expression[1], 
        lookahead=barmerge.lookahead_off)

// Get confirmed higher timeframe data
htf_close = get_htf_confirmed("1D", close)
htf_sma = get_htf_confirmed("1D", ta.sma(close, 20))
htf_rsi = get_htf_confirmed("1D", ta.rsi(close, 14))

plot(htf_close, "HTF Close", color.blue)
plot(htf_sma, "HTF SMA", color.orange)
```

#### Pattern 2: Barstate Confirmation
```pinescript
//@version=6
indicator("Barstate Confirmation", overlay=true)

// Only use confirmed bars for HTF data
get_confirmed_htf(tf, expression) =>
    request.security(syminfo.tickerid, tf, 
        barstate.isconfirmed ? expression : expression[1])

htf_value = get_confirmed_htf("4H", ta.ema(close, 21))
plot(htf_value, "Confirmed HTF EMA", color.purple, 2)
```

#### Pattern 3: Session-Based Confirmation
```pinescript
//@version=6
indicator("Session Confirmation", overlay=true)

// Get data only after session close
get_session_confirmed(tf, expression) =>
    [_value, _time] = request.security(syminfo.tickerid, tf, [expression, time])
    var float confirmed_value = na
    
    // Check if we have a new completed session
    if ta.change(_time) != 0
        confirmed_value := _value[1]
    
    confirmed_value

daily_confirmed = get_session_confirmed("1D", ta.vwap)
plot(daily_confirmed, "Session Confirmed VWAP", color.yellow, 2)
```

---

## Multiple Timeframe Data

### Comprehensive Multi-Timeframe Analysis
```pinescript
//@version=6
indicator("Multi-Timeframe Analysis", "MTA", overlay=false, precision=2)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                    INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

source = input.source(close, "Source")
ma_length = input.int(20, "MA Length", minval=1)
rsi_length = input.int(14, "RSI Length", minval=1)

// Timeframe inputs
tf1 = input.timeframe("5", "Timeframe 1", group="Timeframes")
tf2 = input.timeframe("15", "Timeframe 2", group="Timeframes") 
tf3 = input.timeframe("60", "Timeframe 3", group="Timeframes")
tf4 = input.timeframe("240", "Timeframe 4", group="Timeframes")
tf5 = input.timeframe("1D", "Timeframe 5", group="Timeframes")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              MULTI-TIMEFRAME FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to get multiple indicators from any timeframe
get_mtf_indicators(tf) =>
    request.security(syminfo.tickerid, tf, [
        ta.ema(source, ma_length),          // EMA
        ta.rsi(source, rsi_length),         // RSI
        ta.macd(source, 12, 26, 9)[0],      // MACD Line
        ta.macd(source, 12, 26, 9)[1],      // MACD Signal
        ta.atr(14),                         // ATR
        ta.change(source) > 0,              // Bullish bar
        ta.sma(volume, 20),                 // Volume SMA
        source                              // Current price
    ], lookahead=barmerge.lookahead_off)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 GET MTF DATA
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Get data from all timeframes
[tf1_ema, tf1_rsi, tf1_macd, tf1_signal, tf1_atr, tf1_bull, tf1_vol, tf1_price] = get_mtf_indicators(tf1)
[tf2_ema, tf2_rsi, tf2_macd, tf2_signal, tf2_atr, tf2_bull, tf2_vol, tf2_price] = get_mtf_indicators(tf2)
[tf3_ema, tf3_rsi, tf3_macd, tf3_signal, tf3_atr, tf3_bull, tf3_vol, tf3_price] = get_mtf_indicators(tf3)
[tf4_ema, tf4_rsi, tf4_macd, tf4_signal, tf4_atr, tf4_bull, tf4_vol, tf4_price] = get_mtf_indicators(tf4)
[tf5_ema, tf5_rsi, tf5_macd, tf5_signal, tf5_atr, tf5_bull, tf5_vol, tf5_price] = get_mtf_indicators(tf5)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               TREND ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Trend determination for each timeframe
tf1_trend = tf1_price > tf1_ema ? 1 : -1
tf2_trend = tf2_price > tf2_ema ? 1 : -1
tf3_trend = tf3_price > tf3_ema ? 1 : -1
tf4_trend = tf4_price > tf4_ema ? 1 : -1
tf5_trend = tf5_price > tf5_ema ? 1 : -1

// Overall trend alignment score
trend_alignment = tf1_trend + tf2_trend + tf3_trend + tf4_trend + tf5_trend
trend_strength = math.abs(trend_alignment) / 5 * 100

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Plot RSI values from different timeframes
plot(tf1_rsi, "TF1 RSI", color.blue, 1)
plot(tf2_rsi, "TF2 RSI", color.green, 1)
plot(tf3_rsi, "TF3 RSI", color.orange, 1)
plot(tf4_rsi, "TF4 RSI", color.red, 1)
plot(tf5_rsi, "TF5 RSI", color.purple, 2)

// Horizontal reference lines
hline(70, "Overbought", color.red, hline.style_dashed)
hline(50, "Midline", color.gray, hline.style_dotted)
hline(30, "Oversold", color.green, hline.style_dashed)

// Background color based on trend alignment
bg_color = trend_alignment > 3 ? color.new(color.green, 95) :
           trend_alignment < -3 ? color.new(color.red, 95) : na
bgcolor(bg_color, title="Trend Alignment")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               MTF TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var table mtf_table = table.new(position.top_right, 6, 7)

if barstate.islast
    table.clear(mtf_table, 0, 0, 5, 6)
    
    // Headers
    table.cell(mtf_table, 0, 0, "TF", bgcolor=color.gray, text_color=color.white)
    table.cell(mtf_table, 1, 0, "Trend", bgcolor=color.gray, text_color=color.white)
    table.cell(mtf_table, 2, 0, "RSI", bgcolor=color.gray, text_color=color.white)
    table.cell(mtf_table, 3, 0, "MACD", bgcolor=color.gray, text_color=color.white)
    table.cell(mtf_table, 4, 0, "Price", bgcolor=color.gray, text_color=color.white)
    table.cell(mtf_table, 5, 0, "ATR", bgcolor=color.gray, text_color=color.white)
    
    // Data arrays for easier iteration
    timeframes = array.from(tf1, tf2, tf3, tf4, tf5)
    trends = array.from(tf1_trend, tf2_trend, tf3_trend, tf4_trend, tf5_trend)
    rsis = array.from(tf1_rsi, tf2_rsi, tf3_rsi, tf4_rsi, tf5_rsi)
    macds = array.from(tf1_macd, tf2_macd, tf3_macd, tf4_macd, tf5_macd)
    prices = array.from(tf1_price, tf2_price, tf3_price, tf4_price, tf5_price)
    atrs = array.from(tf1_atr, tf2_atr, tf3_atr, tf4_atr, tf5_atr)
    
    for i = 0 to 4
        row = i + 1
        trend_val = array.get(trends, i)
        
        table.cell(mtf_table, 0, row, array.get(timeframes, i))
        table.cell(mtf_table, 1, row, trend_val > 0 ? "↑" : "↓", 
            text_color=trend_val > 0 ? color.green : color.red)
        table.cell(mtf_table, 2, row, str.tostring(array.get(rsis, i), "0.0"))
        table.cell(mtf_table, 3, row, str.tostring(array.get(macds, i), "0.00"))
        table.cell(mtf_table, 4, row, str.tostring(array.get(prices, i), "0.00"))
        table.cell(mtf_table, 5, row, str.tostring(array.get(atrs, i), "0.00"))
```

---

## Multiple Symbol Data

### Cross-Symbol Analysis
```pinescript
//@version=6
indicator("Multi-Symbol Analysis", "MSA", overlay=false)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   SYMBOL INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Related symbols for analysis
symbol1 = input.symbol("SPY", "Symbol 1", group="Symbols")
symbol2 = input.symbol("QQQ", "Symbol 2", group="Symbols")
symbol3 = input.symbol("IWM", "Symbol 3", group="Symbols")
symbol4 = input.symbol("DIA", "Symbol 4", group="Symbols")

// Analysis settings
rsi_length = input.int(14, "RSI Length", group="Settings")
ma_length = input.int(20, "MA Length", group="Settings")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              MULTI-SYMBOL FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Function to get symbol data
get_symbol_data(symbol) =>
    request.security(symbol, timeframe.period, [
        close,                              // Current price
        ta.rsi(close, rsi_length),         // RSI
        ta.ema(close, ma_length),          // EMA
        ta.change(close),                  // Price change
        volume,                            // Volume
        ta.atr(14)                         // ATR
    ], lookahead=barmerge.lookahead_off)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                GET SYMBOL DATA
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Get data for all symbols
[s1_price, s1_rsi, s1_ema, s1_change, s1_volume, s1_atr] = get_symbol_data(symbol1)
[s2_price, s2_rsi, s2_ema, s2_change, s2_volume, s2_atr] = get_symbol_data(symbol2)
[s3_price, s3_rsi, s3_ema, s3_change, s3_volume, s3_atr] = get_symbol_data(symbol3)
[s4_price, s4_rsi, s4_ema, s4_change, s4_volume, s4_atr] = get_symbol_data(symbol4)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                            CORRELATION ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Calculate correlations between symbols
correlation_window = 50

// Price change correlations
s1_s2_corr = ta.correlation(s1_change, s2_change, correlation_window)
s1_s3_corr = ta.correlation(s1_change, s3_change, correlation_window)
s1_s4_corr = ta.correlation(s1_change, s4_change, correlation_window)

// Average correlation
avg_correlation = (math.abs(s1_s2_corr) + math.abs(s1_s3_corr) + math.abs(s1_s4_corr)) / 3

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              SECTOR STRENGTH
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Relative strength calculations
s1_rs = (s1_price - s1_ema) / s1_ema * 100
s2_rs = (s2_price - s2_ema) / s2_ema * 100
s3_rs = (s3_price - s3_ema) / s3_ema * 100
s4_rs = (s4_price - s4_ema) / s4_ema * 100

// Find strongest and weakest
strongest_rs = math.max(s1_rs, math.max(s2_rs, math.max(s3_rs, s4_rs)))
weakest_rs = math.min(s1_rs, math.min(s2_rs, math.min(s3_rs, s4_rs)))

// Determine which symbol is strongest/weakest
strongest_symbol = s1_rs == strongest_rs ? "S1" : 
                   s2_rs == strongest_rs ? "S2" : 
                   s3_rs == strongest_rs ? "S3" : "S4"

weakest_symbol = s1_rs == weakest_rs ? "S1" : 
                 s2_rs == weakest_rs ? "S2" : 
                 s3_rs == weakest_rs ? "S3" : "S4"

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Plot relative strength
plot(s1_rs, "Symbol 1 RS", color.blue, 2)
plot(s2_rs, "Symbol 2 RS", color.green, 2)
plot(s3_rs, "Symbol 3 RS", color.orange, 2)
plot(s4_rs, "Symbol 4 RS", color.red, 2)

// Zero line
hline(0, "Zero Line", color.gray, hline.style_dashed)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              SYMBOL TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var table symbol_table = table.new(position.top_left, 5, 6)

if barstate.islast
    table.clear(symbol_table, 0, 0, 4, 5)
    
    // Headers
    table.cell(symbol_table, 0, 0, "Symbol", bgcolor=color.navy, text_color=color.white)
    table.cell(symbol_table, 1, 0, "Price", bgcolor=color.navy, text_color=color.white)
    table.cell(symbol_table, 2, 0, "RSI", bgcolor=color.navy, text_color=color.white)
    table.cell(symbol_table, 3, 0, "RS%", bgcolor=color.navy, text_color=color.white)
    table.cell(symbol_table, 4, 0, "Trend", bgcolor=color.navy, text_color=color.white)
    
    // Symbol arrays
    symbols = array.from(symbol1, symbol2, symbol3, symbol4)
    prices = array.from(s1_price, s2_price, s3_price, s4_price)
    rsis = array.from(s1_rsi, s2_rsi, s3_rsi, s4_rsi)
    rs_values = array.from(s1_rs, s2_rs, s3_rs, s4_rs)
    
    for i = 0 to 3
        row = i + 1
        rs_val = array.get(rs_values, i)
        rsi_val = array.get(rsis, i)
        
        # Get symbol name without exchange
        symbol_name = str.split(array.get(symbols, i), ":")[1] ?? array.get(symbols, i)
        
        table.cell(symbol_table, 0, row, symbol_name)
        table.cell(symbol_table, 1, row, str.tostring(array.get(prices, i), "0.00"))
        table.cell(symbol_table, 2, row, str.tostring(rsi_val, "0.0"),
            text_color=rsi_val > 70 ? color.red : rsi_val < 30 ? color.green : color.gray)
        table.cell(symbol_table, 3, row, str.tostring(rs_val, "0.1") + "%",
            text_color=rs_val > 0 ? color.green : color.red)
        table.cell(symbol_table, 4, row, rs_val > 0 ? "↑" : "↓",
            text_color=rs_val > 0 ? color.green : color.red)
```

---

## Lower Timeframe Data Access

### Intraday Analysis from Higher Timeframes
```pinescript
//@version=6
indicator("Lower Timeframe Analysis", "LTA", overlay=true)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  LTF INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Only works when current timeframe is higher than requested
ltf_timeframe = input.timeframe("1", "Lower Timeframe", group="LTF Settings")
ltf_source = input.source(close, "LTF Source", group="LTF Settings")
show_ltf_data = input.bool(true, "Show LTF Data", group="LTF Settings")

// Analysis settings
ltf_ma_length = input.int(20, "LTF MA Length", group="Analysis")
ltf_volume_threshold = input.float(1.5, "Volume Threshold", group="Analysis")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               LTF FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Check if LTF is valid (must be lower than current timeframe)
is_ltf_valid() =>
    current_tf_seconds = timeframe.in_seconds("")
    ltf_seconds = timeframe.in_seconds(ltf_timeframe)
    ltf_seconds < current_tf_seconds

// Function to get LTF data arrays
get_ltf_data() =>
    if not is_ltf_valid()
        [array.new<float>(0), array.new<float>(0), array.new<float>(0)]
    else
        request.security_lower_tf(syminfo.tickerid, ltf_timeframe, [
            ltf_source,                     // Price data
            volume,                         // Volume data
            ta.ema(ltf_source, ltf_ma_length)  // EMA data
        ])

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                LTF ANALYSIS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Get LTF data arrays
[ltf_prices, ltf_volumes, ltf_emas] = get_ltf_data()

// Analyze LTF data
var float ltf_high = na
var float ltf_low = na
var float ltf_avg_volume = na
var int ltf_bull_bars = 0
var int ltf_bear_bars = 0
var int ltf_total_bars = 0

if show_ltf_data and array.size(ltf_prices) > 0
    # Reset values
    ltf_high := array.max(ltf_prices)
    ltf_low := array.min(ltf_prices)
    ltf_total_bars := array.size(ltf_prices)
    ltf_bull_bars := 0
    ltf_bear_bars := 0
    
    # Calculate average volume
    ltf_avg_volume := array.avg(ltf_volumes)
    
    # Count bullish/bearish bars
    for i = 1 to array.size(ltf_prices) - 1
        current_price = array.get(ltf_prices, i)
        prev_price = array.get(ltf_prices, i - 1)
        
        if current_price > prev_price
            ltf_bull_bars := ltf_bull_bars + 1
        else if current_price < prev_price
            ltf_bear_bars := ltf_bear_bars + 1

// Calculate LTF statistics
ltf_bull_percentage = ltf_total_bars > 0 ? (ltf_bull_bars / ltf_total_bars) * 100 : 0
ltf_bear_percentage = ltf_total_bars > 0 ? (ltf_bear_bars / ltf_total_bars) * 100 : 0
ltf_range = ltf_high - ltf_low
ltf_range_pct = ltf_low > 0 ? (ltf_range / ltf_low) * 100 : 0

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                LTF PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Plot LTF high/low levels
plot(show_ltf_data ? ltf_high : na, "LTF High", color.green, 1, plot.style_stepline)
plot(show_ltf_data ? ltf_low : na, "LTF Low", color.red, 1, plot.style_stepline)

// Fill between high and low
fill_high = plot(show_ltf_data ? ltf_high : na, display=display.none)
fill_low = plot(show_ltf_data ? ltf_low : na, display=display.none)
fill(fill_high, fill_low, color.new(color.blue, 95), "LTF Range")

// Current timeframe data for comparison
plot(high, "HTF High", color.new(color.green, 50), 2)
plot(low, "HTF Low", color.new(color.red, 50), 2)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                LTF TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var table ltf_table = table.new(position.bottom_left, 2, 8)

if show_ltf_data and barstate.islast
    table.clear(ltf_table, 0, 0, 1, 7)
    
    table.cell(ltf_table, 0, 0, "LTF Analysis", 
        bgcolor=color.blue, text_color=color.white)
    table.cell(ltf_table, 1, 0, ltf_timeframe, 
        bgcolor=color.blue, text_color=color.white)
    
    table.cell(ltf_table, 0, 1, "Total Bars")
    table.cell(ltf_table, 1, 1, str.tostring(ltf_total_bars))
    
    table.cell(ltf_table, 0, 2, "Bull Bars")
    table.cell(ltf_table, 1, 2, str.tostring(ltf_bull_bars) + " (" + 
        str.tostring(ltf_bull_percentage, "0.0") + "%)",
        text_color=color.green)
    
    table.cell(ltf_table, 0, 3, "Bear Bars")
    table.cell(ltf_table, 1, 3, str.tostring(ltf_bear_bars) + " (" + 
        str.tostring(ltf_bear_percentage, "0.0") + "%)",
        text_color=color.red)
    
    table.cell(ltf_table, 0, 4, "High")
    table.cell(ltf_table, 1, 4, str.tostring(ltf_high, "0.00"))
    
    table.cell(ltf_table, 0, 5, "Low")
    table.cell(ltf_table, 1, 5, str.tostring(ltf_low, "0.00"))
    
    table.cell(ltf_table, 0, 6, "Range")
    table.cell(ltf_table, 1, 6, str.tostring(ltf_range, "0.00") + " (" + 
        str.tostring(ltf_range_pct, "0.1") + "%)")
    
    table.cell(ltf_table, 0, 7, "Avg Volume")
    table.cell(ltf_table, 1, 7, str.tostring(ltf_avg_volume, "0"))
```

---

## Security Function Limits

### Understanding Limits and Optimization

#### Pine Script v6 Limits
- **Maximum 40 security calls per script**
- **Request.security() calls are expensive**
- **Lower timeframe calls use more resources**
- **Each symbol/timeframe combination counts as separate call**

### Optimization Strategies

#### Strategy 1: Batch Multiple Values
```pinescript
//@version=6
indicator("Efficient Security Calls", overlay=true)

// ❌ INEFFICIENT - Multiple separate calls
// htf_close = request.security(syminfo.tickerid, "1D", close)
// htf_high = request.security(syminfo.tickerid, "1D", high)
// htf_low = request.security(syminfo.tickerid, "1D", low)
// htf_volume = request.security(syminfo.tickerid, "1D", volume)

// ✅ EFFICIENT - Single call with tuple
[htf_close, htf_high, htf_low, htf_volume] = request.security(
    syminfo.tickerid, "1D", [close, high, low, volume])

// ✅ EFFICIENT - Batch calculations
[htf_sma, htf_ema, htf_rsi] = request.security(
    syminfo.tickerid, "1D", [
        ta.sma(close, 20),
        ta.ema(close, 20), 
        ta.rsi(close, 14)
    ])

plot(htf_close, "Daily Close", color.blue)
plot(htf_sma, "Daily SMA", color.orange)
```

#### Strategy 2: Conditional Security Calls
```pinescript
//@version=6
indicator("Conditional Security", overlay=true)

// Only make security calls when needed
enable_htf = input.bool(true, "Enable Higher Timeframe")
htf_tf = input.timeframe("1D", "HTF Timeframe")

// Conditional security call
htf_data = enable_htf ? 
    request.security(syminfo.tickerid, htf_tf, [close, ta.sma(close, 20)]) : 
    [close, ta.sma(close, 20)]

[htf_close, htf_sma] = htf_data

plot(htf_close, "HTF Close", enable_htf ? color.blue : color.gray)
plot(htf_sma, "HTF SMA", enable_htf ? color.orange : color.gray)
```

#### Strategy 3: Smart Caching
```pinescript
//@version=6
indicator("Security Caching", overlay=true)

// Cache expensive calculations
var cached_data = array.new<float>(0)
var int last_cache_update = 0
cache_interval = 10  // Update every 10 bars

// Only update cache periodically
should_update_cache = bar_index - last_cache_update >= cache_interval

if should_update_cache
    # Expensive multi-symbol analysis
    symbols = array.from("SPY", "QQQ", "IWM")
    
    array.clear(cached_data)
    for i = 0 to array.size(symbols) - 1
        symbol = array.get(symbols, i)
        symbol_rsi = request.security(symbol, timeframe.period, ta.rsi(close, 14))
        array.push(cached_data, symbol_rsi)
    
    last_cache_update := bar_index

// Use cached data
spy_rsi = array.size(cached_data) > 0 ? array.get(cached_data, 0) : 50
qqq_rsi = array.size(cached_data) > 1 ? array.get(cached_data, 1) : 50
iwm_rsi = array.size(cached_data) > 2 ? array.get(cached_data, 2) : 50

plot(spy_rsi, "SPY RSI", color.blue)
plot(qqq_rsi, "QQQ RSI", color.green)
plot(iwm_rsi, "IWM RSI", color.red)
```

---

## Common Patterns and Examples

### Pattern 1: Multi-Timeframe Trend Alignment
```pinescript
//@version=6
indicator("MTF Trend Alignment", overlay=true)

// Define timeframes for analysis
tf_short = "5"
tf_medium = "15" 
tf_long = "60"

// Get trend data from multiple timeframes
get_trend_data(tf) =>
    [price, ema_fast, ema_slow] = request.security(syminfo.tickerid, tf, 
        [close, ta.ema(close, 10), ta.ema(close, 30)])
    
    # Determine trend
    trend = price > ema_fast and ema_fast > ema_slow ? 1 : 
            price < ema_fast and ema_fast < ema_slow ? -1 : 0
    [trend, price, ema_fast, ema_slow]

// Get trends from all timeframes
[short_trend, short_price, short_fast, short_slow] = get_trend_data(tf_short)
[medium_trend, medium_price, medium_fast, medium_slow] = get_trend_data(tf_medium)
[long_trend, long_price, long_fast, long_slow] = get_trend_data(tf_long)

// Calculate alignment
trend_alignment = short_trend + medium_trend + long_trend
is_bullish_aligned = trend_alignment >= 2
is_bearish_aligned = trend_alignment <= -2

// Visual representation
plot(short_fast, "Short TF Fast", color.blue, 1)
plot(medium_fast, "Medium TF Fast", color.orange, 1)
plot(long_fast, "Long TF Fast", color.red, 2)

// Alignment signals
bgcolor(is_bullish_aligned ? color.new(color.green, 90) : 
        is_bearish_aligned ? color.new(color.red, 90) : na)

plotshape(is_bullish_aligned and not is_bullish_aligned[1], 
    style=shape.triangleup, location=location.belowbar, 
    color=color.green, size=size.small)
plotshape(is_bearish_aligned and not is_bearish_aligned[1], 
    style=shape.triangledown, location=location.abovebar, 
    color=color.red, size=size.small)
```

### Pattern 2: Cross-Market Analysis
```pinescript
//@version=6
indicator("Cross-Market Analysis", overlay=false)

// Market indices
sp500 = "SPX"
nasdaq = "NDX" 
russell = "RUT"
vix = "VIX"

// Get market data
[spx_price, spx_rsi] = request.security(sp500, timeframe.period, 
    [close, ta.rsi(close, 14)])
[ndx_price, ndx_rsi] = request.security(nasdaq, timeframe.period, 
    [close, ta.rsi(close, 14)])
[rut_price, rut_rsi] = request.security(russell, timeframe.period, 
    [close, ta.rsi(close, 14)])
[vix_price, vix_change] = request.security(vix, timeframe.period, 
    [close, ta.change(close)])

// Market breadth calculation
market_rsi_avg = (spx_rsi + ndx_rsi + rut_rsi) / 3
market_strength = market_rsi_avg > 50 ? 1 : -1

// Fear/Greed indicator based on VIX
fear_greed = vix_price > 30 ? -1 : vix_price < 20 ? 1 : 0

// Combined market signal
market_signal = market_strength + fear_greed

// Plot market breadth
plot(market_rsi_avg, "Market RSI Average", color.blue, 2)
plot(spx_rsi, "S&P 500 RSI", color.green, 1)
plot(ndx_rsi, "NASDAQ RSI", color.orange, 1)
plot(rut_rsi, "Russell RSI", color.red, 1)

hline(50, "Neutral", color.gray)
hline(70, "Overbought", color.red)
hline(30, "Oversold", color.green)

// Background based on market signal
bgcolor(market_signal > 1 ? color.new(color.green, 95) :
        market_signal < -1 ? color.new(color.red, 95) : na)
```

### Pattern 3: Economic Calendar Integration
```pinescript
//@version=6
indicator("Economic Data Integration", overlay=true)

// Economic symbols (examples)
dxy = "DXY"  // Dollar Index
gold = "GOLD"
oil = "USOIL"
bonds = "US10Y"

// Get economic data
[dxy_price, dxy_change] = request.security(dxy, timeframe.period, 
    [close, ta.change(close, 5)])
[gold_price, gold_change] = request.security(gold, timeframe.period, 
    [close, ta.change(close, 5)])
[oil_price, oil_change] = request.security(oil, timeframe.period, 
    [close, ta.change(close, 5)])
[bond_yield, bond_change] = request.security(bonds, timeframe.period, 
    [close, ta.change(close, 5)])

// Risk-on/Risk-off calculation
risk_on_score = 0
risk_on_score := risk_on_score + (dxy_change < 0 ? 1 : -1)  // Weak dollar = risk on
risk_on_score := risk_on_score + (gold_change < 0 ? 1 : -1) // Gold down = risk on
risk_on_score := risk_on_score + (oil_change > 0 ? 1 : -1)  // Oil up = risk on
risk_on_score := risk_on_score + (bond_change > 0 ? 1 : -1) // Yields up = risk on

// Market regime
market_regime = risk_on_score > 2 ? "RISK ON" : 
                risk_on_score < -2 ? "RISK OFF" : "NEUTRAL"

// Visual indication
regime_color = risk_on_score > 2 ? color.green : 
               risk_on_score < -2 ? color.red : color.gray

plot(close, "Price", color.gray, 1)
bgcolor(color.new(regime_color, 95))

// Table showing economic data
var table econ_table = table.new(position.top_right, 3, 6)

if barstate.islast
    table.clear(econ_table, 0, 0, 2, 5)
    
    table.cell(econ_table, 0, 0, "Economic Data", 
        bgcolor=color.navy, text_color=color.white)
    table.cell(econ_table, 1, 0, "Price", 
        bgcolor=color.navy, text_color=color.white)
    table.cell(econ_table, 2, 0, "Change", 
        bgcolor=color.navy, text_color=color.white)
    
    table.cell(econ_table, 0, 1, "DXY")
    table.cell(econ_table, 1, 1, str.tostring(dxy_price, "0.00"))
    table.cell(econ_table, 2, 1, str.tostring(dxy_change, "0.00"),
        text_color=dxy_change > 0 ? color.green : color.red)
    
    table.cell(econ_table, 0, 2, "GOLD")
    table.cell(econ_table, 1, 2, str.tostring(gold_price, "0.00"))
    table.cell(econ_table, 2, 2, str.tostring(gold_change, "0.00"),
        text_color=gold_change > 0 ? color.green : color.red)
    
    table.cell(econ_table, 0, 3, "OIL")
    table.cell(econ_table, 1, 3, str.tostring(oil_price, "0.00"))
    table.cell(econ_table, 2, 3, str.tostring(oil_change, "0.00"),
        text_color=oil_change > 0 ? color.green : color.red)
    
    table.cell(econ_table, 0, 4, "US10Y")
    table.cell(econ_table, 1, 4, str.tostring(bond_yield, "0.00"))
    table.cell(econ_table, 2, 4, str.tostring(bond_change, "0.00"),
        text_color=bond_change > 0 ? color.green : color.red)
    
    table.cell(econ_table, 0, 5, "Regime")
    table.cell(econ_table, 1, 5, market_regime, text_color=regime_color)
    table.cell(econ_table, 2, 5, str.tostring(risk_on_score), text_color=regime_color)
```

## Best Practices Summary

### 1. Repainting Prevention
- Always use `[1]` offset for confirmed data
- Understand the difference between `lookahead_on` and `lookahead_off`
- Test historical vs real-time behavior
- Document repainting behavior clearly

### 2. Performance Optimization
- Batch multiple values in single security calls
- Limit the number of security calls (max 40)
- Use conditional calls when possible
- Cache expensive calculations

### 3. Error Handling
- Check for valid symbols with `ignore_invalid_symbol`
- Handle `na` values appropriately
- Validate timeframe compatibility
- Provide fallbacks for missing data

### 4. Professional Implementation
- Use clear function names and documentation
- Organize code with proper sections
- Implement comprehensive error checking
- Provide user-friendly interfaces

This comprehensive guide provides agents with everything needed to implement sophisticated multi-timeframe and multi-symbol analysis using Pine Script v6's security functions.