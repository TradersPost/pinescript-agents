# TradingView Platform Documentation

This comprehensive guide covers the TradingView platform ecosystem and how Pine Script v6 integrates within it. Understanding these platform fundamentals is essential for creating successful indicators and strategies.

## Table of Contents

1. [Platform Overview](#platform-overview)
2. [Publishing Guidelines](#publishing-guidelines)
3. [Chart Integration](#chart-integration)
4. [Alerts System](#alerts-system)
5. [Broker Integration](#broker-integration)
6. [Community Features](#community-features)
7. [Platform Limits](#platform-limits)
8. [Best Practices](#best-practices)

---

## Platform Overview

### TradingView Environment

TradingView is a cloud-based charting and social trading platform that executes Pine Script indicators and strategies server-side. Understanding this environment is crucial for effective script development.

#### Key Characteristics:
- **Cloud-based execution**: Scripts run on TradingView's servers, not user devices
- **Multi-device synchronization**: Charts and scripts sync across all devices
- **Real-time data processing**: Live market data feeds with millisecond precision
- **Historical data access**: Extensive historical datasets for backtesting
- **Browser-based interface**: No installation required, works across platforms

### Script Execution Model

Pine Script follows a unique execution model that differs from traditional programming:

```pine
//@version=6
indicator("Execution Model Example", overlay=true)

// This code executes on EVERY bar in the dataset
// From the first available bar to the current bar
sma20 = ta.sma(close, 20)
plot(sma20, "SMA 20", color.blue)

// Real-time execution happens on the rightmost bar
// as new ticks arrive
```

#### Execution Flow:
1. **Historical Calculation**: Script runs on all historical bars first
2. **Real-time Updates**: Recalculates on current bar with each new tick
3. **Bar Confirmation**: Values "lock in" when bar closes
4. **Memory Management**: Limited lookback to prevent memory issues

### Cloud-Based Processing

#### Advantages:
- **Consistent Performance**: Server-grade hardware ensures reliable execution
- **No Local Resource Usage**: Doesn't consume user's CPU/memory
- **Always Available**: Scripts run 24/7 without user intervention
- **Automatic Updates**: Platform improvements benefit all scripts

#### Considerations:
- **Internet Dependency**: Requires stable internet connection
- **Execution Limits**: Server resources are shared and limited
- **Data Limits**: Restrictions on data access and API calls

### Real-time vs Historical Data

Understanding the difference between historical and real-time data is crucial:

```pine
//@version=6
indicator("Data Types Example")

// Historical bars: Complete OHLC data
// Real-time bar: OHLC updates with each tick

// This can cause different behavior:
highest_high = ta.highest(high, 20)

// On historical bars: Uses final high of each bar
// On real-time bar: Updates with each new high tick
```

#### Key Differences:
- **Historical**: Complete, confirmed bar data
- **Real-time**: Incomplete, updating bar data
- **Repainting**: When real-time values differ from historical
- **Bar State**: `barstate.isconfirmed` helps distinguish

---

## Publishing Guidelines

### House Rules

TradingView maintains strict publishing standards to ensure quality and prevent spam:

#### Content Requirements:
- **Original Work**: Scripts must be your own creation or properly attributed
- **Educational Value**: Must provide genuine utility to the community
- **No Spam**: Avoid duplicate or low-effort publications
- **Appropriate Naming**: Clear, descriptive titles without promotional language
- **Quality Code**: Well-structured, commented, and functional scripts

#### Prohibited Content:
- **Repainting Strategies**: Without clear disclosure and educational purpose
- **Promotional Scripts**: Designed primarily to advertise services
- **Copied Code**: Unattributed work from other authors
- **Misleading Claims**: Unrealistic performance promises
- **Spam Variations**: Multiple similar scripts with minor differences

### Script Requirements

#### Technical Standards:
```pine
//@version=6
// Required: Version declaration

// Required: Proper script declaration
indicator("My Indicator", shorttitle="MI", overlay=true)
// OR
strategy("My Strategy", shorttitle="MS", overlay=false)

// Required: Meaningful inputs with descriptions
length = input.int(14, "Period", minval=1, tooltip="Number of bars for calculation")

// Required: Clear, commented logic
rsi_value = ta.rsi(close, length)  // Calculate RSI
plot(rsi_value, "RSI", color.blue)  // Plot with clear title
```

#### Documentation Standards:
- **Clear Description**: Explain what the script does and how to use it
- **Input Parameters**: Document all user-configurable settings
- **Visual Elements**: Describe plots, colors, and visual features
- **Limitations**: Mention any constraints or special considerations
- **Examples**: Provide usage examples when helpful

### Moderation Process

#### Review Stages:
1. **Automated Checks**: Basic syntax and rule compliance
2. **Community Review**: Public scripts undergo peer review
3. **Moderator Review**: Staff review for policy compliance
4. **Publication**: Approved scripts become publicly available

#### Timeline:
- **Public Scripts**: 1-3 days for moderator review
- **Private Scripts**: Immediate availability to author
- **Updates**: Usually processed within 24 hours

### Private vs Public Scripts

#### Private Scripts:
- **Immediate Access**: Available instantly after saving
- **Personal Use**: Only visible to the author
- **No Review Process**: Not subject to moderation
- **Limited Sharing**: Can share via invite-only links
- **Full Functionality**: All features available

#### Public Scripts:
- **Community Access**: Available to all TradingView users
- **Moderation Required**: Subject to review process
- **Quality Standards**: Must meet publishing guidelines
- **Reputation Building**: Contributes to author reputation
- **Broader Impact**: Can help and educate the community

---

## Chart Integration

### How Scripts Interact with Charts

Pine Script indicators and strategies integrate seamlessly with TradingView charts:

```pine
//@version=6
indicator("Chart Integration Example", overlay=true)

// Overlay = true: Plots on main chart with price data
support_level = ta.lowest(low, 50)
plot(support_level, "Support", color.green, linewidth=2)

// Overlay = false: Creates separate pane below chart
// indicator("Chart Integration Example", overlay=false)
// rsi = ta.rsi(close, 14)
// plot(rsi, "RSI", color.purple)
```

#### Integration Types:
- **Overlay Indicators**: Plot directly on price chart
- **Oscillators**: Display in separate pane below chart
- **Strategies**: Show trades and performance metrics
- **Drawing Tools**: Add lines, boxes, and labels to chart

### Drawing on Main Chart vs Panes

#### Main Chart (overlay=true):
- **Price-based Plots**: Support/resistance, moving averages, Bollinger Bands
- **Chart Patterns**: Trend lines, channels, geometric patterns
- **Entry/Exit Signals**: Buy/sell arrows and markers
- **Price Levels**: Fibonacci retracements, pivot points

```pine
//@version=6
indicator("Main Chart Example", overlay=true)

// Price-based indicators on main chart
ema20 = ta.ema(close, 20)
ema50 = ta.ema(close, 50)

plot(ema20, "EMA 20", color.blue)
plot(ema50, "EMA 50", color.red)

// Signal arrows
bullish_cross = ta.crossover(ema20, ema50)
bearish_cross = ta.crossunder(ema20, ema50)

plotshape(bullish_cross, "Bull Cross", shape.triangleup, location.belowbar, color.green)
plotshape(bearish_cross, "Bear Cross", shape.triangledown, location.abovebar, color.red)
```

#### Separate Panes (overlay=false):
- **Momentum Oscillators**: RSI, MACD, Stochastic
- **Volume Indicators**: Volume profile, OBV, volume oscillators
- **Volatility Measures**: ATR, Bollinger Band width
- **Custom Metrics**: Proprietary calculations and ratios

```pine
//@version=6
indicator("Separate Pane Example", overlay=false)

// Oscillator in separate pane
rsi = ta.rsi(close, 14)
plot(rsi, "RSI", color.purple)

// Horizontal reference lines
hline(70, "Overbought", color.red, linestyle.dashed)
hline(30, "Oversold", color.green, linestyle.dashed)
hline(50, "Midline", color.gray)

// Color background based on conditions
bgcolor(rsi > 70 ? color.new(color.red, 90) : rsi < 30 ? color.new(color.green, 90) : na)
```

### Scale Settings

#### Price Scale vs Indicator Scale:
- **Price Scale**: Uses same scale as price data (for overlay indicators)
- **Indicator Scale**: Independent scale optimized for indicator values
- **Auto-scaling**: TradingView automatically adjusts scales for best fit
- **Manual Scaling**: Users can lock scales or set custom ranges

#### Scale Configuration:
```pine
//@version=6
indicator("Scale Configuration", overlay=false, scale=scale.right)

// scale.right: Places scale on right side
// scale.left: Places scale on left side
// scale.none: No scale display

rsi = ta.rsi(close, 14)
plot(rsi, "RSI")

// Format scale values
scale_format = format.percent  // Shows values as percentages
// scale_format = format.price    // Shows as price values
// scale_format = format.volume   // Shows as volume values
```

### Visual Hierarchy

#### Z-order (Drawing Order):
1. **Background Elements**: Filled areas, background colors
2. **Lines and Plots**: Main indicator lines
3. **Shapes and Markers**: Entry/exit signals, arrows
4. **Labels and Text**: Information displays
5. **Tables**: Data tables and statistics

```pine
//@version=6
indicator("Visual Hierarchy Example", overlay=true)

// Background (drawn first, appears behind)
bgcolor(color.new(color.blue, 95))

// Main plots (middle layer)
sma = ta.sma(close, 20)
plot(sma, "SMA", color.blue, linewidth=2)

// Shapes (front layer)
buy_signal = ta.crossover(close, sma)
plotshape(buy_signal, "Buy", shape.triangleup, location.belowbar, color.green, size=size.normal)

// Labels (front layer)
if buy_signal
    label.new(bar_index, low, "BUY", style=label.style_label_up, color=color.green, textcolor=color.white)
```

---

## Alerts System

### Alert Types

TradingView offers multiple alert types for different use cases:

#### Basic Alerts:
```pine
//@version=6
indicator("Basic Alerts", overlay=true)

rsi = ta.rsi(close, 14)
ema = ta.ema(close, 20)

// Condition-based alert
overbought = rsi > 70
oversold = rsi < 30
trend_change = ta.crossover(close, ema)

// Create alert conditions
alertcondition(overbought, "RSI Overbought", "RSI is above 70")
alertcondition(oversold, "RSI Oversold", "RSI is below 30")
alertcondition(trend_change, "Trend Change", "Price crossed above EMA")
```

#### Strategy Alerts:
```pine
//@version=6
strategy("Strategy Alerts", overlay=true)

// Strategy alerts fire on entry/exit signals
if ta.crossover(ta.ema(close, 10), ta.ema(close, 20))
    strategy.entry("Long", strategy.long)
    
if ta.crossunder(ta.ema(close, 10), ta.ema(close, 20))
    strategy.close("Long")

// Alerts automatically trigger on strategy.entry() and strategy.close()
```

#### Custom Alert Messages:
```pine
//@version=6
indicator("Custom Alert Messages", overlay=true)

rsi = ta.rsi(close, 14)

// Dynamic alert messages with variables
if rsi > 70
    alert("RSI Overbought: " + str.tostring(rsi, "#.##") + " on " + syminfo.ticker, alert.freq_once_per_bar)

if rsi < 30
    alert("RSI Oversold: " + str.tostring(rsi, "#.##") + " on " + syminfo.ticker, alert.freq_once_per_bar)
```

### Webhook Integration

#### Webhook Setup:
```pine
//@version=6
strategy("Webhook Integration", overlay=true)

// JSON message for webhook
webhook_message = '{"action": "buy", "symbol": "' + syminfo.ticker + '", "price": ' + str.tostring(close) + '}'

if ta.crossover(ta.ema(close, 10), ta.ema(close, 20))
    strategy.entry("Long", strategy.long, alert_message=webhook_message)
```

#### Common Webhook Uses:
- **Trading Bots**: Automated order execution
- **Notifications**: Discord, Slack, Telegram integration
- **Data Logging**: Send trade data to external databases
- **Portfolio Management**: Update position tracking systems

### Alert Limitations

#### Frequency Limits:
- **Once Per Bar**: Alert fires maximum once per bar close
- **Once Per Bar Close**: Only on confirmed bar close
- **All**: Alert fires on every condition match (can be frequent)

#### Plan-Based Limits:
- **Free**: Limited alerts, basic functionality
- **Pro**: More alerts, SMS notifications
- **Pro+**: Higher limits, phone call alerts
- **Premium**: Maximum alerts, priority processing

#### Technical Constraints:
```pine
//@version=6
indicator("Alert Constraints", overlay=true)

var int alert_count = 0

if ta.crossover(close, ta.ema(close, 20))
    alert_count += 1
    // Be mindful of alert frequency to avoid hitting limits
    if alert_count % 10 == 0  // Only alert every 10th signal
        alert("Trend change detected", alert.freq_once_per_bar)
```

### Server-Side Execution

#### How It Works:
- **Continuous Monitoring**: Alerts run 24/7 on TradingView servers
- **Real-time Processing**: Conditions checked with each new tick
- **Instant Delivery**: Notifications sent immediately when triggered
- **Reliability**: Server redundancy ensures consistent operation

#### Benefits:
- **No User Device Required**: Works even when computer is off
- **Global Market Coverage**: Monitors markets across all time zones
- **Instant Response**: Faster than client-side monitoring
- **Reliability**: Professional server infrastructure

---

## Broker Integration

### Paper Trading

Paper trading allows testing strategies with virtual money before risking real capital:

```pine
//@version=6
strategy("Paper Trading Example", overlay=true, default_qty_type=strategy.percent_of_equity, default_qty_value=10)

// Strategy logic
ema_fast = ta.ema(close, 10)
ema_slow = ta.ema(close, 20)

if ta.crossover(ema_fast, ema_slow)
    strategy.entry("Long", strategy.long)
    
if ta.crossunder(ema_fast, ema_slow)
    strategy.close("Long")

// Paper trading provides:
// - Virtual portfolio tracking
// - Realistic order execution simulation
// - Performance metrics
// - Risk management testing
```

#### Paper Trading Benefits:
- **Risk-Free Testing**: No real money at risk
- **Realistic Simulation**: Mirrors real market conditions
- **Strategy Validation**: Prove concepts before live trading
- **Performance Analysis**: Detailed metrics and statistics

### Broker Connections

TradingView integrates with numerous brokers for live trading:

#### Supported Brokers:
- **OANDA**: Forex and CFD trading
- **Interactive Brokers**: Comprehensive global markets
- **TradeStation**: Stocks, options, futures
- **TD Ameritrade**: US stocks and options
- **Many Others**: Growing list of integrated brokers

#### Connection Process:
1. **Account Verification**: Link verified broker account
2. **Authorization**: Grant TradingView trading permissions
3. **Strategy Deployment**: Deploy Pine Script strategies
4. **Live Monitoring**: Monitor real-time execution

### Order Execution

#### Order Types Available:
```pine
//@version=6
strategy("Order Types", overlay=true)

// Market orders (immediate execution)
if buy_condition
    strategy.entry("Long", strategy.long)

// Limit orders (at specific price)
if buy_condition
    strategy.entry("Long Limit", strategy.long, limit=close * 0.99)

// Stop orders (triggered at specific price)
if long_position
    strategy.exit("Stop Loss", "Long", stop=close * 0.95)

// OCO orders (one-cancels-other)
if long_position
    strategy.exit("TP/SL", "Long", limit=close * 1.05, stop=close * 0.95)
```

#### Execution Considerations:
- **Slippage**: Difference between expected and actual execution price
- **Market Hours**: Orders execute only during trading hours
- **Liquidity**: Low liquidity can affect execution quality
- **Latency**: Small delays between signal and execution

### Strategy Tester Details

The built-in strategy tester provides comprehensive backtesting:

```pine
//@version=6
strategy("Strategy Tester Features", overlay=true, 
         initial_capital=100000,
         default_qty_type=strategy.percent_of_equity, 
         default_qty_value=10,
         commission_type=strategy.commission.percent,
         commission_value=0.1)

// Strategy logic here...

// The tester automatically provides:
// - Profit/Loss calculations
// - Drawdown analysis  
// - Sharpe ratio
// - Win rate statistics
// - Trade-by-trade details
```

#### Key Metrics:
- **Total Return**: Overall profit/loss percentage
- **Sharpe Ratio**: Risk-adjusted return measure
- **Maximum Drawdown**: Largest peak-to-trough decline
- **Win Rate**: Percentage of profitable trades
- **Profit Factor**: Gross profit / gross loss ratio

---

## Community Features

### Script Sharing

TradingView's community features enable knowledge sharing and collaboration:

#### Publishing Options:
- **Public Scripts**: Available to entire community
- **Invite-Only**: Private sharing with specific users
- **Protected Scripts**: Code hidden, functionality available
- **Open Source**: Full code visibility and modification rights

```pine
//@version=6
// Example of community-friendly script structure
indicator("Community RSI Enhanced", "C-RSI", overlay=false)

// Clear input organization
group_rsi = "RSI Settings"
rsi_length = input.int(14, "RSI Length", minval=1, group=group_rsi)
rsi_source = input.source(close, "RSI Source", group=group_rsi)

group_visual = "Visual Settings"
rsi_color = input.color(color.purple, "RSI Color", group=group_visual)
show_levels = input.bool(true, "Show OB/OS Levels", group=group_visual)

// Well-documented calculation
rsi = ta.rsi(rsi_source, rsi_length)

// Clear plotting with options
plot(rsi, "RSI", color=rsi_color, linewidth=2)

if show_levels
    hline(70, "Overbought", color.red, linestyle.dashed)
    hline(30, "Oversold", color.green, linestyle.dashed)
```

### Reputation System

#### Building Reputation:
- **Quality Scripts**: Publish useful, well-documented indicators
- **Community Engagement**: Help others with comments and suggestions
- **Regular Activity**: Consistent contributions over time
- **Educational Content**: Share knowledge and insights

#### Reputation Benefits:
- **Higher Visibility**: Scripts appear more prominently
- **Community Trust**: Users more likely to try your scripts
- **Collaboration Opportunities**: Connect with other developers
- **Platform Recognition**: TradingView may feature quality contributors

### Comments and Ratings

#### Engaging with Community:
```pine
//@version=6
indicator("Community Engagement Example", overlay=true)

// Respond to user feedback in script updates
// Version 1.1: Added user-requested stop loss feature
// Version 1.2: Fixed issue reported by @username
// Version 1.3: Enhanced based on community suggestions

// Document changes and improvements
// This helps build trust and shows responsiveness
```

#### Best Practices:
- **Respond to Comments**: Engage with users who provide feedback
- **Address Issues**: Fix bugs and problems promptly
- **Consider Suggestions**: Implement valuable community ideas
- **Thank Contributors**: Acknowledge helpful feedback and reports

### Following Authors

#### Building a Following:
- **Consistent Quality**: Maintain high standards across all scripts
- **Regular Updates**: Keep scripts current and functional
- **Educational Content**: Provide learning value, not just tools
- **Community Interaction**: Be helpful and responsive

#### Benefits of Followers:
- **Immediate Audience**: New scripts reach followers first
- **Feedback Loop**: Regular users provide valuable input
- **Collaboration**: Potential for joint projects
- **Motivation**: Community support encourages continued development

---

## Platform Limits

### Concurrent Script Limits

#### Per Chart Limits:
- **Indicators**: Up to 25 indicators per chart (varies by plan)
- **Strategies**: 1 strategy per chart maximum
- **Alerts**: Limited by subscription plan
- **Performance**: More scripts = higher resource usage

```pine
//@version=6
indicator("Resource Efficient Design", overlay=true)

// Combine multiple indicators efficiently rather than using separate scripts
ema_short = ta.ema(close, 10)
ema_long = ta.ema(close, 20)
rsi = ta.rsi(close, 14)

// Multiple plots in one script vs multiple single-plot scripts
plot(ema_short, "EMA 10", color.blue)
plot(ema_long, "EMA 20", color.red)

// Use conditional plotting to reduce resource usage
show_rsi = input.bool(false, "Show RSI")
plot(show_rsi ? rsi : na, "RSI", color.purple, display=display.pane)
```

### Alert Limits by Plan

#### Free Plan:
- **Total Alerts**: 1 alert
- **SMS Alerts**: Not available
- **Email Alerts**: Available
- **App Notifications**: Available

#### Pro Plan:
- **Total Alerts**: 20 alerts
- **SMS Alerts**: Available (limited)
- **Email/App**: Full access
- **Webhook**: Not available

#### Pro+ Plan:
- **Total Alerts**: 100 alerts
- **SMS/Email/App**: Full access
- **Webhook**: Available
- **Phone Calls**: Available

#### Premium Plan:
- **Total Alerts**: 400 alerts
- **All Features**: Maximum access
- **Priority Processing**: Faster alert delivery
- **Advanced Features**: Early access to new features

### Data Access Limits

#### Historical Data:
```pine
//@version=6
indicator("Data Limits Example", overlay=true)

// Maximum lookback: 5000 bars on any timeframe
// This is automatically managed by Pine Script
max_lookback_sma = ta.sma(close, 500)  // Works fine

// Some functions have specific limits
var float[] price_array = array.new<float>()

if bar_index < 500  // Limit array size to stay within memory constraints
    array.push(price_array, close)

// Use var to maintain state efficiently
var float highest_ever = 0.0
if high > highest_ever
    highest_ever := high
```

#### Real-time Data:
- **Tick Updates**: All plans receive real-time data
- **Depth of Market**: Premium feature
- **Extended Hours**: Available on higher plans
- **Custom Intervals**: Limited by plan level

### Performance Constraints

#### Memory Management:
```pine
//@version=6
indicator("Memory Efficient Code", overlay=true)

// Avoid creating too many variables or arrays
// Use built-in functions instead of manual calculations when possible

// Efficient: Built-in function
sma_efficient = ta.sma(close, 20)

// Less efficient: Manual calculation
var float sum = 0.0
var int count = 0
if count < 20
    sum := sum + close
    count := count + 1
else
    sum := sum + close - close[20]

// Use pine_lookback to limit unnecessary calculations
// @pine_lookback(50)  // Tells Pine Script we only need 50 bars of history
```

#### CPU Constraints:
- **Complex Calculations**: May timeout on complex scripts
- **Loop Limits**: Loops have iteration limits
- **Function Calls**: Nested function calls have depth limits
- **Array Operations**: Large arrays can impact performance

#### Network Limits:
```pine
//@version=6
indicator("Network Efficient", overlay=true)

// Limit security() calls (max 40 per script)
daily_high = request.security(syminfo.tickerid, "1D", high)
weekly_high = request.security(syminfo.tickerid, "1W", high)

// Cache expensive calculations
var float cached_value = na
if barstate.isconfirmed and na(cached_value)
    cached_value := daily_high  // Calculate only once per day
```

---

## Best Practices

### Performance Optimization

#### Efficient Code Patterns:
```pine
//@version=6
indicator("Performance Best Practices", overlay=true)

// 1. Use built-in functions instead of manual calculations
efficient_sma = ta.sma(close, 20)  // Built-in is optimized

// 2. Avoid unnecessary calculations in loops
for i = 0 to 99
    if i % 10 == 0  // Only calculate every 10th iteration
        complex_calculation = math.pow(close, 2) + math.sqrt(volume)

// 3. Cache expensive operations
var float expensive_calc = na
if barstate.isconfirmed
    expensive_calc := math.pow(ta.atr(14), 2)  // Calculate once per bar

// 4. Use conditional execution
show_extra_plots = input.bool(false, "Show Extra Plots")
if show_extra_plots
    plot(ta.rsi(close, 14), "RSI", color.purple, display=display.pane)

// 5. Limit array sizes
var float[] price_history = array.new<float>()
if array.size(price_history) > 100
    array.shift(price_history)  // Remove oldest element
array.push(price_history, close)
```

#### Memory Management:
```pine
//@version=6
indicator("Memory Management", overlay=true)

// Use 'var' for persistence, not recalculation
var float total_volume = 0.0
total_volume += volume  // Accumulates across bars

// Clear arrays when not needed
var float[] temp_array = array.new<float>()
if barstate.islast
    array.clear(temp_array)  // Clean up on last bar

// Use series variables efficiently
simple_variable = close + 1  // Recalculated every bar
var calculated_once = close + 1  // Calculated once, then maintained
```

### User Experience

#### Intuitive Input Organization:
```pine
//@version=6
indicator("UX Best Practices", overlay=true)

// Group related inputs
group_ma = "Moving Average Settings"
ma_type = input.string("EMA", "MA Type", options=["SMA", "EMA", "WMA"], group=group_ma)
ma_length = input.int(20, "MA Length", minval=1, maxval=200, group=group_ma)
ma_source = input.source(close, "MA Source", group=group_ma)

group_visual = "Visual Settings"
ma_color = input.color(color.blue, "MA Color", group=group_visual)
show_fill = input.bool(true, "Show Fill", group=group_visual, tooltip="Fill area between price and MA")
line_width = input.int(2, "Line Width", minval=1, maxval=4, group=group_visual)

// Provide helpful tooltips
rsi_period = input.int(14, "RSI Period", minval=2, maxval=50, 
                      tooltip="Traditional RSI uses 14 periods. Lower values = more sensitive.")

// Use meaningful defaults
bb_length = input.int(20, "BB Length", minval=1)  // Standard Bollinger Band length
bb_mult = input.float(2.0, "BB Multiplier", minval=0.1, step=0.1)  // Standard multiplier
```

#### Professional Visual Design:
```pine
//@version=6
indicator("Professional Visuals", overlay=true)

// Use consistent color schemes
color_bull = color.new(color.green, 0)
color_bear = color.new(color.red, 0)
color_neutral = color.new(color.gray, 50)

// Provide visual hierarchy
ema_fast = ta.ema(close, 12)
ema_slow = ta.ema(close, 26)

// Main signals - prominent
plot(ema_fast, "EMA Fast", color_bull, linewidth=2)
plot(ema_slow, "EMA Slow", color_bear, linewidth=2)

// Background fill - subtle
fill_color = ema_fast > ema_slow ? color.new(color_bull, 95) : color.new(color_bear, 95)
fill(plot(ema_fast), plot(ema_slow), color=fill_color, title="Trend Fill")

// Signals - attention-grabbing
bullish_cross = ta.crossover(ema_fast, ema_slow)
bearish_cross = ta.crossunder(ema_fast, ema_slow)

plotshape(bullish_cross, "Bull Signal", shape.triangleup, location.belowbar, color_bull, size=size.normal)
plotshape(bearish_cross, "Bear Signal", shape.triangledown, location.abovebar, color_bear, size=size.normal)
```

### Mobile Compatibility

#### Mobile-Friendly Design:
```pine
//@version=6
indicator("Mobile Friendly", overlay=true)

// Use appropriate sizes for mobile screens
signal_size = input.string("Normal", "Signal Size", options=["Small", "Normal", "Large"])

size_value = switch signal_size
    "Small" => size.small
    "Normal" => size.normal
    "Large" => size.large

// Ensure text is readable on small screens
if ta.crossover(close, ta.sma(close, 20))
    label.new(bar_index, high, "BUY", 
              style=label.style_label_down, 
              color=color.green, 
              textcolor=color.white,
              size=size.normal)  // Avoid tiny text

// Use clear, contrasting colors
mobile_bull_color = color.new(color.lime, 0)  // High contrast
mobile_bear_color = color.new(color.red, 0)   // High contrast

// Simplify complex visuals for mobile
show_detailed_plots = input.bool(true, "Show Detailed Plots", 
                                tooltip="Disable for cleaner mobile view")
```

### Accessibility

#### Screen Reader Compatibility:
```pine
//@version=6
indicator("Accessible Design", overlay=true)

// Provide descriptive plot titles
rsi_value = ta.rsi(close, 14)
plot(rsi_value, "Relative Strength Index 14-period", color.purple)

// Use meaningful label text
if rsi_value > 70
    label.new(bar_index, high, "RSI Overbought Alert", 
              style=label.style_label_down,
              tooltip="RSI value: " + str.tostring(rsi_value, "#.##"))

// Avoid relying solely on color
// Use shapes and text in addition to color coding
overbought = rsi_value > 70
oversold = rsi_value < 30

bgcolor(overbought ? color.new(color.red, 90) : 
        oversold ? color.new(color.green, 90) : na)

// Add text indicators
plotchar(overbought, "OB", "⚠", location.top, color.red)
plotchar(oversold, "OS", "📈", location.bottom, color.green)
```

#### Color Accessibility:
```pine
//@version=6
indicator("Color Accessible", overlay=true)

// Use colorblind-friendly palettes
// Avoid red/green only distinctions
color_up = color.new(#2E8B57, 0)      // Sea Green
color_down = color.new(#B22222, 0)    // Fire Brick
color_neutral = color.new(#708090, 0) // Slate Gray

// Provide pattern alternatives to color
trend_up = close > ta.sma(close, 20)
trend_down = close < ta.sma(close, 20)

// Use different line styles, not just colors
plot(ta.sma(close, 20), "SMA 20", 
     color=trend_up ? color_up : color_down,
     linewidth=trend_up ? 3 : 1,  // Thickness indicates direction
     style=trend_up ? plot.style_line : plot.style_stepline)
```

---

## Practical Examples for Pine Script v6 Developers

### Example 1: Professional Indicator Template
```pine
//@version=6
indicator("Professional Indicator Template", "PIT", overlay=false, timeframe="", timeframe_gaps=true)

// === INPUT SECTION ===
group_calculation = "Calculation Settings"
length = input.int(14, "Period", minval=1, maxval=100, group=group_calculation, 
                   tooltip="Number of bars for calculation")
source = input.source(close, "Source", group=group_calculation)

group_visual = "Visual Settings"
bull_color = input.color(color.green, "Bullish Color", group=group_visual)
bear_color = input.color(color.red, "Bearish Color", group=group_visual)
show_levels = input.bool(true, "Show Reference Levels", group=group_visual)

group_alerts = "Alert Settings"
enable_alerts = input.bool(false, "Enable Alerts", group=group_alerts)
alert_overbought = input.float(70, "Overbought Level", minval=50, maxval=100, group=group_alerts)
alert_oversold = input.float(30, "Oversold Level", minval=0, maxval=50, group=group_alerts)

// === CALCULATION SECTION ===
rsi = ta.rsi(source, length)

// === PLOTTING SECTION ===
rsi_color = rsi > 50 ? bull_color : bear_color
plot(rsi, "RSI", color=rsi_color, linewidth=2)

// Reference levels
if show_levels
    hline(alert_overbought, "Overbought", color.red, linestyle.dashed)
    hline(alert_oversold, "Oversold", color.green, linestyle.dashed)
    hline(50, "Midline", color.gray)

// Background coloring
bgcolor(rsi > alert_overbought ? color.new(bear_color, 90) : 
        rsi < alert_oversold ? color.new(bull_color, 90) : na)

// === ALERTS SECTION ===
if enable_alerts
    if ta.crossover(rsi, alert_overbought)
        alert("RSI Overbought on " + syminfo.ticker, alert.freq_once_per_bar)
    if ta.crossunder(rsi, alert_oversold)
        alert("RSI Oversold on " + syminfo.ticker, alert.freq_once_per_bar)
```

### Example 2: Multi-Timeframe Indicator
```pine
//@version=6
indicator("Multi-Timeframe Example", "MTF", overlay=true)

// === TIMEFRAME INPUTS ===
tf_higher = input.timeframe("1D", "Higher Timeframe", tooltip="Higher timeframe for trend analysis")

// === CALCULATIONS ===
// Current timeframe
ema_20 = ta.ema(close, 20)

// Higher timeframe data
htf_ema = request.security(syminfo.tickerid, tf_higher, ta.ema(close, 20), 
                          lookahead=barmerge.lookahead_off)

// === PLOTTING ===
plot(ema_20, "EMA 20 (" + timeframe.period + ")", color.blue, linewidth=1)
plot(htf_ema, "EMA 20 (" + tf_higher + ")", color.red, linewidth=2)

// Trend alignment
aligned_trend = close > ema_20 and close > htf_ema
bgcolor(aligned_trend ? color.new(color.green, 95) : na, title="Trend Alignment")

// === TABLE FOR MTF DATA ===
if barstate.islast
    var table mtf_table = table.new(position.top_right, 2, 3, bgcolor=color.white, border_width=1)
    table.cell(mtf_table, 0, 0, "Timeframe", text_color=color.black, bgcolor=color.gray)
    table.cell(mtf_table, 1, 0, "EMA 20", text_color=color.black, bgcolor=color.gray)
    
    table.cell(mtf_table, 0, 1, timeframe.period, text_color=color.black)
    table.cell(mtf_table, 1, 1, str.tostring(ema_20, "#.##"), text_color=color.black)
    
    table.cell(mtf_table, 0, 2, tf_higher, text_color=color.black)
    table.cell(mtf_table, 1, 2, str.tostring(htf_ema, "#.##"), text_color=color.black)
```

### Example 3: Strategy with Risk Management
```pine
//@version=6
strategy("Risk Management Strategy", "RMS", overlay=true, 
         initial_capital=100000, 
         default_qty_type=strategy.percent_of_equity, 
         default_qty_value=2)

// === STRATEGY INPUTS ===
group_strategy = "Strategy Settings"
fast_length = input.int(10, "Fast EMA", minval=1, group=group_strategy)
slow_length = input.int(20, "Slow EMA", minval=1, group=group_strategy)

group_risk = "Risk Management"
risk_percent = input.float(1.0, "Risk Per Trade (%)", minval=0.1, maxval=5.0, step=0.1, group=group_risk)
reward_ratio = input.float(2.0, "Risk:Reward Ratio", minval=1.0, maxval=5.0, step=0.1, group=group_risk)
max_trades = input.int(5, "Max Concurrent Trades", minval=1, maxval=10, group=group_risk)

// === CALCULATIONS ===
ema_fast = ta.ema(close, fast_length)
ema_slow = ta.ema(close, slow_length)
atr_value = ta.atr(14)

// === ENTRY CONDITIONS ===
long_condition = ta.crossover(ema_fast, ema_slow) and strategy.opentrades < max_trades
short_condition = ta.crossunder(ema_fast, ema_slow) and strategy.opentrades < max_trades

// === RISK CALCULATIONS ===
account_value = strategy.equity
risk_amount = account_value * (risk_percent / 100)

if long_condition
    stop_loss = close - (2 * atr_value)
    take_profit = close + (2 * atr_value * reward_ratio)
    qty = risk_amount / math.abs(close - stop_loss)
    
    strategy.entry("Long", strategy.long, qty=qty)
    strategy.exit("Long Exit", "Long", stop=stop_loss, limit=take_profit)

if short_condition
    stop_loss = close + (2 * atr_value)
    take_profit = close - (2 * atr_value * reward_ratio)
    qty = risk_amount / math.abs(stop_loss - close)
    
    strategy.entry("Short", strategy.short, qty=qty)
    strategy.exit("Short Exit", "Short", stop=stop_loss, limit=take_profit)

// === PLOTTING ===
plot(ema_fast, "Fast EMA", color.blue)
plot(ema_slow, "Slow EMA", color.red)

// Risk visualization
plotshape(long_condition, "Long Signal", shape.triangleup, location.belowbar, color.green)
plotshape(short_condition, "Short Signal", shape.triangledown, location.abovebar, color.red)
```

---

## Tips for Success on TradingView

### 1. Start Simple, Build Complex
- Begin with basic indicators
- Add features incrementally
- Test thoroughly at each stage
- Gather user feedback early

### 2. Focus on User Value
- Solve real trading problems
- Provide educational content
- Make interfaces intuitive
- Document everything clearly

### 3. Engage with Community
- Respond to comments and questions
- Collaborate with other developers
- Share knowledge and insights
- Help newcomers learn Pine Script

### 4. Maintain Quality Standards
- Follow Pine Script best practices
- Test across different markets and timeframes
- Handle edge cases gracefully
- Keep code clean and commented

### 5. Stay Updated
- Follow TradingView development updates
- Learn new Pine Script features
- Adapt to platform changes
- Evolve with community needs

---

This documentation provides a comprehensive foundation for understanding the TradingView platform and how Pine Script v6 integrates within it. Use this knowledge to create better indicators, strategies, and community contributions that leverage the full power of the TradingView ecosystem.