# Pine Script v6 Tables Guide

Tables in Pine Script v6 provide a powerful way to display structured data on charts. This guide covers comprehensive table implementation, from basic creation to advanced use cases.

## Table of Contents
1. [Table Basics](#table-basics)
2. [Table Creation and Positioning](#table-creation-and-positioning)
3. [Cell Management](#cell-management)
4. [Formatting Options](#formatting-options)
5. [Performance Metrics Display](#performance-metrics-display)
6. [Strategy Statistics Tables](#strategy-statistics-tables)
7. [Multi-Column Layouts](#multi-column-layouts)
8. [Dynamic Updates](#dynamic-updates)
9. [Advanced Patterns](#advanced-patterns)

---

## Table Basics

### Core Concepts
- Tables are visual objects that persist across bars
- Maximum of 500 table objects per script
- Tables are drawn on top of price data
- Use `var` declaration for persistent tables

### Basic Table Structure
```pinescript
//@version=6
indicator("Basic Table", overlay=true)

// Create table (only once)
var table my_table = table.new(
    position=position.top_right,
    columns=2,
    rows=3,
    bgcolor=color.white,
    border_width=1
)

// Populate table
if barstate.islast
    table.cell(my_table, 0, 0, "Label", bgcolor=color.gray, text_color=color.white)
    table.cell(my_table, 1, 0, "Value", bgcolor=color.gray, text_color=color.white)
    table.cell(my_table, 0, 1, "Close", bgcolor=color.white)
    table.cell(my_table, 1, 1, str.tostring(close, "0.00"), bgcolor=color.white)
```

---

## Table Creation and Positioning

### Position Options
```pinescript
//@version=6
indicator("Table Positions", overlay=true)

// All available positions
positions = array.from(
    position.top_left,     position.top_center,     position.top_right,
    position.middle_left,  position.middle_center,  position.middle_right,
    position.bottom_left,  position.bottom_center,  position.bottom_right
)

// Create tables at different positions
var tables = array.new<table>(0)

if barstate.isfirst
    for i = 0 to array.size(positions) - 1
        pos = array.get(positions, i)
        t = table.new(pos, 1, 1, bgcolor=color.new(color.blue, 80))
        table.cell(t, 0, 0, str.tostring(i), text_color=color.white)
        array.push(tables, t)
```

### Advanced Table Creation
```pinescript
//@version=6
indicator("Advanced Table Creation", overlay=true)

// Input for table customization
table_position = input.string("top_right", "Table Position", 
    options=["top_left", "top_right", "bottom_left", "bottom_right"])
table_columns = input.int(3, "Columns", minval=1, maxval=10)
table_rows = input.int(5, "Rows", minval=1, maxval=20)

// Convert string to position
get_position(pos_str) =>
    switch pos_str
        "top_left" => position.top_left
        "top_right" => position.top_right
        "bottom_left" => position.bottom_left
        "bottom_right" => position.bottom_right
        => position.top_right

var table data_table = table.new(
    position=get_position(table_position),
    columns=table_columns,
    rows=table_rows,
    bgcolor=color.new(color.white, 0),
    border_width=2,
    border_color=color.blue,
    frame_width=1,
    frame_color=color.gray
)
```

---

## Cell Management

### Basic Cell Operations
```pinescript
//@version=6
indicator("Cell Management", overlay=true)

var table info_table = table.new(position.top_left, 2, 4)

update_table() =>
    // Clear existing content
    table.clear(info_table, 0, 0, 1, 3)
    
    // Set headers
    table.cell(info_table, 0, 0, "Metric", 
        bgcolor=color.new(color.blue, 20), 
        text_color=color.blue,
        text_size=size.normal)
    table.cell(info_table, 1, 0, "Value", 
        bgcolor=color.new(color.blue, 20), 
        text_color=color.blue,
        text_size=size.normal)
    
    // Add data rows
    table.cell(info_table, 0, 1, "Price")
    table.cell(info_table, 1, 1, str.tostring(close, "0.00"))
    
    table.cell(info_table, 0, 2, "Volume")
    table.cell(info_table, 1, 2, str.tostring(volume, "0"))
    
    table.cell(info_table, 0, 3, "Time")
    table.cell(info_table, 1, 3, str.format_time(time, "HH:mm"))

if barstate.islast
    update_table()
```

### Dynamic Cell Sizing
```pinescript
//@version=6
indicator("Dynamic Cell Sizing", overlay=true)

var table sized_table = table.new(position.middle_right, 3, 4)

create_sized_table() =>
    // Headers with different sizes
    table.cell(sized_table, 0, 0, "Small", text_size=size.small)
    table.cell(sized_table, 1, 0, "Normal", text_size=size.normal)
    table.cell(sized_table, 2, 0, "Large", text_size=size.large)
    
    // Different cell widths using text content
    table.cell(sized_table, 0, 1, "S")
    table.cell(sized_table, 1, 1, "Medium Text")
    table.cell(sized_table, 2, 1, "Very Long Text Content")
    
    // Forced width using spaces
    table.cell(sized_table, 0, 2, "Fixed     ")  // Adds padding
    table.cell(sized_table, 1, 2, "Width     ")
    table.cell(sized_table, 2, 2, "Columns   ")

if barstate.islast
    create_sized_table()
```

---

## Formatting Options

### Color and Styling
```pinescript
//@version=6
indicator("Table Formatting", overlay=true)

var table format_table = table.new(position.top_center, 4, 6)

create_formatted_table() =>
    // Color schemes
    header_bg = color.new(color.navy, 0)
    header_text = color.white
    even_row_bg = color.new(color.gray, 90)
    odd_row_bg = color.new(color.blue, 95)
    
    // Headers
    headers = array.from("Type", "Color", "Text", "Size")
    for i = 0 to 3
        table.cell(format_table, i, 0, array.get(headers, i),
            bgcolor=header_bg,
            text_color=header_text,
            text_size=size.normal)
    
    // Different text colors
    table.cell(format_table, 0, 1, "Red Text", text_color=color.red)
    table.cell(format_table, 1, 1, "Green Text", text_color=color.green)
    table.cell(format_table, 2, 1, "Blue Text", text_color=color.blue)
    table.cell(format_table, 3, 1, "Custom", text_color=color.new(color.purple, 0))
    
    // Different background colors
    table.cell(format_table, 0, 2, "Light", bgcolor=color.new(color.yellow, 80))
    table.cell(format_table, 1, 2, "Medium", bgcolor=color.new(color.orange, 50))
    table.cell(format_table, 2, 2, "Dark", bgcolor=color.new(color.red, 20))
    table.cell(format_table, 3, 2, "Transparent", bgcolor=color.new(color.blue, 95))
    
    // Text sizes
    table.cell(format_table, 0, 3, "Auto", text_size=size.auto)
    table.cell(format_table, 1, 3, "Tiny", text_size=size.tiny)
    table.cell(format_table, 2, 3, "Small", text_size=size.small)
    table.cell(format_table, 3, 3, "Normal", text_size=size.normal)
    
    table.cell(format_table, 0, 4, "Large", text_size=size.large)
    table.cell(format_table, 1, 4, "Huge", text_size=size.huge)
    
    // Alignment examples (v6 doesn't have text alignment in tables)
    table.cell(format_table, 2, 4, "Centered-ish", bgcolor=even_row_bg)
    table.cell(format_table, 3, 4, "Right-ish    ", bgcolor=even_row_bg)

if barstate.islast
    create_formatted_table()
```

---

## Performance Metrics Display

### Real-time Performance Table
```pinescript
//@version=6
indicator("Performance Metrics", overlay=true)

// Inputs
lookback_period = input.int(20, "Lookback Period", minval=1)

// Calculations
price_change = close - close[lookback_period]
price_change_pct = (price_change / close[lookback_period]) * 100
volatility = ta.stdev(ta.change(close), lookback_period)
rsi = ta.rsi(close, 14)
volume_sma = ta.sma(volume, lookback_period)
volume_ratio = volume / volume_sma

var table perf_table = table.new(
    position=position.top_right,
    columns=2,
    rows=8,
    bgcolor=color.new(color.white, 10),
    border_width=1,
    border_color=color.gray
)

update_performance_table() =>
    // Helper function for color coding
    get_color(value, positive_threshold=0, negative_threshold=0) =>
        if value > positive_threshold
            color.new(color.green, 80)
        else if value < negative_threshold
            color.new(color.red, 80)
        else
            color.new(color.gray, 90)
    
    // Clear and rebuild
    table.clear(perf_table, 0, 0, 1, 7)
    
    // Header
    table.cell(perf_table, 0, 0, "Metric", 
        bgcolor=color.new(color.blue, 20), 
        text_color=color.white, 
        text_size=size.small)
    table.cell(perf_table, 1, 0, "Value", 
        bgcolor=color.new(color.blue, 20), 
        text_color=color.white, 
        text_size=size.small)
    
    // Price Change
    table.cell(perf_table, 0, 1, str.format("{}D Change", lookback_period))
    table.cell(perf_table, 1, 1, str.tostring(price_change, "0.00"),
        bgcolor=get_color(price_change),
        text_color=price_change > 0 ? color.green : color.red)
    
    // Percentage Change
    table.cell(perf_table, 0, 2, "% Change")
    table.cell(perf_table, 1, 2, str.format("{0}%", str.tostring(price_change_pct, "0.00")),
        bgcolor=get_color(price_change_pct),
        text_color=price_change_pct > 0 ? color.green : color.red)
    
    // Volatility
    table.cell(perf_table, 0, 3, "Volatility")
    table.cell(perf_table, 1, 3, str.tostring(volatility, "0.00"),
        bgcolor=get_color(volatility, 2, 0),
        text_color=volatility > 2 ? color.red : color.black)
    
    // RSI
    table.cell(perf_table, 0, 4, "RSI(14)")
    rsi_color = rsi > 70 ? color.red : rsi < 30 ? color.green : color.gray
    table.cell(perf_table, 1, 4, str.tostring(rsi, "0.0"),
        bgcolor=color.new(rsi_color, 80),
        text_color=rsi_color)
    
    // Volume Ratio
    table.cell(perf_table, 0, 5, "Vol Ratio")
    table.cell(perf_table, 1, 5, str.tostring(volume_ratio, "0.00"),
        bgcolor=get_color(volume_ratio - 1, 0.5, -0.5),
        text_color=volume_ratio > 1.5 ? color.orange : color.black)
    
    // Current Price
    table.cell(perf_table, 0, 6, "Price")
    table.cell(perf_table, 1, 6, str.tostring(close, "0.00"))
    
    // Timestamp
    table.cell(perf_table, 0, 7, "Updated")
    table.cell(perf_table, 1, 7, str.format_time(time, "HH:mm:ss"),
        text_size=size.tiny)

if barstate.islast
    update_performance_table()
```

---

## Strategy Statistics Tables

### Comprehensive Strategy Stats
```pinescript
//@version=6
strategy("Strategy Stats Table", overlay=true, initial_capital=10000)

// Simple strategy for demonstration
rsi = ta.rsi(close, 14)
if rsi < 30
    strategy.entry("Long", strategy.long)
if rsi > 70
    strategy.close("Long")

// Strategy statistics table
var table stats_table = table.new(
    position=position.bottom_right,
    columns=2,
    rows=12,
    bgcolor=color.new(color.white, 0),
    border_width=2,
    border_color=color.blue
)

update_strategy_stats() =>
    // Get strategy stats
    total_trades = strategy.closedtrades
    winning_trades = strategy.wintrades
    losing_trades = strategy.losstrades
    win_rate = total_trades > 0 ? (winning_trades / total_trades) * 100 : 0
    profit_factor = strategy.losstrades > 0 ? math.abs(strategy.grossprofit / strategy.grossloss) : na
    max_dd = strategy.max_drawdown
    net_profit = strategy.netprofit
    avg_trade = total_trades > 0 ? net_profit / total_trades : 0
    
    // Clear table
    table.clear(stats_table, 0, 0, 1, 11)
    
    // Header
    table.cell(stats_table, 0, 0, "Strategy Statistics",
        bgcolor=color.new(color.blue, 0),
        text_color=color.white,
        text_size=size.normal)
    table.cell(stats_table, 1, 0, "",
        bgcolor=color.new(color.blue, 0))
    
    // Total Trades
    table.cell(stats_table, 0, 1, "Total Trades")
    table.cell(stats_table, 1, 1, str.tostring(total_trades))
    
    // Winning Trades
    table.cell(stats_table, 0, 2, "Winning Trades")
    table.cell(stats_table, 1, 2, str.tostring(winning_trades),
        text_color=color.green)
    
    // Losing Trades
    table.cell(stats_table, 0, 3, "Losing Trades")
    table.cell(stats_table, 1, 3, str.tostring(losing_trades),
        text_color=color.red)
    
    // Win Rate
    table.cell(stats_table, 0, 4, "Win Rate")
    win_color = win_rate > 50 ? color.green : color.red
    table.cell(stats_table, 1, 4, str.format("{0}%", str.tostring(win_rate, "0.1")),
        text_color=win_color)
    
    // Profit Factor
    table.cell(stats_table, 0, 5, "Profit Factor")
    pf_color = not na(profit_factor) and profit_factor > 1 ? color.green : color.red
    pf_text = na(profit_factor) ? "N/A" : str.tostring(profit_factor, "0.00")
    table.cell(stats_table, 1, 5, pf_text, text_color=pf_color)
    
    // Net Profit
    table.cell(stats_table, 0, 6, "Net Profit")
    table.cell(stats_table, 1, 6, str.format("${0}", str.tostring(net_profit, "0")),
        text_color=net_profit > 0 ? color.green : color.red)
    
    // Max Drawdown
    table.cell(stats_table, 0, 7, "Max Drawdown")
    table.cell(stats_table, 1, 7, str.format("${0}", str.tostring(max_dd, "0")),
        text_color=color.red)
    
    // Average Trade
    table.cell(stats_table, 0, 8, "Avg Trade")
    table.cell(stats_table, 1, 8, str.format("${0}", str.tostring(avg_trade, "0")),
        text_color=avg_trade > 0 ? color.green : color.red)
    
    // Current Equity
    table.cell(stats_table, 0, 9, "Equity")
    table.cell(stats_table, 1, 9, str.format("${0}", str.tostring(strategy.equity, "0")))
    
    // Current Position
    table.cell(stats_table, 0, 10, "Position")
    pos_text = strategy.position_size > 0 ? "LONG" : strategy.position_size < 0 ? "SHORT" : "FLAT"
    pos_color = strategy.position_size > 0 ? color.green : strategy.position_size < 0 ? color.red : color.gray
    table.cell(stats_table, 1, 10, pos_text, text_color=pos_color)
    
    // Last Update
    table.cell(stats_table, 0, 11, "Updated")
    table.cell(stats_table, 1, 11, str.format_time(time, "MM/dd HH:mm"),
        text_size=size.tiny)

if barstate.islast
    update_strategy_stats()
```

---

## Multi-Column Layouts

### Advanced Multi-Column Table
```pinescript
//@version=6
indicator("Multi-Column Layout", overlay=true)

// Market data for different timeframes
var table market_table = table.new(position.top_left, 5, 6)

update_market_overview() =>
    // Timeframes to display
    timeframes = array.from("1m", "5m", "15m", "1h", "1D")
    
    // Clear table
    table.clear(market_table, 0, 0, 4, 5)
    
    // Headers
    table.cell(market_table, 0, 0, "Timeframe",
        bgcolor=color.new(color.navy, 0),
        text_color=color.white,
        text_size=size.small)
    table.cell(market_table, 1, 0, "Price",
        bgcolor=color.new(color.navy, 0),
        text_color=color.white,
        text_size=size.small)
    table.cell(market_table, 2, 0, "Change",
        bgcolor=color.new(color.navy, 0),
        text_color=color.white,
        text_size=size.small)
    table.cell(market_table, 3, 0, "RSI",
        bgcolor=color.new(color.navy, 0),
        text_color=color.white,
        text_size=size.small)
    table.cell(market_table, 4, 0, "Volume",
        bgcolor=color.new(color.navy, 0),
        text_color=color.white,
        text_size=size.small)
    
    // Data rows
    for i = 0 to 4
        tf = array.get(timeframes, i)
        row = i + 1
        
        // Get multi-timeframe data
        [tf_close, tf_change, tf_rsi, tf_volume] = request.security(
            syminfo.tickerid, tf, 
            [close, ta.change(close), ta.rsi(close, 14), volume]
        )
        
        // Timeframe column
        table.cell(market_table, 0, row, tf,
            bgcolor=color.new(color.gray, 90))
        
        // Price column
        table.cell(market_table, 1, row, str.tostring(tf_close, "0.00"))
        
        // Change column with color coding
        change_color = tf_change > 0 ? color.green : tf_change < 0 ? color.red : color.gray
        table.cell(market_table, 2, row, str.tostring(tf_change, "0.00"),
            text_color=change_color)
        
        // RSI column with background color
        rsi_bg = tf_rsi > 70 ? color.new(color.red, 80) : tf_rsi < 30 ? color.new(color.green, 80) : color.new(color.gray, 90)
        table.cell(market_table, 3, row, str.tostring(tf_rsi, "0"),
            bgcolor=rsi_bg)
        
        // Volume column (simplified)
        vol_text = tf_volume > 1000000 ? str.format("{0}M", str.tostring(tf_volume/1000000, "0.1")) : 
                   tf_volume > 1000 ? str.format("{0}K", str.tostring(tf_volume/1000, "0")) : 
                   str.tostring(tf_volume, "0")
        table.cell(market_table, 4, row, vol_text,
            text_size=size.small)

if barstate.islast
    update_market_overview()
```

---

## Dynamic Updates

### Real-time Updating Table
```pinescript
//@version=6
indicator("Dynamic Table Updates", overlay=true)

// Track recent price movements
var price_history = array.new<float>(0)
var time_history = array.new<int>(0)
max_history = 10

// Update history arrays
if barstate.isconfirmed
    array.unshift(price_history, close)
    array.unshift(time_history, time)
    
    if array.size(price_history) > max_history
        array.pop(price_history)
        array.pop(time_history)

var table history_table = table.new(position.middle_left, 3, max_history + 1)

update_history_table() =>
    // Clear table
    table.clear(history_table, 0, 0, 2, max_history)
    
    // Headers
    table.cell(history_table, 0, 0, "#", bgcolor=color.new(color.blue, 20), text_color=color.white)
    table.cell(history_table, 1, 0, "Time", bgcolor=color.new(color.blue, 20), text_color=color.white)
    table.cell(history_table, 2, 0, "Price", bgcolor=color.new(color.blue, 20), text_color=color.white)
    
    // Historical data
    history_size = array.size(price_history)
    for i = 0 to math.min(history_size - 1, max_history - 1)
        row = i + 1
        hist_price = array.get(price_history, i)
        hist_time = array.get(time_history, i)
        
        // Row number
        table.cell(history_table, 0, row, str.tostring(i + 1))
        
        // Time
        table.cell(history_table, 1, row, str.format_time(hist_time, "HH:mm"),
            text_size=size.small)
        
        // Price with change color
        price_color = i == 0 ? color.black : 
                     hist_price > array.get(price_history, i - 1) ? color.green : 
                     hist_price < array.get(price_history, i - 1) ? color.red : color.gray
        
        table.cell(history_table, 2, row, str.tostring(hist_price, "0.00"),
            text_color=price_color)

if barstate.islast
    update_history_table()
```

---

## Advanced Patterns

### Conditional Table Display
```pinescript
//@version=6
indicator("Conditional Tables", overlay=true)

// Inputs
show_table = input.bool(true, "Show Statistics Table")
alert_mode = input.bool(false, "Alert Mode")
rsi_period = input.int(14, "RSI Period")

// Calculations
rsi = ta.rsi(close, rsi_period)
is_overbought = rsi > 70
is_oversold = rsi < 30

var table alert_table = table.new(position.top_center, 2, 4)

update_conditional_table() =>
    if not show_table
        table.delete(alert_table)
        alert_table := table.new(position.top_center, 2, 4)
        return
    
    // Show different content based on mode
    if alert_mode and (is_overbought or is_oversold)
        # Alert Mode - Only show when conditions are met
        table.clear(alert_table, 0, 0, 1, 3)
        
        alert_color = is_overbought ? color.red : color.green
        alert_text = is_overbought ? "OVERBOUGHT" : "OVERSOLD"
        
        table.cell(alert_table, 0, 0, "ALERT", 
            bgcolor=alert_color, 
            text_color=color.white,
            text_size=size.large)
        table.cell(alert_table, 1, 0, alert_text,
            bgcolor=alert_color,
            text_color=color.white,
            text_size=size.large)
        
        table.cell(alert_table, 0, 1, "RSI")
        table.cell(alert_table, 1, 1, str.tostring(rsi, "0.0"),
            text_color=alert_color)
        
        table.cell(alert_table, 0, 2, "Price")
        table.cell(alert_table, 1, 2, str.tostring(close, "0.00"))
        
        table.cell(alert_table, 0, 3, "Time")
        table.cell(alert_table, 1, 3, str.format_time(time, "HH:mm:ss"))
        
    else if not alert_mode
        # Normal Mode - Always show stats
        table.clear(alert_table, 0, 0, 1, 3)
        
        table.cell(alert_table, 0, 0, "Market Stats",
            bgcolor=color.new(color.blue, 20),
            text_color=color.white)
        table.cell(alert_table, 1, 0, "",
            bgcolor=color.new(color.blue, 20))
        
        table.cell(alert_table, 0, 1, "RSI")
        rsi_color = is_overbought ? color.red : is_oversold ? color.green : color.gray
        table.cell(alert_table, 1, 1, str.tostring(rsi, "0.0"),
            text_color=rsi_color)
        
        table.cell(alert_table, 0, 2, "Trend")
        trend = close > ta.sma(close, 20) ? "UP" : "DOWN"
        trend_color = trend == "UP" ? color.green : color.red
        table.cell(alert_table, 1, 2, trend, text_color=trend_color)
        
        table.cell(alert_table, 0, 3, "Volatility")
        vol = ta.atr(14)
        table.cell(alert_table, 1, 3, str.tostring(vol, "0.00"))

if barstate.islast
    update_conditional_table()
```

### Performance Optimized Tables
```pinescript
//@version=6
indicator("Optimized Tables", overlay=true)

// Only update table on specific conditions to save resources
update_frequency = input.int(5, "Update Every N Bars", minval=1)
force_update = input.bool(false, "Force Update")

var table perf_table = table.new(position.bottom_left, 2, 5)
var int last_update_bar = 0
var bool needs_update = true

// Check if update is needed
should_update = barstate.islast and (
    bar_index - last_update_bar >= update_frequency or 
    force_update or 
    needs_update
)

optimized_table_update() =>
    if should_update
        last_update_bar := bar_index
        needs_update := false
        
        # Expensive calculations only when updating
        sma_fast = ta.sma(close, 10)
        sma_slow = ta.sma(close, 30)
        rsi = ta.rsi(close, 14)
        atr = ta.atr(14)
        
        table.clear(perf_table, 0, 0, 1, 4)
        
        table.cell(perf_table, 0, 0, "Optimized Stats",
            bgcolor=color.new(color.green, 20),
            text_color=color.white)
        table.cell(perf_table, 1, 0, str.format("Bar: {0}", str.tostring(bar_index)),
            bgcolor=color.new(color.green, 20),
            text_color=color.white,
            text_size=size.tiny)
        
        table.cell(perf_table, 0, 1, "Fast SMA")
        table.cell(perf_table, 1, 1, str.tostring(sma_fast, "0.00"))
        
        table.cell(perf_table, 0, 2, "Slow SMA")
        table.cell(perf_table, 1, 2, str.tostring(sma_slow, "0.00"))
        
        table.cell(perf_table, 0, 3, "RSI")
        table.cell(perf_table, 1, 3, str.tostring(rsi, "0.0"))
        
        table.cell(perf_table, 0, 4, "ATR")
        table.cell(perf_table, 1, 4, str.tostring(atr, "0.00"))

# Mark for update on significant price changes
if math.abs(ta.change(close)) > ta.atr(14) * 0.5
    needs_update := true

optimized_table_update()
```

## Best Practices

### 1. Resource Management
- Use `var` for table declarations to prevent recreation
- Clear tables efficiently with `table.clear()`
- Limit updates to necessary conditions
- Consider update frequency for performance

### 2. Visual Design
- Use consistent color schemes
- Implement proper contrast for readability
- Group related information logically
- Use appropriate text sizes

### 3. Data Formatting
- Format numbers appropriately for context
- Use color coding for quick interpretation
- Include units and labels
- Handle `na` values gracefully

### 4. User Experience
- Make tables toggleable with inputs
- Position tables to avoid chart interference
- Update tables only when necessary
- Provide meaningful information density

This comprehensive guide covers all aspects of table implementation in Pine Script v6, from basic usage to advanced patterns that agents can use for creating professional data displays.