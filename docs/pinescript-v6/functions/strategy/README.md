# Pine Script v6 Strategy Functions Reference

This comprehensive guide covers all strategy-related functions in Pine Script v6 for creating robust trading systems with proper order management, position tracking, performance metrics, and risk controls.

## Table of Contents

1. [Order Management](#order-management)
2. [Position Information](#position-information)
3. [Performance Metrics](#performance-metrics)
4. [Risk Management](#risk-management)
5. [Complete Examples](#complete-examples)

---

## Order Management

### strategy.entry()

Creates entry orders to open new positions.

**Syntax:**
```pinescript
strategy.entry(id, direction, qty, limit, stop, oca_name, oca_type, comment, alert_message, disable_alert, when)
```

**Parameters:**
- `id` (series string): Unique order identifier
- `direction` (strategy.direction): `strategy.long` or `strategy.short`
- `qty` (series int/float): Order quantity (optional, uses default if not specified)
- `limit` (series int/float): Limit price for limit orders
- `stop` (series int/float): Stop price for stop orders
- `oca_name` (series string): One-Cancels-All group name
- `oca_type` (const string): `strategy.oca.cancel` or `strategy.oca.reduce`
- `comment` (series string): Order comment for broker
- `alert_message` (series string): Custom alert message
- `disable_alert` (series bool): Disable alert for this order
- `when` (series bool): Condition to place order

**Example:**
```pinescript
//@version=6
strategy("Entry Examples", overlay=true)

// Simple long entry
if ta.crossover(ta.sma(close, 10), ta.sma(close, 20))
    strategy.entry("Long", strategy.long)

// Entry with specific quantity and limit price
if close > ta.sma(close, 50)
    strategy.entry("Long Limit", strategy.long, qty=100, limit=close * 0.99)

// Stop entry for breakout
if close > ta.highest(high, 20)[1]
    strategy.entry("Breakout", strategy.long, stop=ta.highest(high, 20)[1])
```

### strategy.exit()

Creates exit orders with stop loss and take profit levels.

**Syntax:**
```pinescript
strategy.exit(id, from_entry, qty, qty_percent, profit, limit, loss, stop, trail_price, trail_points, trail_offset, oca_name, comment, alert_message, disable_alert, when)
```

**Parameters:**
- `id` (series string): Exit order identifier
- `from_entry` (series string): Entry order ID to exit from
- `qty` (series int/float): Quantity to exit
- `qty_percent` (series int/float): Percentage of position to exit
- `profit` (series int/float): Take profit in ticks
- `limit` (series int/float): Take profit price
- `loss` (series int/float): Stop loss in ticks
- `stop` (series int/float): Stop loss price
- `trail_price` (series int/float): Trailing stop activation price
- `trail_points` (series int/float): Trailing stop distance in ticks
- `trail_offset` (series int/float): Trailing stop offset in ticks

**Example:**
```pinescript
// Exit with fixed stop loss and take profit
strategy.exit("Exit Long", "Long", profit=300, loss=150)

// Exit with percentage-based levels
strategy.exit("Exit", "Entry", limit=close * 1.05, stop=close * 0.95)

// Trailing stop exit
strategy.exit("Trail Exit", "Long", trail_price=close * 1.02, trail_points=50)

// Partial exit
strategy.exit("Partial", "Long", qty_percent=50, profit=200)
```

### strategy.close()

Closes specific position or all positions from an entry.

**Syntax:**
```pinescript
strategy.close(id, comment, alert_message, disable_alert, immediately, when)
```

**Parameters:**
- `id` (series string): Entry ID to close
- `comment` (series string): Closing comment
- `alert_message` (series string): Custom alert message
- `disable_alert` (series bool): Disable alert
- `immediately` (series bool): Close at market immediately
- `when` (series bool): Condition to close

**Example:**
```pinescript
// Close specific position
if ta.crossunder(ta.rsi(close, 14), 70)
    strategy.close("Long")

// Close with custom message
if time > timestamp("UTC", 2023, 12, 31, 16, 0)
    strategy.close("Long", comment="End of year close")
```

### strategy.close_all()

Closes all open positions.

**Syntax:**
```pinescript
strategy.close_all(comment, alert_message, disable_alert, immediately, when)
```

**Example:**
```pinescript
// Close all positions at market close
if time_close(timeframe.period) == time
    strategy.close_all(comment="Market close")

// Emergency close all
if ta.change(close) > close * 0.05  // 5% price spike
    strategy.close_all(immediately=true)
```

### strategy.cancel()

Cancels pending orders by ID.

**Syntax:**
```pinescript
strategy.cancel(id, when)
```

**Example:**
```pinescript
// Cancel specific order
if ta.crossunder(close, ta.sma(close, 20))
    strategy.cancel("Long Limit")
```

### strategy.cancel_all()

Cancels all pending orders.

**Syntax:**
```pinescript
strategy.cancel_all(when)
```

**Example:**
```pinescript
// Cancel all orders at day end
if hour == 16 and minute == 0
    strategy.cancel_all()
```

---

## Position Information

### strategy.position_size

Current position size (positive for long, negative for short, zero for flat).

**Type:** series float

**Example:**
```pinescript
// Check if in position
isLong = strategy.position_size > 0
isShort = strategy.position_size < 0
isFlat = strategy.position_size == 0

// Position size-based logic
if strategy.position_size > 0 and close < strategy.position_avg_price * 0.95
    strategy.close("Long", comment="Stop loss hit")
```

### strategy.position_avg_price

Average entry price of current position.

**Type:** series float

**Example:**
```pinescript
// Calculate unrealized P&L
if strategy.position_size != 0
    unrealizedPnL = (close - strategy.position_avg_price) * strategy.position_size
    
// Risk-based position sizing
riskAmount = strategy.position_avg_price * 0.02  // 2% risk
```

### strategy.opentrades

Number of currently open trades.

**Type:** series int

**Example:**
```pinescript
// Limit number of open trades
if strategy.opentrades < 3 and buySignal
    strategy.entry("Long", strategy.long)
```

### strategy.closedtrades

Total number of closed trades.

**Type:** series int

**Example:**
```pinescript
// Track trade frequency
if strategy.closedtrades != strategy.closedtrades[1]
    label.new(bar_index, high, "Trade #" + str.tostring(strategy.closedtrades))
```

---

## Performance Metrics

### strategy.netprofit

Net profit of all closed trades.

**Type:** series float

**Example:**
```pinescript
// Display net profit
if barstate.islast
    label.new(bar_index, high, "Net P&L: $" + str.tostring(strategy.netprofit, "#.##"))
```

### strategy.grossprofit

Gross profit from all winning trades.

**Type:** series float

### strategy.grossloss

Gross loss from all losing trades (always negative or zero).

**Type:** series float

**Example:**
```pinescript
// Calculate profit factor
profitFactor = strategy.grossloss != 0 ? strategy.grossprofit / math.abs(strategy.grossloss) : na

// Win rate calculation
winRate = strategy.wintrades / strategy.closedtrades * 100
```

### strategy.max_drawdown

Maximum drawdown experienced.

**Type:** series float

**Example:**
```pinescript
// Monitor drawdown
if strategy.max_drawdown > 1000  // $1000 drawdown
    strategy.close_all(comment="Max drawdown reached")
```

### strategy.equity

Current equity (initial capital + net profit + open trade P&L).

**Type:** series float

**Example:**
```pinescript
// Equity curve plotting
plot(strategy.equity, title="Equity Curve", color=color.blue)

// Position sizing based on equity
riskAmount = strategy.equity * 0.01  // 1% of equity
```

---

## Risk Management

### strategy.risk.allow_entry_in()

Controls which direction trades are allowed.

**Syntax:**
```pinescript
strategy.risk.allow_entry_in(value)
```

**Parameters:**
- `value` (const string): `strategy.direction.all`, `strategy.direction.long`, or `strategy.direction.short`

**Example:**
```pinescript
// Only allow long trades in uptrend
trendUp = ta.sma(close, 50) > ta.sma(close, 200)
strategy.risk.allow_entry_in(trendUp ? strategy.direction.long : strategy.direction.all)
```

### strategy.risk.max_cons_loss_days()

Sets maximum consecutive losing days.

**Syntax:**
```pinescript
strategy.risk.max_cons_loss_days(count)
```

**Example:**
```pinescript
strategy.risk.max_cons_loss_days(3)  // Stop after 3 consecutive losing days
```

### strategy.risk.max_drawdown()

Sets maximum drawdown limit.

**Syntax:**
```pinescript
strategy.risk.max_drawdown(value, type)
```

**Parameters:**
- `value` (const int/float): Drawdown limit
- `type` (const string): `strategy.percent_of_equity` or `strategy.cash`

**Example:**
```pinescript
strategy.risk.max_drawdown(20, strategy.percent_of_equity)  // 20% max drawdown
strategy.risk.max_drawdown(5000, strategy.cash)  // $5000 max drawdown
```

### strategy.risk.max_intraday_filled_orders()

Limits number of filled orders per day.

**Example:**
```pinescript
strategy.risk.max_intraday_filled_orders(10)  // Max 10 orders per day
```

### strategy.risk.max_intraday_loss()

Sets maximum daily loss limit.

**Example:**
```pinescript
strategy.risk.max_intraday_loss(1000, strategy.cash)  // $1000 daily loss limit
```

### strategy.risk.max_position_size()

Limits maximum position size.

**Example:**
```pinescript
strategy.risk.max_position_size(1000, strategy.cash)  // Max $1000 position
```

---

## Complete Examples

### 1. Basic Moving Average Crossover Strategy

```pinescript
//@version=6
strategy("MA Crossover with Risk Management", overlay=true, default_qty_type=strategy.percent_of_equity, default_qty_value=10)

// Input parameters
fastLength = input.int(10, "Fast MA Length", minval=1)
slowLength = input.int(20, "Slow MA Length", minval=1)
stopLossPercent = input.float(2.0, "Stop Loss %", minval=0.1, maxval=10.0)
takeProfitPercent = input.float(4.0, "Take Profit %", minval=0.1, maxval=20.0)

// Risk management settings
strategy.risk.max_drawdown(15, strategy.percent_of_equity)
strategy.risk.max_intraday_loss(500, strategy.cash)
strategy.risk.max_cons_loss_days(3)

// Calculate moving averages
fastMA = ta.sma(close, fastLength)
slowMA = ta.sma(close, slowLength)

// Entry conditions
longCondition = ta.crossover(fastMA, slowMA)
shortCondition = ta.crossunder(fastMA, slowMA)

// Entry orders
if longCondition and strategy.position_size == 0
    strategy.entry("Long", strategy.long)

if shortCondition and strategy.position_size == 0
    strategy.entry("Short", strategy.short)

// Exit orders with stop loss and take profit
if strategy.position_size > 0
    stopPrice = strategy.position_avg_price * (1 - stopLossPercent / 100)
    profitPrice = strategy.position_avg_price * (1 + takeProfitPercent / 100)
    strategy.exit("Exit Long", "Long", stop=stopPrice, limit=profitPrice)

if strategy.position_size < 0
    stopPrice = strategy.position_avg_price * (1 + stopLossPercent / 100)
    profitPrice = strategy.position_avg_price * (1 - takeProfitPercent / 100)
    strategy.exit("Exit Short", "Short", stop=stopPrice, limit=profitPrice)

// Plot moving averages
plot(fastMA, color=color.blue, title="Fast MA")
plot(slowMA, color=color.red, title="Slow MA")
```

### 2. Pyramiding Strategy with Partial Exits

```pinescript
//@version=6
strategy("Pyramiding Strategy", overlay=true, default_qty_type=strategy.fixed, default_qty_value=100, pyramiding=3)

// Input parameters
rsiLength = input.int(14, "RSI Length")
rsiOversold = input.int(30, "RSI Oversold")
rsiOverbought = input.int(70, "RSI Overbought")

// Calculate RSI
rsi = ta.rsi(close, rsiLength)

// Entry conditions for pyramiding
if rsi < rsiOversold and strategy.opentrades < 3
    entryId = "Long_" + str.tostring(strategy.opentrades + 1)
    strategy.entry(entryId, strategy.long)

// Partial exits at different RSI levels
if strategy.position_size > 0
    if rsi > 50 and rsi[1] <= 50
        // Exit 1/3 of position
        strategy.exit("Exit_1/3", qty_percent=33, profit=100)
    
    if rsi > 65 and rsi[1] <= 65
        // Exit another 1/3
        strategy.exit("Exit_2/3", qty_percent=50, profit=150)
    
    if rsi > rsiOverbought
        // Exit remaining position
        strategy.close_all(comment="RSI Overbought")

// Plot RSI levels
hline(rsiOversold, "Oversold", color=color.green)
hline(rsiOverbought, "Overbought", color=color.red)
plotchar(rsi, "RSI", "", location.top)
```

### 3. Advanced Risk Management Strategy

```pinescript
//@version=6
strategy("Advanced Risk Management", overlay=true, default_qty_type=strategy.cash, default_qty_value=1000)

// Input parameters
atrLength = input.int(14, "ATR Length")
atrMultiplier = input.float(2.0, "ATR Multiplier for Stops")
riskPerTrade = input.float(1.0, "Risk Per Trade %", minval=0.1, maxval=5.0)
maxDailyTrades = input.int(5, "Max Daily Trades")

// Risk management settings
strategy.risk.max_drawdown(10, strategy.percent_of_equity)
strategy.risk.max_intraday_filled_orders(maxDailyTrades)
strategy.risk.max_position_size(strategy.equity * 0.1, strategy.cash)

// Calculate ATR for dynamic stops
atr = ta.atr(atrLength)

// Simple trend following entry
ema20 = ta.ema(close, 20)
ema50 = ta.ema(close, 50)

longCondition = ta.crossover(ema20, ema50) and close > ema50
shortCondition = ta.crossunder(ema20, ema50) and close < ema50

// Position sizing based on risk
calculatePositionSize(entryPrice, stopPrice) =>
    riskAmount = strategy.equity * riskPerTrade / 100
    riskPerShare = math.abs(entryPrice - stopPrice)
    math.floor(riskAmount / riskPerShare)

// Long entries with dynamic position sizing
if longCondition and strategy.position_size == 0
    entryPrice = close
    stopPrice = entryPrice - (atr * atrMultiplier)
    positionSize = calculatePositionSize(entryPrice, stopPrice)
    
    if positionSize > 0
        strategy.entry("Long", strategy.long, qty=positionSize)
        strategy.exit("Long Exit", "Long", stop=stopPrice, profit=atr * atrMultiplier * 2)

// Short entries with dynamic position sizing
if shortCondition and strategy.position_size == 0
    entryPrice = close
    stopPrice = entryPrice + (atr * atrMultiplier)
    positionSize = calculatePositionSize(entryPrice, stopPrice)
    
    if positionSize > 0
        strategy.entry("Short", strategy.short, qty=positionSize)
        strategy.exit("Short Exit", "Short", stop=stopPrice, profit=atr * atrMultiplier * 2)

// Time-based exit (avoid overnight risk)
if hour == 15 and minute == 30  // 3:30 PM
    strategy.close_all(comment="End of day close")

// Plot EMAs
plot(ema20, color=color.blue, title="EMA 20")
plot(ema50, color=color.red, title="EMA 50")

// Display performance metrics
if barstate.islast
    var table perfTable = table.new(position.top_right, 2, 6, bgcolor=color.white, border_width=1)
    table.cell(perfTable, 0, 0, "Net Profit", text_color=color.black)
    table.cell(perfTable, 1, 0, "$" + str.tostring(strategy.netprofit, "#.##"), text_color=color.black)
    table.cell(perfTable, 0, 1, "Profit Factor", text_color=color.black)
    profitFactor = strategy.grossloss != 0 ? strategy.grossprofit / math.abs(strategy.grossloss) : na
    table.cell(perfTable, 1, 1, str.tostring(profitFactor, "#.##"), text_color=color.black)
    table.cell(perfTable, 0, 2, "Win Rate", text_color=color.black)
    winRate = strategy.closedtrades > 0 ? strategy.wintrades / strategy.closedtrades * 100 : 0
    table.cell(perfTable, 1, 2, str.tostring(winRate, "#.##") + "%", text_color=color.black)
    table.cell(perfTable, 0, 3, "Max Drawdown", text_color=color.black)
    table.cell(perfTable, 1, 3, "$" + str.tostring(strategy.max_drawdown, "#.##"), text_color=color.black)
    table.cell(perfTable, 0, 4, "Total Trades", text_color=color.black)
    table.cell(perfTable, 1, 4, str.tostring(strategy.closedtrades), text_color=color.black)
    table.cell(perfTable, 0, 5, "Open Trades", text_color=color.black)
    table.cell(perfTable, 1, 5, str.tostring(strategy.opentrades), text_color=color.black)
```

## Best Practices

1. **Order Management:**
   - Use unique IDs for all orders
   - Handle order states properly
   - Implement proper exit strategies

2. **Position Sizing:**
   - Use percentage-based risk management
   - Consider ATR for dynamic stops
   - Implement maximum position limits

3. **Risk Controls:**
   - Set maximum drawdown limits
   - Limit daily trades and losses
   - Use consecutive loss day limits

4. **Performance Tracking:**
   - Monitor key metrics regularly
   - Display performance statistics
   - Track equity curve progression

5. **Code Organization:**
   - Group related functionality
   - Use descriptive variable names
   - Comment complex logic thoroughly

This documentation provides a comprehensive foundation for building robust Pine Script v6 strategies with proper order management, risk controls, and performance monitoring.