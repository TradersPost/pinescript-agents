# Operators Reference

This document provides a comprehensive reference for all operators available in Pine Script v6.

## Table of Contents

- [Arithmetic Operators](#arithmetic-operators)
- [Comparison Operators](#comparison-operators)
- [Logical Operators](#logical-operators)
- [Ternary Operator](#ternary-operator)
- [Assignment Operators](#assignment-operators)
- [Series Subscript Operator](#series-subscript-operator)
- [Operator Precedence](#operator-precedence)
- [Usage Examples](#usage-examples)

## Arithmetic Operators

Operators for mathematical calculations.

| Operator | Description | Types Supported | Example | Result |
|----------|-------------|----------------|---------|---------|
| `+` | Addition | int, float, string | `5 + 3` | `8` |
| `-` | Subtraction | int, float | `10 - 4` | `6` |
| `*` | Multiplication | int, float | `7 * 2` | `14` |
| `/` | Division | int, float | `15 / 3` | `5.0` |
| `%` | Modulo (remainder) | int, float | `17 % 5` | `2` |

### Arithmetic Operator Details

#### Addition (`+`)
```pinescript
// Numeric addition
sum = 10 + 5           // 15
price_sum = high + low  // Sum of high and low

// String concatenation
message = "Price: " + str.tostring(close)
symbol_info = syminfo.ticker + " - " + syminfo.description
```

#### Subtraction (`-`)
```pinescript
// Numeric subtraction
difference = high - low     // Range calculation
change = close - open       // Bar change

// Unary minus (negation)
negative_rsi = -ta.rsi(close, 14)
```

#### Multiplication (`*`)
```pinescript
// Numeric multiplication
area = length * width
position_value = close * position_size
percentage = value * 0.01
```

#### Division (`/`)
```pinescript
// Numeric division
average = (high + low) / 2
ratio = volume / ta.sma(volume, 20)
percentage = profit / initial_capital
```

#### Modulo (`%`)
```pinescript
// Remainder calculation
even_bar = bar_index % 2 == 0       // Every other bar
every_10th = bar_index % 10 == 0    // Every 10th bar
hour_cycle = hour % 4               // 4-hour cycles
```

## Comparison Operators

Operators for comparing values.

| Operator | Description | Example | Result Type |
|----------|-------------|---------|-------------|
| `==` | Equal to | `close == open` | bool |
| `!=` | Not equal to | `volume != 0` | bool |
| `<` | Less than | `rsi < 30` | bool |
| `>` | Greater than | `close > ma` | bool |
| `<=` | Less than or equal | `low <= support` | bool |
| `>=` | Greater than or equal | `high >= resistance` | bool |

### Comparison Operator Details

#### Equality (`==`)
```pinescript
// Numeric comparison
is_doji = close == open
is_round_number = close % 10 == 0

// String comparison
is_stock = syminfo.type == "stock"
is_crypto = syminfo.type == "crypto"

// Boolean comparison
is_bullish = close > open
same_direction = is_bullish == (volume > ta.sma(volume, 20))
```

#### Inequality (`!=`)
```pinescript
// Not equal checks
has_volume = volume != 0
not_doji = close != open
different_timeframe = timeframe.period != "1D"
```

#### Less Than (`<`)
```pinescript
// Oversold conditions
oversold = ta.rsi(close, 14) < 30
below_ma = close < ta.sma(close, 50)
low_volume = volume < ta.sma(volume, 20) * 0.5
```

#### Greater Than (`>`)
```pinescript
// Overbought conditions
overbought = ta.rsi(close, 14) > 70
above_ma = close > ta.sma(close, 50)
high_volume = volume > ta.sma(volume, 20) * 2
```

## Logical Operators

Operators for combining boolean expressions.

| Operator | Description | Example | Result |
|----------|-------------|---------|---------|
| `and` | Logical AND | `rsi < 30 and volume > avg_vol` | bool |
| `or` | Logical OR | `close > ma50 or close > ma200` | bool |
| `not` | Logical NOT | `not (rsi > 70)` | bool |

### Logical Operator Details

#### AND (`and`)
```pinescript
// Multiple conditions must be true
bullish_signal = close > open and volume > ta.sma(volume, 20) and ta.rsi(close, 14) < 70
trend_up = close > ta.sma(close, 50) and ta.sma(close, 50) > ta.sma(close, 200)
breakout = close > ta.highest(high[1], 20) and volume > ta.sma(volume, 20) * 1.5
```

#### OR (`or`)
```pinescript
// Any condition can be true
reversal_signal = ta.rsi(close, 14) < 30 or ta.rsi(close, 14) > 70
support_level = close <= ta.lowest(low, 20) or close <= ta.sma(close, 200)
high_activity = volume > ta.sma(volume, 20) * 2 or math.abs(close - open) > ta.atr(14)
```

#### NOT (`not`)
```pinescript
// Negation of condition
not_overbought = not (ta.rsi(close, 14) > 70)
not_trending = not (close > ta.sma(close, 50))
market_closed = not (hour >= 9 and hour <= 16)
```

## Ternary Operator

The conditional operator for inline if-else logic.

| Syntax | Description | Example |
|--------|-------------|---------|
| `condition ? value_if_true : value_if_false` | Returns one of two values based on condition | `color_val = close > open ? color.green : color.red` |

### Ternary Operator Examples

```pinescript
// Color assignment
bar_color = close > open ? color.green : color.red
signal_color = rsi > 70 ? color.red : rsi < 30 ? color.lime : color.gray

// Value assignment
trend_direction = close > ta.sma(close, 50) ? 1 : -1
position_size = strategy.position_size > 0 ? "Long" : strategy.position_size < 0 ? "Short" : "Flat"

// Conditional calculations
stop_loss = strategy.position_size > 0 ? low - ta.atr(14) : high + ta.atr(14)
target_price = close > open ? high + (high - low) : low - (high - low)

// Nested ternary
risk_level = ta.rsi(close, 14) > 80 ? "Very High" : 
             ta.rsi(close, 14) > 60 ? "High" : 
             ta.rsi(close, 14) < 20 ? "Very Low" : 
             ta.rsi(close, 14) < 40 ? "Low" : "Medium"
```

## Assignment Operators

Operators for assigning and modifying variables.

| Operator | Description | Example | Equivalent |
|----------|-------------|---------|------------|
| `=` | Simple assignment | `x = 5` | `x = 5` |
| `:=` | Reassignment | `x := x + 1` | `x := x + 1` |
| `+=` | Add and assign | `x += 5` | `x := x + 5` |
| `-=` | Subtract and assign | `x -= 3` | `x := x - 3` |
| `*=` | Multiply and assign | `x *= 2` | `x := x * 2` |
| `/=` | Divide and assign | `x /= 4` | `x := x / 4` |
| `%=` | Modulo and assign | `x %= 3` | `x := x % 3` |

### Assignment Operator Details

#### Simple Assignment (`=`)
```pinescript
// Initial variable declaration
var float total = 0.0
var int count = 0
var string status = "waiting"

// Cannot reassign with = (will cause error)
// total = total + close  // ERROR!
```

#### Reassignment (`:=`)
```pinescript
// Modify existing variables
var float running_total = 0.0
running_total := running_total + close

var int bar_count = 0
bar_count := bar_count + 1

// Conditional reassignment
var string trend = "neutral"
if close > ta.sma(close, 50)
    trend := "bullish"
else if close < ta.sma(close, 50)
    trend := "bearish"
```

#### Compound Assignment Operators
```pinescript
// Add and assign (+=)
var float sum = 0.0
sum += close           // sum := sum + close

// Subtract and assign (-=)
var float difference = 100.0
difference -= close    // difference := difference - close

// Multiply and assign (*=)
var float multiplier = 1.0
multiplier *= 1.1      // multiplier := multiplier * 1.1

// Divide and assign (/=)
var float average = close
average /= 2           // average := average / 2

// Modulo and assign (%=)
var int counter = 0
counter += 1
counter %= 10          // Reset counter every 10 bars
```

## Series Subscript Operator

The historical reference operator for accessing past values.

| Syntax | Description | Example |
|--------|-------------|---------|
| `series[n]` | Access value n bars ago | `close[1]` (previous close) |

### Series Subscript Examples

```pinescript
// Previous values
prev_close = close[1]
prev_high = high[1]
close_2_bars_ago = close[2]

// Comparisons with historical data
higher_close = close > close[1]
higher_high = high > high[1]
gap_up = low > high[1]

// Calculations with historical data
price_change = close - close[1]
range_expansion = (high - low) > (high[1] - low[1])
volume_increase = volume > volume[1]

// Pattern detection
hammer = close > open and (close - open) > 2 * (open - low) and (high - close) < (close - open) / 3
doji = math.abs(close - open) < (high - low) * 0.1

// Moving calculations
sma_manual = (close + close[1] + close[2] + close[3] + close[4]) / 5
momentum = close - close[10]
```

## Operator Precedence

Operators are evaluated in the following order (highest to lowest precedence):

| Precedence | Operators | Associativity | Example |
|------------|-----------|---------------|---------|
| 1 (Highest) | `[]` (subscript) | Left to right | `close[1] + open[1]` |
| 2 | `not`, `-` (unary) | Right to left | `not oversold` |
| 3 | `*`, `/`, `%` | Left to right | `high * 2 / 3` |
| 4 | `+`, `-` (binary) | Left to right | `high + low - close` |
| 5 | `<`, `<=`, `>`, `>=` | Left to right | `close > open > low` |
| 6 | `==`, `!=` | Left to right | `close == high != low` |
| 7 | `and` | Left to right | `a and b and c` |
| 8 | `or` | Left to right | `a or b or c` |
| 9 | `? :` (ternary) | Right to left | `a ? b : c ? d : e` |
| 10 (Lowest) | `=`, `:=`, `+=`, `-=`, `*=`, `/=`, `%=` | Right to left | `a := b += c` |

### Precedence Examples

```pinescript
// Without parentheses (following precedence)
result1 = 10 + 5 * 2        // 20 (5 * 2 = 10, then 10 + 10 = 20)
result2 = close > open and volume > 1000  // Evaluated as: (close > open) and (volume > 1000)

// With parentheses (overriding precedence)
result3 = (10 + 5) * 2      // 30 (10 + 5 = 15, then 15 * 2 = 30)
result4 = close > (open and volume > 1000)  // Different logic flow

// Complex expression
signal = close > ta.sma(close, 20) and ta.rsi(close, 14) < 70 or volume > ta.sma(volume, 20) * 2
// Evaluated as: ((close > ta.sma(close, 20)) and (ta.rsi(close, 14) < 70)) or (volume > (ta.sma(volume, 20) * 2))

// Recommended: Use parentheses for clarity
signal_clear = (close > ta.sma(close, 20) and ta.rsi(close, 14) < 70) or (volume > ta.sma(volume, 20) * 2)
```

## Usage Examples

### Complete Trading Signal
```pinescript
//@version=6
indicator("Operator Examples")

// Define variables
rsi = ta.rsi(close, 14)
sma50 = ta.sma(close, 50)
volume_avg = ta.sma(volume, 20)

// Arithmetic operations
price_change = close - open
price_change_pct = (close - open) / open * 100
volatility = (high - low) / close * 100

// Comparison operations
bullish_bar = close > open
above_average_volume = volume > volume_avg
oversold = rsi < 30
overbought = rsi > 70

// Logical operations
bullish_signal = bullish_bar and above_average_volume and oversold
bearish_signal = not bullish_bar and above_average_volume and overbought
neutral = not bullish_signal and not bearish_signal

// Ternary operations
signal_color = bullish_signal ? color.green : bearish_signal ? color.red : color.gray
signal_text = bullish_signal ? "BUY" : bearish_signal ? "SELL" : "HOLD"

// Assignment operations
var float total_volume = 0.0
total_volume += volume

var int signal_count = 0
if bullish_signal or bearish_signal
    signal_count += 1

// Series subscript operations
prev_signal = bullish_signal[1]
signal_change = bullish_signal != prev_signal
consecutive_bullish = bullish_signal and bullish_signal[1] and bullish_signal[2]

// Plot results
plot(rsi, color=signal_color)
plotchar(bullish_signal, "Buy Signal", "▲", location.belowbar, color.green, size=size.small)
plotchar(bearish_signal, "Sell Signal", "▼", location.abovebar, color.red, size=size.small)
```

### Risk Management Example
```pinescript
//@version=6
strategy("Risk Management with Operators")

// Input parameters
risk_percent = input.float(2.0, "Risk Percent", minval=0.1, maxval=10.0)
rr_ratio = input.float(2.0, "Risk/Reward Ratio", minval=1.0, maxval=5.0)

// Entry conditions using logical operators
ma_short = ta.sma(close, 10)
ma_long = ta.sma(close, 50)
rsi = ta.rsi(close, 14)

// Complex entry condition
long_condition = ma_short > ma_long and close > ma_short and rsi > 50 and rsi < 70 and volume > ta.sma(volume, 20)
short_condition = ma_short < ma_long and close < ma_short and rsi < 50 and rsi > 30 and volume > ta.sma(volume, 20)

// Risk calculations using arithmetic operators
account_value = strategy.equity
risk_amount = account_value * (risk_percent / 100)
atr_value = ta.atr(14)

// Position sizing using ternary operator
long_stop = close - (atr_value * 2)
short_stop = close + (atr_value * 2)
long_target = close + (atr_value * 2 * rr_ratio)
short_target = close - (atr_value * 2 * rr_ratio)

// Calculate position size
long_risk_per_share = close - long_stop
short_risk_per_share = short_stop - close
long_position_size = long_risk_per_share > 0 ? risk_amount / long_risk_per_share : 0
short_position_size = short_risk_per_share > 0 ? risk_amount / short_risk_per_share : 0

// Strategy entries with compound assignments
if long_condition and strategy.position_size == 0
    strategy.entry("Long", strategy.long, qty=long_position_size)
    strategy.exit("Long Exit", "Long", stop=long_stop, limit=long_target)

if short_condition and strategy.position_size == 0
    strategy.entry("Short", strategy.short, qty=short_position_size)
    strategy.exit("Short Exit", "Short", stop=short_stop, limit=short_target)
```

## Best Practices

1. **Use Parentheses for Clarity**: Even when not required by precedence rules
2. **Logical Operator Efficiency**: Place most likely false conditions first in `and` operations
3. **Ternary Nesting**: Limit nesting depth for readability
4. **Assignment Consistency**: Use `:=` for reassignment, `=` only for initial declaration
5. **Series References**: Be mindful of lookback limitations (500 bars max)

## Common Pitfalls

1. **Assignment Confusion**: Using `=` instead of `:=` for reassignment
2. **Precedence Issues**: Not using parentheses in complex expressions
3. **Type Mismatches**: Comparing incompatible types
4. **Series vs Simple**: Using series subscript on simple types
5. **Division by Zero**: Not checking for zero denominators

## Related Documentation

- [Language Reference](../language-reference.md)
- [Built-in Variables](built-in-variables.md)
- [Keywords Reference](keywords.md)