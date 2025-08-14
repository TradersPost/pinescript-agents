# Pine Script v6 Strategy Development Guide

## Strategy Declaration

### Basic Strategy Structure
```pine
//@version=6
strategy("My Strategy", 
         shorttitle="MS", 
         overlay=true,
         default_qty_type=strategy.percent_of_equity, 
         default_qty_value=10,
         commission_type=strategy.commission.percent,
         commission_value=0.1,
         slippage=2)
```

### Strategy Declaration Parameters
| Parameter | Description | Default | Example |
|-----------|-------------|---------|---------|
| `title` | Strategy name displayed on chart | Required | `"My Strategy"` |
| `shorttitle` | Abbreviated name | `title` | `"MS"` |
| `overlay` | Display on price chart or separate pane | `false` | `true` |
| `format` | Number format for strategy equity | `format.inherit` | `format.volume` |
| `precision` | Decimal places for numbers | `4` | `2` |
| `scale` | Scale type for separate pane | `scale.right` | `scale.left` |
| `max_bars_back` | Maximum historical bars reference | `na` | `500` |
| `default_qty_type` | Default quantity type | `strategy.fixed` | `strategy.percent_of_equity` |
| `default_qty_value` | Default quantity value | `1` | `10` |
| `pyramiding` | Maximum pyramid orders | `0` | `3` |
| `calc_on_order_fills` | Recalculate on fills | `false` | `true` |
| `calc_on_every_tick` | Calculate on every tick | `false` | `true` |
| `close_entries_rule` | How to close entries | `"NONE"` | `"FIFO"` |
| `commission_type` | Commission calculation type | `strategy.commission.percent` | `strategy.commission.cash_per_contract` |
| `commission_value` | Commission amount | `0` | `0.1` |
| `slippage` | Slippage in ticks | `0` | `2` |
| `currency` | Strategy currency | `currency.NONE` | `currency.USD` |
| `initial_capital` | Starting capital | `10000` | `100000` |
| `process_orders_on_close` | Process orders on bar close | `false` | `true` |

## Entry and Exit Functions

### Long Entries
```pine
// Basic long entry
strategy.entry("Long", strategy.long, qty=100, when=longCondition)

// Long entry with limit price
strategy.entry("Long", strategy.long, qty=100, limit=close * 0.995, when=longCondition)

// Long entry with stop price
strategy.entry("Long", strategy.long, qty=100, stop=close * 1.005, when=longCondition)

// Long entry with both limit and stop
strategy.entry("Long", strategy.long, qty=100, limit=close * 0.995, stop=close * 1.005, when=longCondition)
```

### Short Entries
```pine
// Basic short entry
strategy.entry("Short", strategy.short, qty=100, when=shortCondition)

// Short entry with limit price (sell higher)
strategy.entry("Short", strategy.short, qty=100, limit=close * 1.005, when=shortCondition)

// Short entry with stop price (sell lower, stop loss becomes entry)
strategy.entry("Short", strategy.short, qty=100, stop=close * 0.995, when=shortCondition)
```

### Exit Functions
```pine
// Close all positions
strategy.close_all(when=exitAllCondition, comment="Exit All")

// Close specific position
strategy.close("Long", when=exitLongCondition, qty_percent=50, comment="Partial Exit")

// Exit with market order
strategy.exit("Exit Long", "Long", qty_percent=100, when=exitCondition)

// Exit with stop loss and take profit
strategy.exit("Exit Long", "Long", 
              stop=entryPrice * 0.95, 
              limit=entryPrice * 1.10, 
              comment="SL/TP Exit")

// Exit with trailing stop
strategy.exit("Exit Long", "Long", 
              trail_price=entryPrice * 1.05, 
              trail_offset=close * 0.02,
              comment="Trailing Stop")
```

## Position Sizing

### Fixed Quantity
```pine
//@version=6
strategy("Fixed Qty", default_qty_type=strategy.fixed, default_qty_value=100)

// Entry with fixed quantity
strategy.entry("Long", strategy.long, when=longCondition)  // Uses default 100
strategy.entry("Long2", strategy.long, qty=50, when=longCondition2)  // Override to 50
```

### Percentage of Equity
```pine
//@version=6
strategy("Percent Equity", default_qty_type=strategy.percent_of_equity, default_qty_value=10)

// Calculate custom percentage
riskPercent = input.float(2.0, "Risk %", minval=0.1, maxval=10.0)
riskAmount = strategy.equity * riskPercent / 100

atr = ta.atr(14)
stopDistance = atr * 2
positionSize = riskAmount / stopDistance

strategy.entry("Long", strategy.long, qty=positionSize, when=longCondition)
```

