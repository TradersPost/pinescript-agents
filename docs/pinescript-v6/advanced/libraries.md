# Pine Script v6 Libraries Comprehensive Guide

Libraries in Pine Script v6 enable code reusability and modularity by allowing you to create collections of functions that can be shared across multiple scripts. This guide covers everything from basic library creation to advanced distribution patterns.

## Table of Contents
1. [Library Structure and Declaration](#library-structure-and-declaration)
2. [Exporting Functions](#exporting-functions)
3. [Function Documentation](#function-documentation)
4. [Type Exports](#type-exports)
5. [Using External Libraries](#using-external-libraries)
6. [Library Versioning](#library-versioning)
7. [Best Practices for Library Design](#best-practices-for-library-design)
8. [Distribution and Sharing](#distribution-and-sharing)
9. [Examples of Utility Libraries](#examples-of-utility-libraries)

---

## Library Structure and Declaration

### Basic Library Declaration
```pinescript
//@version=6

// @description Library for advanced mathematical calculations and statistical analysis
library("math_utils", overlay=true)

// Library code goes here...
```

### Library Header Requirements
```pinescript
//@version=6

// @description A comprehensive trading utilities library with risk management, 
//              position sizing, and statistical functions for Pine Script v6
// @author TradingLibrary
// @version 1.2.0
library("trading_utils")
```

### Complete Library Template
```pinescript
//@version=6

// @description Complete template for creating professional Pine Script libraries
// @author LibraryAuthor
// @version 1.0.0
library("template_lib")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                    LIBRARY CONSTANTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Export constants that users might need
export PI = 3.141592653589793
export E = 2.718281828459045
export GOLDEN_RATIO = 1.618033988749895

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   PRIVATE FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Private helper functions (not exported)
_validate_positive(value) =>
    if value <= 0
        runtime.error("Value must be positive")
    true

_safe_divide(numerator, denominator) =>
    denominator == 0 ? na : numerator / denominator

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   PUBLIC FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Calculate geometric mean of an array
// @param values Array of positive numbers
// @returns Geometric mean or na if invalid input
export geometric_mean(array<float> values) =>
    if array.size(values) == 0
        na
    else
        product = 1.0
        for i = 0 to array.size(values) - 1
            val = array.get(values, i)
            if val <= 0
                na
            else
                product *= val
        
        if na(product)
            na
        else
            math.pow(product, 1.0 / array.size(values))
```

---

## Exporting Functions

### Basic Function Export
```pinescript
//@version=6
library("basic_exports")

// @function Simple moving average calculation
// @param source The data series to calculate
// @param length The period for the average
// @returns The simple moving average value
export simple_ma(series float source, simple int length) =>
    ta.sma(source, length)

// @function Check if price is above moving average
// @param price Current price
// @param ma_value Moving average value
// @returns True if price is above MA
export is_above_ma(series float price, series float ma_value) =>
    price > ma_value
```

### Advanced Function Exports with Multiple Return Values
```pinescript
//@version=6
library("advanced_exports")

// @function Calculate Bollinger Bands with additional statistics
// @param source Price source
// @param length Period for calculation
// @param mult Standard deviation multiplier
// @returns [middle, upper, lower, bandwidth, percent_b]
export bollinger_bands_advanced(series float source, simple int length, simple float mult) =>
    basis = ta.sma(source, length)
    dev = mult * ta.stdev(source, length)
    upper = basis + dev
    lower = basis - dev
    
    // Additional calculations
    bandwidth = (upper - lower) / basis * 100
    percent_b = (source - lower) / (upper - lower)
    
    [basis, upper, lower, bandwidth, percent_b]

// @function Multi-timeframe data retrieval
// @param symbol Symbol to get data from
// @param timeframe Timeframe for the data
// @param expression Expression to evaluate
// @returns [value, timestamp, is_new_bar]
export mtf_data(simple string symbol, simple string timeframe, series float expression) =>
    [val, time_val] = request.security(symbol, timeframe, [expression, time])
    is_new = ta.change(time_val) != 0
    [val, time_val, is_new]
```

### Exporting Custom Types
```pinescript
//@version=6
library("type_exports")

// @type Represents a trading signal with all relevant information
// @field signal_type Type of signal (1 for buy, -1 for sell, 0 for neutral)
// @field strength Signal strength (0-100)
// @field confidence Confidence level (0-1)
// @field stop_loss Suggested stop loss price
// @field take_profit Suggested take profit price
// @field timestamp When the signal was generated
export type Signal
    int signal_type
    float strength
    float confidence
    float stop_loss
    float take_profit
    int timestamp

// @function Create a new trading signal
// @param sig_type Signal type (1, -1, or 0)
// @param str Signal strength
// @param conf Confidence level
// @param sl Stop loss price
// @param tp Take profit price
// @returns New Signal object
export new_signal(simple int sig_type, series float str, series float conf, 
                  series float sl, series float tp) =>
    Signal.new(sig_type, str, conf, sl, tp, time)

// @function Validate a trading signal
// @param signal The signal to validate
// @returns True if signal is valid
export validate_signal(Signal signal) =>
    signal.signal_type != 0 and 
    signal.strength > 0 and signal.strength <= 100 and
    signal.confidence > 0 and signal.confidence <= 1
```

---

## Function Documentation

### Documentation Standards
```pinescript
//@version=6
library("documentation_examples")

// @function Calculate Risk-Reward Ratio for a trade
// @param entry_price The price at which the trade was entered
// @param stop_loss The stop loss price for the trade
// @param take_profit The take profit price for the trade
// @returns The risk-reward ratio (reward/risk). Returns na if invalid parameters
// @example
//   // Calculate R:R for a long trade
//   entry = 100.0
//   sl = 95.0
//   tp = 110.0
//   rr = risk_reward_ratio(entry, sl, tp) // Returns 2.0 (10/5)
export risk_reward_ratio(series float entry_price, series float stop_loss, 
                        series float take_profit) =>
    // Validate inputs
    if na(entry_price) or na(stop_loss) or na(take_profit)
        na
    else if entry_price == stop_loss
        na  // Risk would be zero, causing division by zero
    else
        // Calculate risk and reward
        risk = math.abs(entry_price - stop_loss)
        reward = math.abs(take_profit - entry_price)
        
        // Return ratio
        reward / risk

// @function Advanced Position Sizing Calculator
// @param account_balance Total account balance
// @param risk_percent Percentage of account to risk (0-100)
// @param entry_price Entry price for the trade
// @param stop_loss Stop loss price
// @param contract_size Size of one contract (for forex/futures)
// @returns [position_size, risk_amount, max_loss]
// @example
//   // Calculate position size for 2% risk on $10,000 account
//   balance = 10000.0
//   risk_pct = 2.0
//   entry = 1.2500
//   sl = 1.2450
//   [size, risk, loss] = position_size_calculator(balance, risk_pct, entry, sl, 100000)
export position_size_calculator(series float account_balance, series float risk_percent,
                               series float entry_price, series float stop_loss,
                               simple float contract_size = 1.0) =>
    // Input validation
    if na(account_balance) or na(risk_percent) or na(entry_price) or na(stop_loss)
        [na, na, na]
    else if account_balance <= 0 or risk_percent <= 0 or risk_percent > 100
        [na, na, na]
    else if entry_price == stop_loss
        [na, na, na]
    else
        // Calculate risk amount
        risk_amount = account_balance * (risk_percent / 100)
        
        // Calculate pip/point value
        pip_value = math.abs(entry_price - stop_loss)
        
        // Calculate position size
        position_size = (risk_amount / pip_value) * contract_size
        
        // Calculate maximum loss
        max_loss = position_size * pip_value / contract_size
        
        [position_size, risk_amount, max_loss]
```

### Complex Documentation with Multiple Examples
```pinescript
//@version=6
library("complex_docs")

// @function Advanced Market Structure Analysis
// @param high_source High price source
// @param low_source Low price source  
// @param close_source Close price source
// @param swing_length Length for swing point detection
// @param trend_length Length for trend analysis
// @returns [structure_trend, swing_high, swing_low, support_level, resistance_level]
// @example
//   // Basic usage with default OHLC
//   [trend, sh, sl, support, resistance] = market_structure(high, low, close, 10, 50)
//   
//   // Usage with custom data source
//   [trend, sh, sl, support, resistance] = market_structure(request.security(syminfo.tickerid, "1D", high), 
//                                                          request.security(syminfo.tickerid, "1D", low),
//                                                          request.security(syminfo.tickerid, "1D", close), 
//                                                          5, 20)
//   
//   // Interpreting results:
//   // trend: 1 = uptrend, -1 = downtrend, 0 = sideways
//   // sh/sl: Most recent swing high/low prices
//   // support/resistance: Key levels based on market structure
export market_structure(series float high_source, series float low_source, 
                       series float close_source, simple int swing_length = 10,
                       simple int trend_length = 50) =>
    // Swing point detection
    swing_high = ta.pivothigh(high_source, swing_length, swing_length)
    swing_low = ta.pivotlow(low_source, swing_length, swing_length)
    
    // Trend analysis using moving averages
    fast_ma = ta.ema(close_source, trend_length / 2)
    slow_ma = ta.ema(close_source, trend_length)
    
    // Determine trend
    structure_trend = fast_ma > slow_ma and close_source > fast_ma ? 1 :
                     fast_ma < slow_ma and close_source < fast_ma ? -1 : 0
    
    // Key levels (simplified)
    var float support_level = na
    var float resistance_level = na
    
    if not na(swing_high)
        resistance_level := swing_high
    if not na(swing_low)
        support_level := swing_low
    
    [structure_trend, swing_high, swing_low, support_level, resistance_level]
```

---

## Type Exports

### Basic Type Definition and Export
```pinescript
//@version=6
library("basic_types")

// @type Simple price level with metadata
// @field price The price level
// @field strength How strong this level is (1-10)
// @field touch_count Number of times price touched this level
// @field level_type Type of level ("support", "resistance", "pivot")
export type PriceLevel
    float price
    int strength
    int touch_count
    string level_type

// @function Create a new price level
// @param price Price value
// @param strength Strength rating
// @param touches Touch count
// @param type Level type
// @returns New PriceLevel object
export new_price_level(series float price, simple int strength, 
                      simple int touches, simple string type) =>
    PriceLevel.new(price, strength, touches, type)
```

### Advanced Type with Methods
```pinescript
//@version=6
library("advanced_types")

// @type Complete trade record with all necessary information
// @field id Unique identifier for the trade
// @field entry_price Price at which trade was entered
// @field exit_price Price at which trade was exited (na if still open)
// @field quantity Number of shares/contracts
// @field direction 1 for long, -1 for short
// @field entry_time Timestamp of entry
// @field exit_time Timestamp of exit (na if still open)
// @field stop_loss Stop loss price
// @field take_profit Take profit price
// @field status "open", "closed", "cancelled"
// @field pnl Profit/Loss in currency units
// @field pnl_percent Profit/Loss as percentage
export type TradeRecord
    int id
    float entry_price
    float exit_price
    float quantity
    int direction
    int entry_time
    int exit_time
    float stop_loss
    float take_profit
    string status
    float pnl
    float pnl_percent

// @function Create a new trade record
// @param trade_id Unique identifier
// @param entry Entry price
// @param qty Quantity
// @param dir Direction (1 or -1)
// @param sl Stop loss
// @param tp Take profit
// @returns New TradeRecord object
export new_trade(simple int trade_id, series float entry, series float qty,
                simple int dir, series float sl, series float tp) =>
    TradeRecord.new(
        trade_id, entry, na, qty, dir, time, na, sl, tp, "open", na, na)

// @function Update trade with exit information
// @param trade The trade record to update
// @param exit_price Exit price
// @returns Updated trade record
export close_trade(TradeRecord trade, series float exit_price) =>
    // Calculate P&L
    pnl_value = (exit_price - trade.entry_price) * trade.quantity * trade.direction
    pnl_pct = (exit_price - trade.entry_price) / trade.entry_price * 100 * trade.direction
    
    // Update trade record
    trade.exit_price := exit_price
    trade.exit_time := time
    trade.status := "closed"
    trade.pnl := pnl_value
    trade.pnl_percent := pnl_pct
    
    trade

// @function Calculate unrealized P&L for open trade
// @param trade Open trade record
// @param current_price Current market price
// @returns Unrealized P&L value
export unrealized_pnl(TradeRecord trade, series float current_price) =>
    if trade.status != "open"
        0.0
    else
        (current_price - trade.entry_price) * trade.quantity * trade.direction

// @type Portfolio management object
// @field trades Array of all trades
// @field total_pnl Total realized P&L
// @field win_count Number of winning trades
// @field loss_count Number of losing trades
// @field largest_win Largest winning trade P&L
// @field largest_loss Largest losing trade P&L
// @field win_rate Win rate percentage
export type Portfolio
    array<TradeRecord> trades
    float total_pnl
    int win_count
    int loss_count
    float largest_win
    float largest_loss
    float win_rate

// @function Create new portfolio
// @returns New Portfolio object
export new_portfolio() =>
    Portfolio.new(array.new<TradeRecord>(), 0.0, 0, 0, 0.0, 0.0, 0.0)

// @function Add trade to portfolio and update statistics
// @param portfolio Portfolio object
// @param trade Closed trade to add
// @returns Updated portfolio
export add_trade_to_portfolio(Portfolio portfolio, TradeRecord trade) =>
    if trade.status == "closed"
        array.push(portfolio.trades, trade)
        portfolio.total_pnl += trade.pnl
        
        if trade.pnl > 0
            portfolio.win_count += 1
            if trade.pnl > portfolio.largest_win
                portfolio.largest_win := trade.pnl
        else
            portfolio.loss_count += 1
            if trade.pnl < portfolio.largest_loss
                portfolio.largest_loss := trade.pnl
        
        total_trades = portfolio.win_count + portfolio.loss_count
        portfolio.win_rate := total_trades > 0 ? (portfolio.win_count / total_trades) * 100 : 0
    
    portfolio
```

---

## Using External Libraries

### Basic Library Import
```pinescript
//@version=6
indicator("Using External Libraries", overlay=true)

// Import a published library
import username/library_name/1 as lib

// Use library functions
ma_value = lib.advanced_sma(close, 20)
plot(ma_value, "Library SMA", color.blue)
```

### Advanced Library Usage
```pinescript
//@version=6
indicator("Advanced Library Usage", overlay=true)

// Import multiple libraries with aliases
import TradingLibrary/math_utils/2 as math
import TradingLibrary/risk_management/1 as risk
import TradingLibrary/indicators/3 as ind

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                     INPUTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

ma_length = input.int(20, "MA Length")
risk_percent = input.float(2.0, "Risk %", step=0.1)
account_size = input.float(10000, "Account Size")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 USING LIBRARY FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Using math library
geometric_mean = math.geometric_mean(array.from(close[4], close[3], close[2], close[1], close))
harmonic_mean = math.harmonic_mean(array.from(high, low, close))

// Using indicator library
[bb_middle, bb_upper, bb_lower, bb_width, bb_percent] = ind.bollinger_bands_advanced(close, ma_length, 2.0)
rsi_smoothed = ind.smoothed_rsi(close, 14, 3)

// Using risk management library
stop_loss = low * 0.98  // Example stop loss
[position_size, risk_amount, max_loss] = risk.position_size_calculator(
    account_size, risk_percent, close, stop_loss)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                    PLOTTING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Plot Bollinger Bands from library
plot(bb_middle, "BB Middle", color.blue)
plot(bb_upper, "BB Upper", color.gray)
plot(bb_lower, "BB Lower", color.gray)

// Fill between bands
upper_plot = plot(bb_upper, display=display.none)
lower_plot = plot(bb_lower, display=display.none)
fill(upper_plot, lower_plot, color.new(color.blue, 95))

// Plot smoothed RSI in separate pane (would need pane=1 in indicator declaration)
// plot(rsi_smoothed, "Smoothed RSI", color.purple)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              TRADING SIGNAL EXAMPLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Create trading signal using multiple library functions
buy_signal = close > bb_middle and rsi_smoothed < 70 and bb_percent < 0.2
sell_signal = close < bb_middle and rsi_smoothed > 30 and bb_percent > 0.8

// Plot signals
plotshape(buy_signal, "Buy", shape.triangleup, location.belowbar, color.green, size=size.small)
plotshape(sell_signal, "Sell", shape.triangledown, location.abovebar, color.red, size=size.small)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                    INFO TABLE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var table info_table = table.new(position.bottom_right, 2, 5)

if barstate.islast
    table.clear(info_table, 0, 0, 1, 4)
    
    table.cell(info_table, 0, 0, "Library Data", bgcolor=color.navy, text_color=color.white)
    table.cell(info_table, 1, 0, "Value", bgcolor=color.navy, text_color=color.white)
    
    table.cell(info_table, 0, 1, "Position Size")
    table.cell(info_table, 1, 1, str.tostring(position_size, "0"))
    
    table.cell(info_table, 0, 2, "Risk Amount")
    table.cell(info_table, 1, 2, "$" + str.tostring(risk_amount, "0.00"))
    
    table.cell(info_table, 0, 3, "BB Width")
    table.cell(info_table, 1, 3, str.tostring(bb_width, "0.2") + "%")
    
    table.cell(info_table, 0, 4, "Geometric Mean")
    table.cell(info_table, 1, 4, str.tostring(geometric_mean, "0.00"))
```

### Library Aliasing and Namespace Management
```pinescript
//@version=6
strategy("Library Namespace Management", overlay=true)

// Import libraries with descriptive aliases
import TradingLibrary/technical_analysis/1 as ta_lib
import TradingLibrary/risk_management/1 as rm_lib
import TradingLibrary/backtesting/1 as bt_lib
import TradingLibrary/portfolio/1 as pf_lib

// Avoid naming conflicts with built-in functions
// Instead of: import library/utils/1 as ta  // conflicts with ta.*
// Use descriptive aliases: import library/utils/1 as utils

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              ORGANIZED LIBRARY USAGE
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Technical Analysis Functions
signal_strength = ta_lib.calculate_signal_strength(close, volume, 14)
trend_direction = ta_lib.trend_analysis(close, 20, 50)

// Risk Management Functions
position_size = rm_lib.kelly_criterion_sizing(0.6, 1.5, 10000)  // win_rate, avg_win/loss, capital
max_drawdown = rm_lib.calculate_max_drawdown(close, 252)

// Backtesting Functions
[total_return, sharpe_ratio, max_dd] = bt_lib.performance_metrics(close, 252)

// Portfolio Functions
portfolio = pf_lib.new_portfolio()
// Add trades to portfolio as they occur...

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 STRATEGY LOGIC
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Entry conditions using library functions
long_condition = trend_direction > 0 and signal_strength > 70
short_condition = trend_direction < 0 and signal_strength < 30

// Position sizing using library
if long_condition
    strategy.entry("Long", strategy.long, qty=position_size)

if short_condition
    strategy.entry("Short", strategy.short, qty=position_size)

// Exit conditions
strategy.exit("Exit Long", "Long", loss=max_drawdown * close)
strategy.exit("Exit Short", "Short", loss=max_drawdown * close)
```

---

## Library Versioning

### Version Management Strategy
```pinescript
//@version=6

// @description Trading Utilities Library - Version 2.1.0
// @version 2.1.0
// @author TradingLibrary
// 
// Version History:
// 2.1.0 - Added portfolio management functions
// 2.0.0 - Breaking change: Renamed risk_calc to position_sizing
// 1.2.1 - Fixed division by zero in sharpe ratio calculation
// 1.2.0 - Added new volatility functions
// 1.1.0 - Added risk management functions
// 1.0.0 - Initial release
library("trading_utils")

// Version constant for runtime checking
export VERSION = "2.1.0"
export VERSION_MAJOR = 2
export VERSION_MINOR = 1
export VERSION_PATCH = 0

// Compatibility function for old API
// @deprecated Use position_sizing() instead. Will be removed in v3.0.0
export risk_calc(series float capital, series float risk_pct, 
                series float entry, series float stop) =>
    // Warn users about deprecation
    if barstate.islast
        runtime.error("risk_calc() is deprecated. Use position_sizing() instead.")
    
    // Call new function
    position_sizing(capital, risk_pct, entry, stop)

// New API function
export position_sizing(series float capital, series float risk_percent,
                      series float entry_price, series float stop_loss) =>
    if capital <= 0 or risk_percent <= 0 or entry_price <= 0
        na
    else
        risk_amount = capital * (risk_percent / 100)
        risk_per_share = math.abs(entry_price - stop_loss)
        risk_per_share == 0 ? na : risk_amount / risk_per_share
```

### Backward Compatibility Handling
```pinescript
//@version=6

// @description Backward Compatible Library Example
// @version 3.0.0
library("compat_example")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                COMPATIBILITY LAYER
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Old function signatures for backward compatibility
// @deprecated Use enhanced_sma() instead
export simple_moving_average(series float src, simple int len) =>
    enhanced_sma(src, len, "simple")

// @deprecated Use enhanced_rsi() instead  
export basic_rsi(series float src, simple int len) =>
    [rsi_val, _] = enhanced_rsi(src, len, false)
    rsi_val

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                  NEW API (V3.0.0)
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Enhanced SMA with multiple algorithms
// @param source Data source
// @param length Period
// @param method Calculation method ("simple", "exponential", "weighted")
// @returns Moving average value
export enhanced_sma(series float source, simple int length, simple string method = "simple") =>
    switch method
        "simple" => ta.sma(source, length)
        "exponential" => ta.ema(source, length)
        "weighted" => ta.wma(source, length)
        => ta.sma(source, length)  // Default fallback

// @function Enhanced RSI with smoothing option
// @param source Data source
// @param length RSI period
// @param smooth Enable smoothing
// @returns [rsi_value, smoothed_rsi]
export enhanced_rsi(series float source, simple int length, simple bool smooth = false) =>
    rsi_val = ta.rsi(source, length)
    smoothed_rsi = smooth ? ta.sma(rsi_val, 3) : rsi_val
    [rsi_val, smoothed_rsi]
```

---

## Best Practices for Library Design

### Modular Library Architecture
```pinescript
//@version=6

// @description Best Practices Library - Mathematical Functions Module
library("math_functions")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                 INPUT VALIDATION
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// Private validation functions
_validate_array_not_empty(array<float> arr) =>
    if array.size(arr) == 0
        runtime.error("Array cannot be empty")
    true

_validate_positive(float value, string param_name) =>
    if value <= 0
        runtime.error(param_name + " must be positive")
    true

_validate_range(float value, float min_val, float max_val, string param_name) =>
    if value < min_val or value > max_val
        runtime.error(param_name + " must be between " + str.tostring(min_val) + 
                     " and " + str.tostring(max_val))
    true

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               STATISTICAL FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Calculate skewness of a data series
// @param values Array of values
// @returns Skewness value (positive = right tail, negative = left tail)
export skewness(array<float> values) =>
    _validate_array_not_empty(values)
    
    size = array.size(values)
    if size < 3
        na  // Need at least 3 points for skewness
    else
        // Calculate mean
        sum = 0.0
        for i = 0 to size - 1
            sum += array.get(values, i)
        mean_val = sum / size
        
        // Calculate standard deviation and skewness
        sum_squared_diff = 0.0
        sum_cubed_diff = 0.0
        
        for i = 0 to size - 1
            diff = array.get(values, i) - mean_val
            sum_squared_diff += diff * diff
            sum_cubed_diff += diff * diff * diff
        
        variance = sum_squared_diff / (size - 1)
        std_dev = math.sqrt(variance)
        
        if std_dev == 0
            na
        else
            skew = (sum_cubed_diff / size) / math.pow(std_dev, 3)
            skew * size / ((size - 1) * (size - 2))  // Sample skewness adjustment

// @function Calculate kurtosis of a data series
// @param values Array of values
// @returns Kurtosis value (excess kurtosis, 0 = normal distribution)
export kurtosis(array<float> values) =>
    _validate_array_not_empty(values)
    
    size = array.size(values)
    if size < 4
        na  // Need at least 4 points for kurtosis
    else
        // Calculate mean
        sum = 0.0
        for i = 0 to size - 1
            sum += array.get(values, i)
        mean_val = sum / size
        
        // Calculate moments
        sum_squared_diff = 0.0
        sum_fourth_diff = 0.0
        
        for i = 0 to size - 1
            diff = array.get(values, i) - mean_val
            squared_diff = diff * diff
            sum_squared_diff += squared_diff
            sum_fourth_diff += squared_diff * squared_diff
        
        variance = sum_squared_diff / size
        
        if variance == 0
            na
        else
            kurt = (sum_fourth_diff / size) / math.pow(variance, 2)
            # Excess kurtosis (subtract 3 for normal distribution baseline)
            kurt - 3.0

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               ARRAY UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Find percentile value in array
// @param values Array of values
// @param percentile Percentile to find (0-100)
// @returns Value at specified percentile
export percentile(array<float> values, simple float percentile) =>
    _validate_array_not_empty(values)
    _validate_range(percentile, 0.0, 100.0, "percentile")
    
    // Create copy and sort
    sorted_values = array.copy(values)
    array.sort(sorted_values)
    
    size = array.size(sorted_values)
    index = (percentile / 100.0) * (size - 1)
    
    if index == math.floor(index)
        # Exact index
        array.get(sorted_values, int(index))
    else
        # Interpolate between values
        lower_index = int(math.floor(index))
        upper_index = int(math.ceil(index))
        weight = index - math.floor(index)
        
        lower_val = array.get(sorted_values, lower_index)
        upper_val = array.get(sorted_values, upper_index)
        
        lower_val + weight * (upper_val - lower_val)

// @function Calculate rolling correlation between two arrays
// @param array1 First data array
// @param array2 Second data array
// @param window Rolling window size
// @returns Array of correlation values
export rolling_correlation(array<float> array1, array<float> array2, simple int window) =>
    _validate_array_not_empty(array1)
    _validate_array_not_empty(array2)
    _validate_positive(window, "window")
    
    size1 = array.size(array1)
    size2 = array.size(array2)
    
    if size1 != size2
        runtime.error("Arrays must have the same size")
    
    if size1 < window
        runtime.error("Arrays must be larger than window size")
    
    correlations = array.new<float>()
    
    for i = window - 1 to size1 - 1
        # Extract window data
        x_window = array.new<float>()
        y_window = array.new<float>()
        
        for j = i - window + 1 to i
            array.push(x_window, array.get(array1, j))
            array.push(y_window, array.get(array2, j))
        
        # Calculate correlation for this window
        x_mean = array.avg(x_window)
        y_mean = array.avg(y_window)
        
        numerator = 0.0
        x_sum_sq = 0.0
        y_sum_sq = 0.0
        
        for k = 0 to window - 1
            x_diff = array.get(x_window, k) - x_mean
            y_diff = array.get(y_window, k) - y_mean
            
            numerator += x_diff * y_diff
            x_sum_sq += x_diff * x_diff
            y_sum_sq += y_diff * y_diff
        
        denominator = math.sqrt(x_sum_sq * y_sum_sq)
        correlation = denominator == 0 ? 0 : numerator / denominator
        
        array.push(correlations, correlation)
    
    correlations

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                ERROR HANDLING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Safe division with error handling
// @param numerator Numerator value
// @param denominator Denominator value
// @param default_value Value to return if division by zero
// @returns Division result or default value
export safe_divide(series float numerator, series float denominator, 
                  series float default_value = na) =>
    if denominator == 0 or na(denominator)
        default_value
    else
        numerator / denominator

// @function Safe logarithm calculation
// @param value Input value
// @param base Logarithm base (default: natural log)
// @returns Logarithm or na if invalid
export safe_log(series float value, simple float base = math.e) =>
    if value <= 0 or base <= 0 or base == 1
        na
    else
        math.log(value) / math.log(base)
```

---

## Distribution and Sharing

### Publication Guidelines
```pinescript
//@version=6

// @description Professional Trading Library for Pine Script v6
// @author YourTradingName
// @version 1.0.0
//
// USAGE LICENSE:
// This library is provided under MIT License.
// Feel free to use in your own scripts with attribution.
//
// DOCUMENTATION:
// Full documentation available at: https://your-website.com/docs
//
// SUPPORT:
// For support and feature requests: https://your-website.com/support
//
// CHANGELOG:
// v1.0.0 - Initial release with core functions
library("professional_trading_lib")

// Export version for runtime checking
export VERSION = "1.0.0"

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                    CORE EXPORTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Calculate dynamic position sizing based on volatility
// @param account_balance Total account balance
// @param risk_percent Risk percentage (1-5 recommended)
// @param atr_value Current ATR value
// @param atr_multiplier ATR multiplier for stop distance (default: 2.0)
// @returns Recommended position size
export dynamic_position_size(series float account_balance, series float risk_percent,
                            series float atr_value, simple float atr_multiplier = 2.0) =>
    if account_balance <= 0 or risk_percent <= 0 or atr_value <= 0
        na
    else
        risk_amount = account_balance * (risk_percent / 100)
        stop_distance = atr_value * atr_multiplier
        risk_amount / stop_distance

// Add more professional functions...
```

### Library Testing Framework
```pinescript
//@version=6
indicator("Library Test Suite", overlay=false)

// Import the library to test
import YourUsername/your_library/1 as lib

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   TEST FRAMEWORK
// ═══════════════════════════════════════════════════════════════════════════════════════════════

var int test_count = 0
var int passed_tests = 0
var int failed_tests = 0

// Test helper functions
test_assert(bool condition, string test_name) =>
    test_count += 1
    if condition
        passed_tests += 1
        if barstate.islast
            log.info("✅ PASS: " + test_name)
    else
        failed_tests += 1
        if barstate.islast
            log.error("❌ FAIL: " + test_name)

test_assert_equal(float actual, float expected, string test_name, float tolerance = 0.0001) =>
    test_assert(math.abs(actual - expected) <= tolerance, test_name)

test_assert_na(float value, string test_name) =>
    test_assert(na(value), test_name)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                   UNIT TESTS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

if barstate.islast
    // Test basic mathematical functions
    test_assert_equal(lib.safe_divide(10, 2), 5, "Safe divide normal case")
    test_assert_na(lib.safe_divide(10, 0), "Safe divide by zero")
    
    // Test array functions
    test_array = array.from(1.0, 2.0, 3.0, 4.0, 5.0)
    test_assert_equal(lib.percentile(test_array, 50), 3.0, "Median calculation")
    test_assert_equal(lib.percentile(test_array, 0), 1.0, "Min percentile")
    test_assert_equal(lib.percentile(test_array, 100), 5.0, "Max percentile")
    
    // Test position sizing
    position_size = lib.dynamic_position_size(10000, 2, 1.0, 2.0)
    test_assert_equal(position_size, 100, "Position sizing calculation")
    
    // Display test results
    log.info("📊 Test Results: " + str.tostring(passed_tests) + "/" + 
             str.tostring(test_count) + " tests passed")
    
    if failed_tests > 0
        log.error("❌ " + str.tostring(failed_tests) + " tests failed!")
    else
        log.info("✅ All tests passed!")

// Visual test results
plot(passed_tests, "Passed Tests", color.green)
plot(failed_tests, "Failed Tests", color.red)
plot(test_count, "Total Tests", color.blue)
```

---

## Examples of Utility Libraries

### Complete Mathematics Library
```pinescript
//@version=6

// @description Advanced Mathematics Library for Pine Script v6
// @author MathLibrary
// @version 1.0.0
library("advanced_math")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                               STATISTICAL FUNCTIONS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Calculate Z-Score for a value
// @param value The value to calculate Z-score for
// @param mean Mean of the distribution
// @param std_dev Standard deviation of the distribution
// @returns Z-score value
export zscore(series float value, series float mean, series float std_dev) =>
    std_dev == 0 ? na : (value - mean) / std_dev

// @function Calculate confidence interval
// @param values Array of values
// @param confidence_level Confidence level (0.95 for 95%)
// @returns [lower_bound, upper_bound]
export confidence_interval(array<float> values, simple float confidence_level = 0.95) =>
    if array.size(values) < 2
        [na, na]
    else
        mean_val = array.avg(values)
        std_dev = array.stdev(values)
        n = array.size(values)
        
        # t-value approximation for large samples
        alpha = 1 - confidence_level
        t_value = alpha < 0.1 ? 1.96 : alpha < 0.05 ? 2.576 : 1.96  // Simplified
        
        margin_error = t_value * (std_dev / math.sqrt(n))
        [mean_val - margin_error, mean_val + margin_error]

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                FINANCIAL MATH
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Calculate compound annual growth rate (CAGR)
// @param beginning_value Starting value
// @param ending_value Ending value
// @param years Number of years
// @returns CAGR as decimal (0.10 = 10%)
export cagr(series float beginning_value, series float ending_value, simple float years) =>
    if beginning_value <= 0 or ending_value <= 0 or years <= 0
        na
    else
        math.pow(ending_value / beginning_value, 1 / years) - 1

// @function Calculate maximum drawdown
// @param equity_curve Array of equity values
// @returns Maximum drawdown as percentage
export max_drawdown(array<float> equity_curve) =>
    if array.size(equity_curve) < 2
        na
    else
        max_dd = 0.0
        peak = array.get(equity_curve, 0)
        
        for i = 1 to array.size(equity_curve) - 1
            value = array.get(equity_curve, i)
            if value > peak
                peak := value
            else
                drawdown = (peak - value) / peak
                if drawdown > max_dd
                    max_dd := drawdown
        
        max_dd * 100  // Return as percentage

// @function Calculate Sharpe ratio
// @param returns Array of returns
// @param risk_free_rate Risk-free rate (annual)
// @param periods_per_year Trading periods per year (252 for daily)
// @returns Sharpe ratio
export sharpe_ratio(array<float> returns, simple float risk_free_rate = 0.02,
                   simple int periods_per_year = 252) =>
    if array.size(returns) < 2
        na
    else
        avg_return = array.avg(returns)
        std_return = array.stdev(returns)
        
        if std_return == 0
            na
        else
            risk_free_period = risk_free_rate / periods_per_year
            excess_return = avg_return - risk_free_period
            (excess_return / std_return) * math.sqrt(periods_per_year)
```

### Complete Risk Management Library
```pinescript
//@version=6

// @description Risk Management Library for Pine Script v6
// @author RiskLibrary  
// @version 1.0.0
library("risk_management")

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                              POSITION SIZING
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Kelly Criterion position sizing
// @param win_probability Probability of winning (0-1)
// @param avg_win_loss_ratio Average win to average loss ratio
// @param capital Total capital
// @returns Optimal position size
export kelly_criterion(series float win_probability, series float avg_win_loss_ratio,
                      series float capital) =>
    if win_probability <= 0 or win_probability >= 1 or avg_win_loss_ratio <= 0 or capital <= 0
        na
    else
        kelly_percent = (win_probability * avg_win_loss_ratio - (1 - win_probability)) / avg_win_loss_ratio
        # Cap at 25% for safety
        safe_kelly = math.min(kelly_percent, 0.25)
        capital * safe_kelly

// @function Fixed ratio position sizing
// @param net_profit Current net profit
// @param delta Dollar amount to increase position size
// @param base_contracts Base number of contracts
// @returns Number of contracts to trade
export fixed_ratio_sizing(series float net_profit, simple float delta, simple int base_contracts = 1) =>
    if net_profit <= 0 or delta <= 0
        base_contracts
    else
        additional_contracts = math.sqrt(net_profit / delta)
        base_contracts + int(additional_contracts)

// ═══════════════════════════════════════════════════════════════════════════════════════════════
//                                RISK METRICS
// ═══════════════════════════════════════════════════════════════════════════════════════════════

// @function Calculate Value at Risk (VaR)
// @param returns Array of returns
// @param confidence_level Confidence level (0.95 for 95%)
// @returns VaR value
export value_at_risk(array<float> returns, simple float confidence_level = 0.95) =>
    if array.size(returns) < 10
        na
    else
        percentile_level = (1 - confidence_level) * 100
        sorted_returns = array.copy(returns)
        array.sort(sorted_returns)
        
        index = int((percentile_level / 100) * array.size(sorted_returns))
        array.get(sorted_returns, index)

// @function Calculate portfolio beta
// @param asset_returns Array of asset returns
// @param market_returns Array of market returns
// @returns Beta value
export portfolio_beta(array<float> asset_returns, array<float> market_returns) =>
    if array.size(asset_returns) != array.size(market_returns) or array.size(asset_returns) < 2
        na
    else
        asset_variance = array.variance(asset_returns)
        market_variance = array.variance(market_returns)
        
        if market_variance == 0
            na
        else
            # Calculate covariance
            asset_mean = array.avg(asset_returns)
            market_mean = array.avg(market_returns)
            covariance = 0.0
            
            for i = 0 to array.size(asset_returns) - 1
                asset_dev = array.get(asset_returns, i) - asset_mean
                market_dev = array.get(market_returns, i) - market_mean
                covariance += asset_dev * market_dev
            
            covariance := covariance / (array.size(asset_returns) - 1)
            covariance / market_variance
```

This comprehensive guide provides Pine Script developers with everything needed to create, document, version, and distribute professional libraries. The examples demonstrate real-world patterns and best practices for building reusable code components that can be shared across the Pine Script community.