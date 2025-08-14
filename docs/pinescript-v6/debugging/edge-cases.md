# Pine Script Edge Cases and Special Scenarios

This guide covers handling edge cases and special market scenarios that can cause unexpected behavior in Pine Script indicators and strategies.

## Table of Contents
- [First Bar Calculations](#first-bar-calculations)
- [Weekend and Holiday Gaps](#weekend-and-holiday-gaps)
- [Symbol Changes and Splits](#symbol-changes-and-splits)
- [Illiquid Market Handling](#illiquid-market-handling)
- [Pre/Post Market Data](#prepost-market-data)
- [Different Session Types](#different-session-types)
- [Timezone Considerations](#timezone-considerations)
- [Data Quality Issues](#data-quality-issues)
- [Broker Emulator Quirks](#broker-emulator-quirks)

## First Bar Calculations

The first bar often requires special handling due to lack of historical data:

### Basic First Bar Handling

```pinescript
//@version=6
indicator("First Bar Handling", overlay=true)

// Check for first bar
is_first_bar = barstate.isfirst

// Safe calculation that handles first bar
safe_sma(source, length) =>
    if bar_index < length - 1
        // Not enough data for full SMA
        ta.sma(source, bar_index + 1)
    else
        // Normal SMA calculation
        ta.sma(source, length)

// Handle previous value references safely
safe_previous_value(current_value) =>
    if barstate.isfirst
        current_value  // Use current value on first bar
    else
        current_value[1]  // Use previous value normally

// Example usage
length = input.int(20, "SMA Length")
sma_value = safe_sma(close, length)
prev_close = safe_previous_value(close)

plot(sma_value, "Safe SMA", color.blue)

// Advanced first bar detection
detect_data_start() =>
    var bool data_started = false
    var int first_valid_bar = na
    
    if not data_started and not na(close) and not na(volume)
        data_started := true
        first_valid_bar := bar_index
    
    [data_started, first_valid_bar]

[has_data, start_bar] = detect_data_start()

if not na(start_bar) and bar_index == start_bar
    label.new(bar_index, high, "Data Start", 
              style=label.style_label_down, color=color.blue)
```

### Initialization Patterns

```pinescript
//@version=6
indicator("Initialization Patterns", overlay=false)

// Pattern 1: Variable initialization
var float cumulative_volume = 0.0
var float max_price = 0.0
var int bars_processed = 0

// Pattern 2: Array initialization
var prices = array.new<float>()
var volumes = array.new<float>()

// Pattern 3: Conditional initialization
initialize_if_needed() =>
    if barstate.isfirst
        array.clear(prices)
        array.clear(volumes)
        cumulative_volume := 0.0
        max_price := high
        bars_processed := 0

initialize_if_needed()

// Update values safely
if not na(close)
    if barstate.isfirst or high > max_price
        max_price := high
    
    cumulative_volume += volume
    bars_processed += 1
    
    array.push(prices, close)
    array.push(volumes, volume)

plot(cumulative_volume, "Cumulative Volume", color.blue)
plot(max_price, "Max Price", color.red)

// Handle calculations that need multiple bars
rsi_safe = bar_index >= 14 ? ta.rsi(close, 14) : 50.0
macd_safe = bar_index >= 26 ? ta.macd(close, 12, 26, 9)[0] : 0.0

plot(rsi_safe, "Safe RSI", color.orange)
plot(macd_safe, "Safe MACD", color.purple)
```

## Weekend and Holiday Gaps

Handle gaps in trading data properly:

### Gap Detection and Handling

```pinescript
//@version=6
indicator("Gap Detection", overlay=true)

// Detect gaps in price data
detect_price_gap(gap_threshold_percent = 2.0) =>
    if barstate.isfirst
        false
    else
        price_gap = math.abs(open - close[1])
        gap_percentage = (price_gap / close[1]) * 100
        gap_percentage > gap_threshold_percent

// Detect time gaps (weekends, holidays)
detect_time_gap(max_gap_hours = 72) =>
    if barstate.isfirst
        false
    else
        time_diff = time - time[1]
        gap_hours = time_diff / (1000 * 60 * 60)
        gap_hours > max_gap_hours

gap_threshold = input.float(2.0, "Gap Threshold %", minval=0.1, maxval=10.0)
is_price_gap = detect_price_gap(gap_threshold)
is_time_gap = detect_time_gap()

// Mark gaps visually
if is_price_gap
    label.new(bar_index, high * 1.02, "Price Gap", 
              style=label.style_label_down, color=color.red, size=size.small)

if is_time_gap
    label.new(bar_index, low * 0.98, "Time Gap", 
              style=label.style_label_up, color=color.orange, size=size.small)

// Adjust calculations for gaps
gap_adjusted_change() =>
    if is_price_gap or is_time_gap
        0.0  // Ignore change across gaps
    else
        ta.change(close)

adjusted_momentum = gap_adjusted_change()
plot(adjusted_momentum, "Gap-Adjusted Momentum", color.blue)
```

### Weekend Gap Compensation

```pinescript
//@version=6
indicator("Weekend Gap Compensation", overlay=true)

// Identify market sessions
is_monday = dayofweek == dayofweek.monday
is_friday = dayofweek == dayofweek.friday

// Track weekend gaps
var float friday_close = na
var float monday_open = na
var float weekend_gap = na

if is_friday and barstate.isconfirmed
    friday_close := close

if is_monday and barstate.isconfirmed and not na(friday_close)
    monday_open := open
    weekend_gap := monday_open - friday_close

// Normalize indicators across weekend gaps
normalize_for_weekends(value) =>
    if is_monday and not na(weekend_gap) and math.abs(weekend_gap) > close * 0.01
        // Adjust for significant weekend gaps
        adjustment_factor = friday_close / monday_open
        value * adjustment_factor
    else
        value

// Apply normalization to technical indicators
normalized_rsi = normalize_for_weekends(ta.rsi(close, 14))
normalized_macd = normalize_for_weekends(ta.macd(close, 12, 26, 9)[0])

plot(normalized_rsi, "Weekend-Normalized RSI", color.blue)
plot(normalized_macd, "Weekend-Normalized MACD", color.red)

// Display weekend gap information
if is_monday and not na(weekend_gap)
    gap_percent = (weekend_gap / friday_close) * 100
    gap_text = str.format("Weekend Gap: {0}%", 
                         str.tostring(gap_percent, "#.##"))
    
    label.new(bar_index, high * 1.01, gap_text,
              style=label.style_label_down, 
              color = weekend_gap > 0 ? color.green : color.red)
```

## Symbol Changes and Splits

Handle corporate actions and symbol changes:

### Stock Split Detection

```pinescript
//@version=6
indicator("Split Detection", overlay=true)

// Detect potential stock splits
detect_split(split_threshold = 0.4) =>
    if barstate.isfirst
        [false, 0.0]
    else
        price_ratio = open / close[1]
        volume_ratio = volume / volume[1]
        
        // Check for split patterns
        is_split = false
        split_ratio = 0.0
        
        // 2:1 split detection (price halves, volume doubles)
        if price_ratio <= (1 - split_threshold) and volume_ratio >= 1.5
            is_split := true
            split_ratio := 0.5
        
        // 3:1 split detection  
        else if price_ratio <= 0.4 and volume_ratio >= 2.0
            is_split := true
            split_ratio := 0.33
        
        // 3:2 split detection
        else if price_ratio >= 0.6 and price_ratio <= 0.7 and volume_ratio >= 1.4
            is_split := true
            split_ratio := 0.67
        
        [is_split, split_ratio]

[is_split_detected, split_ratio] = detect_split()

// Adjust historical data for splits
var float split_adjustment = 1.0

if is_split_detected
    split_adjustment *= split_ratio
    
    label.new(bar_index, high * 1.05, 
              str.format("Split Detected: {0}:1", str.tostring(1/split_ratio, "#.#")),
              style=label.style_label_down, color=color.yellow, size=size.normal)

// Apply split adjustments to indicators
split_adjusted_close = close * split_adjustment
split_adjusted_sma = ta.sma(split_adjusted_close, 20)

plot(split_adjusted_sma, "Split-Adjusted SMA", color.blue)

// Dividend adjustment detection
detect_dividend(dividend_threshold = 0.02) =>
    if barstate.isfirst
        false
    else
        price_drop = (close[1] - open) / close[1]
        volume_increase = volume / volume[1]
        
        // Ex-dividend day pattern: price drops, volume increases
        price_drop > dividend_threshold and volume_increase > 1.2

is_ex_dividend = detect_dividend()

if is_ex_dividend
    label.new(bar_index, low * 0.95, "Ex-Dividend", 
              style=label.style_label_up, color=color.purple, size=size.small)
```

### Symbol Change Handling

```pinescript
//@version=6
indicator("Symbol Change Detection", overlay=true)

// Detect symbol changes or data quality issues
detect_symbol_change() =>
    var string last_symbol = na
    var bool symbol_changed = false
    
    current_symbol = syminfo.ticker
    
    if na(last_symbol)
        last_symbol := current_symbol
        symbol_changed := false
    else if last_symbol != current_symbol
        symbol_changed := true
        last_symbol := current_symbol
    else
        symbol_changed := false
    
    [symbol_changed, current_symbol]

[symbol_changed, current_symbol] = detect_symbol_change()

if symbol_changed
    label.new(bar_index, high * 1.1, 
              str.format("Symbol Changed: {0}", current_symbol),
              style=label.style_label_down, color=color.red, size=size.large)

// Reset calculations on symbol change
var float reset_sma = na
var bool calculation_reset = false

if symbol_changed and not calculation_reset
    reset_sma := close  // Reset to current price
    calculation_reset := true
else
    reset_sma := ta.sma(close, 20)
    calculation_reset := false

plot(reset_sma, "Reset-Safe SMA", color.green)
```

## Illiquid Market Handling

Handle low-volume and illiquid market conditions:

### Liquidity Detection

```pinescript
//@version=6
indicator("Liquidity Analysis", overlay=false)

// Define liquidity metrics
volume_lookback = input.int(20, "Volume Lookback Period")
liquidity_threshold = input.float(0.5, "Liquidity Threshold", minval=0.1, maxval=2.0)

// Calculate liquidity indicators
average_volume = ta.sma(volume, volume_lookback)
volume_ratio = volume / average_volume
spread_estimate = (high - low) / close

// Detect illiquid conditions
is_illiquid = volume_ratio < liquidity_threshold or spread_estimate > 0.05

// Adjust indicators for liquidity
liquidity_adjusted_rsi(source, length) =>
    if is_illiquid
        // Use longer period for illiquid markets
        ta.rsi(source, length * 2)
    else
        ta.rsi(source, length)

// Filter signals based on liquidity
filter_for_liquidity(signal) =>
    if is_illiquid
        false  // Don't trade in illiquid conditions
    else
        signal

rsi_value = liquidity_adjusted_rsi(close, 14)
buy_signal = ta.crossover(rsi_value, 30)
filtered_buy = filter_for_liquidity(buy_signal)

plot(rsi_value, "Liquidity-Adjusted RSI", color.blue)
plot(volume_ratio, "Volume Ratio", color.red)

bgcolor(is_illiquid ? color.new(color.red, 90) : na, title="Illiquid Periods")

// Display liquidity warnings
if is_illiquid and barstate.isconfirmed
    label.new(bar_index, rsi_value, "Low Liquidity", 
              style=label.style_label_left, color=color.orange, size=size.small)
```

### Volume Spike Handling

```pinescript
//@version=6
indicator("Volume Spike Handling", overlay=true)

// Detect volume spikes
volume_spike_threshold = input.float(3.0, "Volume Spike Threshold")
volume_average_period = input.int(20, "Volume Average Period")

avg_volume = ta.sma(volume, volume_average_period)
is_volume_spike = volume > avg_volume * volume_spike_threshold

// Handle volume spikes in calculations
volume_weighted_price() =>
    if is_volume_spike
        // Use volume-weighted price during spikes
        (high + low + close) / 3
    else
        close

vwp = volume_weighted_price()
vwp_sma = ta.sma(vwp, 14)

plot(vwp_sma, "Volume-Weighted SMA", color.purple)

// Mark volume spikes
if is_volume_spike
    label.new(bar_index, high * 1.02, 
              str.format("Volume: {0}x", str.tostring(volume/avg_volume, "#.#")),
              style=label.style_label_down, color=color.yellow, size=size.small)

// Adjust position sizing for volume spikes
calculate_position_size(base_size) =>
    if is_volume_spike
        base_size * 0.5  // Reduce size during spikes
    else
        base_size

base_position = 100
adjusted_position = calculate_position_size(base_position)
```

## Pre/Post Market Data

Handle extended trading hours data:

### Session Detection

```pinescript
//@version=6
indicator("Session Detection", overlay=true)

// Define trading sessions (US Eastern Time)
regular_session = session.regular
extended_session = session.extended

// Check current session
is_premarket = not na(time(timeframe.period, "0400-0930", "America/New_York"))
is_regular = not na(time(timeframe.period, "0930-1600", "America/New_York"))
is_afterhours = not na(time(timeframe.period, "1600-2000", "America/New_York"))

// Session-specific calculations
premarket_high = is_premarket ? math.max(nz(premarket_high[1]), high) : na
premarket_low = is_premarket ? math.min(nz(premarket_low[1], low), low) : na

regular_hours_volume = is_regular ? volume : 0
extended_hours_volume = (is_premarket or is_afterhours) ? volume : 0

// Reset session data
var float session_open = na
var float session_high = na
var float session_low = na

if is_regular and not is_regular[1]
    // Regular session start
    session_open := open
    session_high := high
    session_low := low
else if is_regular
    session_high := math.max(session_high, high)
    session_low := math.min(session_low, low)

// Visual session indicators
bgcolor(is_premarket ? color.new(color.blue, 95) : na, title="Pre-Market")
bgcolor(is_afterhours ? color.new(color.orange, 95) : na, title="After Hours")

plot(session_high, "Session High", color.green, linewidth=2)
plot(session_low, "Session Low", color.red, linewidth=2)

// Session transition labels
if is_regular and not is_regular[1]
    label.new(bar_index, high, "Market Open", 
              style=label.style_label_down, color=color.green)

if not is_regular and is_regular[1]
    label.new(bar_index, high, "Market Close", 
              style=label.style_label_down, color=color.red)
```

### Extended Hours Adjustments

```pinescript
//@version=6
indicator("Extended Hours Adjustments", overlay=false)

// Separate calculations for different sessions
calculate_rsi_by_session(source, length) =>
    var float regular_rsi = na
    var float extended_rsi = na
    
    if is_regular
        regular_rsi := ta.rsi(source, length)
    
    if is_premarket or is_afterhours
        extended_rsi := ta.rsi(source, length * 2)  // Longer period for extended hours
    
    is_regular ? regular_rsi : extended_rsi

session_adjusted_rsi = calculate_rsi_by_session(close, 14)

// Volume-adjusted calculations for extended hours
volume_adjusted_indicator() =>
    regular_vol_avg = ta.sma(regular_hours_volume, 20)
    extended_vol_avg = ta.sma(extended_hours_volume, 20)
    
    if is_regular and regular_vol_avg > 0
        volume / regular_vol_avg
    else if (is_premarket or is_afterhours) and extended_vol_avg > 0
        volume / extended_vol_avg
    else
        1.0

volume_strength = volume_adjusted_indicator()

plot(session_adjusted_rsi, "Session-Adjusted RSI", color.blue)
plot(volume_strength, "Volume Strength", color.red)

// Display current session
session_text = is_premarket ? "Pre-Market" : 
               is_regular ? "Regular" : 
               is_afterhours ? "After Hours" : "Closed"

if barstate.islast
    var table session_table = table.new(position.top_right, 2, 2, 
                                       bgcolor=color.new(color.black, 80))
    
    table.cell(session_table, 0, 0, "Session", text_color=color.white)
    table.cell(session_table, 1, 0, session_text, text_color=color.yellow)
    
    table.cell(session_table, 0, 1, "Volume Ratio", text_color=color.white)
    table.cell(session_table, 1, 1, str.tostring(volume_strength, "#.##"), text_color=color.yellow)
```

## Different Session Types

Handle various market session types:

### Multi-Market Session Handling

```pinescript
//@version=6
indicator("Multi-Market Sessions", overlay=true)

// Define major market sessions
tokyo_session = not na(time(timeframe.period, "2300-0800", "Asia/Tokyo"))
london_session = not na(time(timeframe.period, "0300-1200", "Europe/London"))
ny_session = not na(time(timeframe.period, "0930-1600", "America/New_York"))

// Session overlap detection
london_ny_overlap = london_session and ny_session
tokyo_london_overlap = tokyo_session and london_session

// Session-specific volatility
var float tokyo_atr = na
var float london_atr = na
var float ny_atr = na

if tokyo_session
    tokyo_atr := ta.atr(14)
if london_session
    london_atr := ta.atr(14)
if ny_session
    ny_atr := ta.atr(14)

// Current session volatility
current_session_atr = tokyo_session ? tokyo_atr :
                      london_session ? london_atr :
                      ny_session ? ny_atr : na

// Visual session indicators
session_color = tokyo_session ? color.new(color.yellow, 90) :
                london_session ? color.new(color.blue, 90) :
                ny_session ? color.new(color.green, 90) : na

bgcolor(session_color, title="Trading Sessions")

// Overlap highlighting
bgcolor(london_ny_overlap ? color.new(color.red, 80) : na, title="London-NY Overlap")

plot(current_session_atr, "Session ATR", color.purple)

// Session labels
if tokyo_session and not tokyo_session[1]
    label.new(bar_index, high, "Tokyo", style=label.style_label_down, color=color.yellow)
if london_session and not london_session[1]
    label.new(bar_index, high, "London", style=label.style_label_down, color=color.blue)
if ny_session and not ny_session[1]
    label.new(bar_index, high, "New York", style=label.style_label_down, color=color.green)
```

## Timezone Considerations

Handle timezone differences and conversions:

### Timezone-Aware Calculations

```pinescript
//@version=6
indicator("Timezone Handling", overlay=true)

// Get times in different timezones
ny_time = time("", "America/New_York")
london_time = time("", "Europe/London")
tokyo_time = time("", "Asia/Tokyo")
sydney_time = time("", "Australia/Sydney")

// Format timezone display
format_time(timestamp) =>
    str.format("{0:02.0f}:{1:02.0f}", 
               timestamp / 1000 / 60 / 60 % 24,
               timestamp / 1000 / 60 % 60)

// Display multiple timezone times
if barstate.islast
    var table timezone_table = table.new(position.bottom_right, 2, 5,
                                        bgcolor=color.new(color.black, 80))
    
    table.cell(timezone_table, 0, 0, "Timezone", text_color=color.white, bgcolor=color.blue)
    table.cell(timezone_table, 1, 0, "Time", text_color=color.white, bgcolor=color.blue)
    
    table.cell(timezone_table, 0, 1, "New York", text_color=color.white)
    table.cell(timezone_table, 1, 1, format_time(ny_time), text_color=color.yellow)
    
    table.cell(timezone_table, 0, 2, "London", text_color=color.white)
    table.cell(timezone_table, 1, 2, format_time(london_time), text_color=color.yellow)
    
    table.cell(timezone_table, 0, 3, "Tokyo", text_color=color.white)
    table.cell(timezone_table, 1, 3, format_time(tokyo_time), text_color=color.yellow)
    
    table.cell(timezone_table, 0, 4, "Sydney", text_color=color.white)
    table.cell(timezone_table, 1, 4, format_time(sydney_time), text_color=color.yellow)

// Timezone-specific market events
is_ny_market_open = not na(time(timeframe.period, "0930-1600", "America/New_York"))
is_london_market_open = not na(time(timeframe.period, "0800-1630", "Europe/London"))

// Handle daylight saving time transitions
detect_dst_transition() =>
    var int last_hour = na
    current_hour = hour(time, "America/New_York")
    
    dst_change = false
    if not na(last_hour) and math.abs(current_hour - last_hour) > 1
        dst_change := true
    
    last_hour := current_hour
    dst_change

if detect_dst_transition()
    label.new(bar_index, high, "DST Change", 
              style=label.style_label_down, color=color.orange)
```

## Data Quality Issues

Detect and handle data quality problems:

### Data Quality Checks

```pinescript
//@version=6
indicator("Data Quality Monitor", overlay=true)

// Check for data anomalies
detect_data_issues() =>
    var int error_count = 0
    
    issues = array.new<string>()
    
    // Check for missing data
    if na(open) or na(high) or na(low) or na(close)
        array.push(issues, "Missing OHLC data")
        error_count += 1
    
    // Check for invalid OHLC relationships
    if high < low or high < open or high < close or low > open or low > close
        array.push(issues, "Invalid OHLC relationship")
        error_count += 1
    
    // Check for zero or negative volume
    if volume <= 0
        array.push(issues, "Invalid volume")
        error_count += 1
    
    // Check for extreme price movements
    if not barstate.isfirst
        price_change = math.abs(close - close[1]) / close[1]
        if price_change > 0.5  // 50% change
            array.push(issues, str.format("Extreme price change: {0}%", price_change * 100))
            error_count += 1
    
    // Check for stuck prices
    if bar_index >= 5
        all_same = true
        for i = 1 to 5
            if close[i] != close
                all_same := false
                break
        
        if all_same
            array.push(issues, "Stuck price data")
            error_count += 1
    
    [issues, error_count]

[data_issues, total_errors] = detect_data_issues()

// Display data quality issues
if array.size(data_issues) > 0
    issue_text = ""
    for i = 0 to array.size(data_issues) - 1
        issue_text += array.get(data_issues, i)
        if i < array.size(data_issues) - 1
            issue_text += "\n"
    
    label.new(bar_index, high * 1.05, issue_text,
              style=label.style_label_down, color=color.red, size=size.small)

// Data quality score
data_quality_score = total_errors == 0 ? 100 : math.max(0, 100 - total_errors * 10)

// Handle missing data
safe_close = na(close) ? nz(close[1]) : close
safe_volume = volume <= 0 ? nz(volume[1]) : volume

plot(data_quality_score, "Data Quality Score", color.green)
```

### Data Cleansing Functions

```pinescript
//@version=6
indicator("Data Cleansing", overlay=false)

// Outlier detection and removal
remove_outliers(source, lookback, threshold_std) =>
    if bar_index < lookback
        source
    else
        mean = ta.sma(source, lookback)
        std_dev = ta.stdev(source, lookback)
        
        upper_bound = mean + threshold_std * std_dev
        lower_bound = mean - threshold_std * std_dev
        
        if source > upper_bound or source < lower_bound
            mean  // Replace outlier with mean
        else
            source

// Smooth erratic data
smooth_erratic_data(source, sensitivity) =>
    change_threshold = ta.atr(14) * sensitivity
    
    if math.abs(ta.change(source)) > change_threshold
        ta.ema(source, 3)  // Smooth aggressive moves
    else
        source

// Fill gaps in data
fill_data_gaps(source) =>
    if na(source)
        nz(source[1])  // Use previous value
    else
        source

// Apply data cleansing
raw_close = close
cleaned_close = remove_outliers(raw_close, 20, 3.0)
smoothed_close = smooth_erratic_data(cleaned_close, 2.0)
final_close = fill_data_gaps(smoothed_close)

plot(raw_close, "Raw Close", color.gray)
plot(final_close, "Cleaned Close", color.blue, linewidth=2)

// Data cleansing statistics
var int outliers_removed = 0
var int gaps_filled = 0

if raw_close != cleaned_close
    outliers_removed += 1

if na(close) and not na(final_close)
    gaps_filled += 1

// Display cleansing stats
if barstate.islast
    var table stats_table = table.new(position.top_left, 2, 3,
                                     bgcolor=color.new(color.black, 80))
    
    table.cell(stats_table, 0, 0, "Statistic", text_color=color.white, bgcolor=color.blue)
    table.cell(stats_table, 1, 0, "Count", text_color=color.white, bgcolor=color.blue)
    
    table.cell(stats_table, 0, 1, "Outliers Removed", text_color=color.white)
    table.cell(stats_table, 1, 1, str.tostring(outliers_removed), text_color=color.yellow)
    
    table.cell(stats_table, 0, 2, "Gaps Filled", text_color=color.white)
    table.cell(stats_table, 1, 2, str.tostring(gaps_filled), text_color=color.yellow)
```

## Broker Emulator Quirks

Handle TradingView broker emulator limitations:

### Strategy Testing Considerations

```pinescript
//@version=6
strategy("Broker Emulator Handling", overlay=true, 
         default_qty_type=strategy.percent_of_equity, default_qty_value=10)

// Handle broker emulator limitations
handle_order_execution() =>
    // Account for slippage in backtesting
    slippage_percent = 0.05  // 0.05%
    
    // Calculate slippage-adjusted prices
    buy_price = close * (1 + slippage_percent / 100)
    sell_price = close * (1 - slippage_percent / 100)
    
    [buy_price, sell_price]

[adjusted_buy_price, adjusted_sell_price] = handle_order_execution()

// Handle minimum tick size
adjust_for_tick_size(price) =>
    tick_size = syminfo.mintick
    math.round(price / tick_size) * tick_size

// Commission and fee considerations
calculate_trading_costs(qty, price) =>
    commission_rate = 0.001  // 0.1%
    min_commission = 1.0
    
    commission = math.max(qty * price * commission_rate, min_commission)
    commission

// Realistic position sizing
calculate_realistic_position_size(capital, price, risk_percent) =>
    risk_amount = capital * risk_percent / 100
    shares = math.floor(risk_amount / price)
    
    // Account for minimum lot sizes
    min_lot = 1
    lot_size = 100  // For stocks
    
    adjusted_shares = math.max(min_lot, math.floor(shares / lot_size) * lot_size)
    adjusted_shares

// Example strategy with realistic constraints
rsi = ta.rsi(close, 14)
buy_signal = ta.crossover(rsi, 30)
sell_signal = ta.crossunder(rsi, 70)

if buy_signal
    adjusted_price = adjust_for_tick_size(adjusted_buy_price)
    position_size = calculate_realistic_position_size(strategy.equity, adjusted_price, 2.0)
    
    if position_size > 0
        strategy.entry("Long", strategy.long, qty=position_size, limit=adjusted_price)

if sell_signal
    adjusted_price = adjust_for_tick_size(adjusted_sell_price)
    strategy.close("Long", limit=adjusted_price)

// Handle partial fills
track_order_fills() =>
    var float expected_fill = na
    var float actual_fill = na
    
    if strategy.position_size != strategy.position_size[1]
        // Position changed - order was filled
        actual_fill := strategy.position_size - strategy.position_size[1]
        
        if not na(expected_fill) and actual_fill != expected_fill
            // Partial fill detected
            partial_fill_percent = actual_fill / expected_fill * 100
            log.info("Partial fill: {0}% of expected quantity", partial_fill_percent)

track_order_fills()

// Display broker emulator warnings
if barstate.islast
    var table warning_table = table.new(position.bottom_left, 1, 4,
                                       bgcolor=color.new(color.yellow, 80))
    
    table.cell(warning_table, 0, 0, "Broker Emulator Limitations", 
               text_color=color.black, bgcolor=color.yellow)
    table.cell(warning_table, 0, 1, "• No real slippage modeling", text_color=color.black)
    table.cell(warning_table, 0, 2, "• Perfect order execution", text_color=color.black)
    table.cell(warning_table, 0, 3, "• No liquidity constraints", text_color=color.black)
```

### Real-World Trading Adjustments

```pinescript
//@version=6
strategy("Real-World Adjustments", overlay=true)

// Account for real-world trading conditions
trading_hours_only = input.bool(true, "Trade Only During Regular Hours")
max_daily_trades = input.int(5, "Maximum Daily Trades")
max_position_size = input.float(10000, "Maximum Position Size ($)")

// Track daily trade count
var int daily_trades = 0
var int last_trade_day = na

if dayofmonth != last_trade_day
    daily_trades := 0
    last_trade_day := dayofmonth

// Realistic trading constraints
can_trade() =>
    conditions = array.new<bool>()
    
    // Regular hours check
    if trading_hours_only
        in_trading_hours = not na(time(timeframe.period, "0930-1600", "America/New_York"))
        array.push(conditions, in_trading_hours)
    
    // Daily trade limit
    array.push(conditions, daily_trades < max_daily_trades)
    
    // Position size limit
    current_position_value = strategy.position_size * close
    array.push(conditions, math.abs(current_position_value) < max_position_size)
    
    // Check all conditions
    all_conditions_met = true
    for i = 0 to array.size(conditions) - 1
        if not array.get(conditions, i)
            all_conditions_met := false
            break
    
    all_conditions_met

// Apply realistic trading logic
if can_trade() and ta.crossover(ta.rsi(close, 14), 30)
    strategy.entry("Long", strategy.long)
    daily_trades += 1

if ta.crossunder(ta.rsi(close, 14), 70)
    strategy.close("Long")

// Market impact modeling
model_market_impact(order_size, avg_volume) =>
    volume_participation = order_size / avg_volume
    impact_percent = volume_participation * 0.1  // 0.1% per 1% of volume
    impact_percent

// Display trading status
trading_status = can_trade() ? "Active" : "Restricted"
bgcolor(can_trade() ? color.new(color.green, 95) : color.new(color.red, 95), 
        title="Trading Status")

if barstate.islast
    var table status_table = table.new(position.top_right, 2, 3,
                                      bgcolor=color.new(color.black, 80))
    
    table.cell(status_table, 0, 0, "Trading Status", text_color=color.white)
    table.cell(status_table, 1, 0, trading_status, text_color=color.yellow)
    
    table.cell(status_table, 0, 1, "Daily Trades", text_color=color.white)
    table.cell(status_table, 1, 1, str.tostring(daily_trades), text_color=color.yellow)
    
    table.cell(status_table, 0, 2, "Max Trades", text_color=color.white)
    table.cell(status_table, 1, 2, str.tostring(max_daily_trades), text_color=color.yellow)
```

## Summary

Handling edge cases properly is crucial for robust Pine Script indicators and strategies:

1. **First Bar Safety** - Always check for sufficient data before calculations
2. **Gap Handling** - Detect and adjust for weekend/holiday gaps
3. **Corporate Actions** - Account for splits, dividends, and symbol changes
4. **Liquidity Awareness** - Adjust behavior for illiquid market conditions
5. **Session Management** - Handle different trading sessions and timezones
6. **Data Quality** - Implement checks and cleansing for bad data
7. **Realistic Testing** - Account for broker emulator limitations

These techniques ensure your Pine Script code behaves correctly across all market conditions and data scenarios.