### Cash Amount
```pine
//@version=6
strategy("Cash Amount", default_qty_type=strategy.cash, default_qty_value=1000)

// Dynamic cash allocation based on volatility
volatility = ta.atr(14) / close
baseAmount = 1000
adjustedAmount = baseAmount * (1 - volatility)  // Reduce size in high volatility

strategy.entry("Long", strategy.long, qty=adjustedAmount, when=longCondition)
```

## Risk Management

### Stop Loss Implementation
```pine
//@version=6
strategy("Stop Loss Methods", overlay=true)

// Method 1: Fixed percentage stop
stopLossPercent = input.float(2.0, "Stop Loss %")

var float longStopPrice = na
var float shortStopPrice = na

if strategy.position_size > 0  // Long position
    longStopPrice := strategy.position_avg_price * (1 - stopLossPercent/100)
    strategy.exit("Long Exit", "Long", stop=longStopPrice)

if strategy.position_size < 0  // Short position
    shortStopPrice := strategy.position_avg_price * (1 + stopLossPercent/100)
    strategy.exit("Short Exit", "Short", stop=shortStopPrice)
```

### ATR-Based Stop Loss
```pine
//@version=6
strategy("ATR Stop Loss", overlay=true)

atrLength = input.int(14, "ATR Length")
atrMultiplier = input.float(2.0, "ATR Multiplier")

atr = ta.atr(atrLength)

var float longStopPrice = na
var float shortStopPrice = na

longCondition = ta.crossover(ta.ema(close, 10), ta.ema(close, 20))
shortCondition = ta.crossunder(ta.ema(close, 10), ta.ema(close, 20))

if longCondition
    strategy.entry("Long", strategy.long)
    longStopPrice := close - atr * atrMultiplier

if shortCondition
    strategy.entry("Short", strategy.short)
    shortStopPrice := close + atr * atrMultiplier

if strategy.position_size > 0
    strategy.exit("Long Exit", "Long", stop=longStopPrice)

if strategy.position_size < 0
    strategy.exit("Short Exit", "Short", stop=shortStopPrice)
```

### Trailing Stop Implementation
```pine
//@version=6
strategy("Trailing Stop", overlay=true)

trailPercent = input.float(1.5, "Trail %")

var float longTrailPrice = na
var float shortTrailPrice = na

longCondition = ta.crossover(close, ta.sma(close, 20))
shortCondition = ta.crossunder(close, ta.sma(close, 20))

if longCondition
    strategy.entry("Long", strategy.long)
    longTrailPrice := close * (1 - trailPercent/100)

if shortCondition
    strategy.entry("Short", strategy.short)
    shortTrailPrice := close * (1 + trailPercent/100)

// Update trailing stops
if strategy.position_size > 0
    newTrailPrice = close * (1 - trailPercent/100)
    longTrailPrice := math.max(longTrailPrice, newTrailPrice)
    strategy.exit("Long Exit", "Long", stop=longTrailPrice)

if strategy.position_size < 0
    newTrailPrice = close * (1 + trailPercent/100)
    shortTrailPrice := math.min(shortTrailPrice, newTrailPrice)
    strategy.exit("Short Exit", "Short", stop=shortTrailPrice)
```

## Position Management

### Pyramiding Strategy
```pine
//@version=6
strategy("Pyramiding", overlay=true, pyramiding=3)

// Different entry conditions for pyramid levels
ema20 = ta.ema(close, 20)
ema50 = ta.ema(close, 50)

// First entry - trend start
firstEntry = ta.crossover(ema20, ema50)

// Second entry - pullback to EMA
secondEntry = strategy.position_size > 0 and ta.crossover(close, ema20) and close[1] < ema20

// Third entry - breakout continuation
thirdEntry = strategy.position_size > 0 and close > ta.highest(high, 10)[1]

if firstEntry
    strategy.entry("Long1", strategy.long, qty=100, comment="First Entry")

if secondEntry and strategy.opentrades < 2
    strategy.entry("Long2", strategy.long, qty=75, comment="Second Entry")

if thirdEntry and strategy.opentrades < 3
    strategy.entry("Long3", strategy.long, qty=50, comment="Third Entry")

// Exit all positions
exitCondition = ta.crossunder(ema20, ema50)
strategy.close_all(when=exitCondition, comment="Exit All")
```

### Partial Exits
```pine
//@version=6
strategy("Partial Exits", overlay=true)

var float entryPrice = na

longCondition = ta.crossover(ta.rsi(close, 14), 30)

if longCondition
    strategy.entry("Long", strategy.long, qty=100)
    entryPrice := close

if strategy.position_size > 0
    // First partial exit at 1.5% profit
    if close >= entryPrice * 1.015
        strategy.close("Long", qty_percent=50, comment="Partial 1")
    
    // Second partial exit at 3% profit
    if close >= entryPrice * 1.03
        strategy.close("Long", qty_percent=25, comment="Partial 2")
    
    // Final exit at 5% profit or 2% loss
    strategy.exit("Final Exit", "Long", 
                  limit=entryPrice * 1.05, 
                  stop=entryPrice * 0.98,
                  comment="Final Exit")
```

## Strategy Performance Metrics

### Built-in Strategy Properties
```pine
//@version=6
strategy("Performance Display", overlay=false)

// Access strategy performance data
totalTrades = strategy.closedtrades
winningTrades = strategy.wintrades
losingTrades = strategy.losstrades
winRate = strategy.wintrades / strategy.closedtrades * 100

grossProfit = strategy.grossprofit
grossLoss = strategy.grossloss
netProfit = strategy.netprofit
profitFactor = strategy.grossprofit / strategy.grossloss

maxDrawdown = strategy.max_drawdown
avgTrade = strategy.netprofit / strategy.closedtrades

// Display metrics in a table
if barstate.islast
    var table perfTable = table.new(position.top_right, 2, 8, bgcolor=color.white, border_width=1)
    
    table.cell(perfTable, 0, 0, "Total Trades", text_color=color.black)
    table.cell(perfTable, 1, 0, str.tostring(totalTrades), text_color=color.black)
    
    table.cell(perfTable, 0, 1, "Win Rate", text_color=color.black)
    table.cell(perfTable, 1, 1, str.tostring(winRate, "#.##") + "%", text_color=color.black)
    
    table.cell(perfTable, 0, 2, "Profit Factor", text_color=color.black)
    table.cell(perfTable, 1, 2, str.tostring(profitFactor, "#.##"), text_color=color.black)
    
    table.cell(perfTable, 0, 3, "Net Profit", text_color=color.black)
    table.cell(perfTable, 1, 3, str.tostring(netProfit, "#.##"), text_color=color.black)
    
    table.cell(perfTable, 0, 4, "Max Drawdown", text_color=color.black)
    table.cell(perfTable, 1, 4, str.tostring(maxDrawdown, "#.##"), text_color=color.black)
    
    table.cell(perfTable, 0, 5, "Avg Trade", text_color=color.black)
    table.cell(perfTable, 1, 5, str.tostring(avgTrade, "#.##"), text_color=color.black)
```

### Custom Performance Tracking
```pine
//@version=6
strategy("Custom Metrics", overlay=true)

// Track custom metrics
var int consecutiveWins = 0
var int consecutiveLosses = 0
var int maxConsecutiveWins = 0
var int maxConsecutiveLosses = 0
var float largestWin = 0
var float largestLoss = 0

// Update metrics when trades close
if strategy.closedtrades > strategy.closedtrades[1]
    lastTradePnL = strategy.closedtrades.exit_price(strategy.closedtrades - 1) - 
                   strategy.closedtrades.entry_price(strategy.closedtrades - 1)
    
    if lastTradePnL > 0  // Winning trade
        consecutiveWins := consecutiveWins + 1
        consecutiveLosses := 0
        maxConsecutiveWins := math.max(maxConsecutiveWins, consecutiveWins)
        largestWin := math.max(largestWin, lastTradePnL)
    else  // Losing trade
        consecutiveLosses := consecutiveLosses + 1
        consecutiveWins := 0
        maxConsecutiveLosses := math.max(maxConsecutiveLosses, consecutiveLosses)
        largestLoss := math.min(largestLoss, lastTradePnL)
```

## Advanced Strategy Patterns

### Mean Reversion Strategy
```pine
//@version=6
strategy("Mean Reversion", overlay=true)

// Parameters
bbLength = input.int(20, "Bollinger Band Length")
bbMult = input.float(2.0, "BB Multiplier")
rsiLength = input.int(14, "RSI Length")
rsiOversold = input.int(30, "RSI Oversold")
rsiOverbought = input.int(70, "RSI Overbought")

// Indicators
[upper, basis, lower] = ta.bb(close, bbLength, bbMult)
rsi = ta.rsi(close, rsiLength)

// Entry conditions
longCondition = close < lower and rsi < rsiOversold
shortCondition = close > upper and rsi > rsiOverbought

// Entries
if longCondition
    strategy.entry("Long", strategy.long)

if shortCondition
    strategy.entry("Short", strategy.short)

// Exits - mean reversion back to basis
strategy.close("Long", when=close >= basis)
strategy.close("Short", when=close <= basis)

// Plots
plot(upper, color=color.red, title="Upper BB")
plot(basis, color=color.blue, title="Basis")
plot(lower, color=color.green, title="Lower BB")
```

### Trend Following Strategy
```pine
//@version=6
strategy("Trend Following", overlay=true)

// Parameters
fastLength = input.int(10, "Fast EMA")
slowLength = input.int(20, "Slow EMA")
atrLength = input.int(14, "ATR Length")
atrMult = input.float(2.0, "ATR Multiplier")

// Indicators
fastEMA = ta.ema(close, fastLength)
slowEMA = ta.ema(close, slowLength)
atr = ta.atr(atrLength)

// Trend detection
uptrend = fastEMA > slowEMA
downtrend = fastEMA < slowEMA

// Entry signals
longEntry = ta.crossover(fastEMA, slowEMA)
shortEntry = ta.crossunder(fastEMA, slowEMA)

// Entries
if longEntry
    strategy.entry("Long", strategy.long)
    strategy.exit("Long Exit", "Long", stop=close - atr * atrMult)

if shortEntry
    strategy.entry("Short", strategy.short)
    strategy.exit("Short Exit", "Short", stop=close + atr * atrMult)

// Plots
plot(fastEMA, color=color.blue, title="Fast EMA")
plot(slowEMA, color=color.red, title="Slow EMA")

// Background color for trend
bgcolor(uptrend ? color.new(color.green, 90) : downtrend ? color.new(color.red, 90) : na)
```

### Breakout Strategy
```pine
//@version=6
strategy("Breakout Strategy", overlay=true)

// Parameters
lookback = input.int(20, "Lookback Period")
volumeThreshold = input.float(1.5, "Volume Threshold")

// Calculate levels
resistance = ta.highest(high, lookback)[1]  // Previous bar's highest
support = ta.lowest(low, lookback)[1]       // Previous bar's lowest
avgVolume = ta.sma(volume, lookback)

// Breakout conditions
bullishBreakout = high > resistance and volume > avgVolume * volumeThreshold
bearishBreakout = low < support and volume > avgVolume * volumeThreshold

// Entries
if bullishBreakout
    strategy.entry("Long", strategy.long)
    strategy.exit("Long Exit", "Long", 
                  stop=support, 
                  limit=close + (close - support) * 2)  // 2:1 R/R

if bearishBreakout
    strategy.entry("Short", strategy.short)
    strategy.exit("Short Exit", "Short", 
                  stop=resistance, 
                  limit=close - (resistance - close) * 2)  // 2:1 R/R

// Plots
plot(resistance, color=color.red, style=plot.style_line, title="Resistance")
plot(support, color=color.green, style=plot.style_line, title="Support")
```

## Strategy Testing Best Practices

### Proper Backtesting Setup
```pine
//@version=6
strategy("Proper Backtest Setup", 
         overlay=true,
         commission_type=strategy.commission.percent,
         commission_value=0.1,           // 0.1% commission
         slippage=2,                     // 2 ticks slippage
         initial_capital=10000,          // Starting capital
         default_qty_type=strategy.percent_of_equity,
         default_qty_value=10,           // Risk 10% per trade
         calc_on_every_tick=false,       // Calculate on bar close only
         process_orders_on_close=true)   // Process orders at close

// Your strategy logic here
```

### Avoiding Overfitting
```pine
//@version=6
strategy("Anti-Overfitting", overlay=true)

// Use fewer parameters
lookback = 20  // Fixed instead of input
threshold = 2.0  // Fixed instead of optimizable

// Use robust indicators
ma = ta.ema(close, lookback)  // Simple, widely used
atr = ta.atr(14)              // Standard period

// Simple logic
longCondition = close > ma and ta.rsi(close, 14) < 70
shortCondition = close < ma and ta.rsi(close, 14) > 30

// Test on multiple timeframes and symbols
// Ensure strategy works across different market conditions
```

## Common Strategy Mistakes

### 1. Lookahead Bias
```pine
// BAD: Using future information
futureHigh = high[1]  // This shouldn't know future
signal = close > futureHigh

// GOOD: Using past information only
pastHigh = ta.highest(high[1], 20)  // Use historical data
signal = close > pastHigh
```

### 2. Repainting Strategies
```pine
// BAD: Changes historical signals
realtimeSignal = ta.crossover(close, ta.sma(close, 20))

// GOOD: Confirmed signals only
confirmedSignal = ta.crossover(close[1], ta.sma(close[1], 20)) and barstate.isnew
```

### 3. Unrealistic Orders
```pine
// BAD: Immediate execution assumption
strategy.entry("Long", strategy.long, when=longCondition)

// GOOD: Realistic order placement
if longCondition
    strategy.entry("Long", strategy.long, limit=close * 0.999)  // Slight discount
```

Strategy development in Pine Script requires careful attention to realistic market conditions, proper risk management, and thorough testing to create robust trading systems.