# Pine Script v6 Math Functions

This comprehensive guide covers all mathematical functions available in the `math.*` namespace in Pine Script v6. These functions provide essential mathematical operations for technical analysis, statistical calculations, and trading algorithm development.

## Table of Contents

1. [Basic Arithmetic Functions](#basic-arithmetic-functions)
2. [Trigonometric Functions](#trigonometric-functions)
3. [Logarithmic and Exponential Functions](#logarithmic-and-exponential-functions)
4. [Statistical Functions](#statistical-functions)
5. [Random Number Generation](#random-number-generation)
6. [Mathematical Constants](#mathematical-constants)
7. [Trading Applications](#trading-applications)
8. [Performance Considerations](#performance-considerations)

---

## Basic Arithmetic Functions

### math.abs(number)

Returns the absolute value of a number.

**Syntax:**
```pinescript
math.abs(number) → series float
```

**Parameters:**
- `number` (series int/float): The number to get absolute value of

**Returns:** Absolute value as series float

**Example:**
```pinescript
//@version=6
indicator("Math.abs Example", overlay=true)

price_change = close - open
abs_change = math.abs(price_change)

plot(abs_change, title="Absolute Price Change", color=color.blue)

// Trading application: Calculate absolute percentage change
abs_pct_change = math.abs((close - close[1]) / close[1] * 100)
plotchar(abs_pct_change > 2 ? abs_pct_change : na, 
         title="High Volatility", 
         char="⚡", 
         location=location.abovebar, 
         color=color.red)
```

**Common Use Cases:**
- Volatility measurements
- Risk calculations
- Distance calculations for stop-loss levels

---

### math.sign(number)

Returns the sign of a number: 1 for positive, -1 for negative, 0 for zero.

**Syntax:**
```pinescript
math.sign(number) → series float
```

**Parameters:**
- `number` (series int/float): The number to check sign of

**Returns:** Sign as series float (1, -1, or 0)

**Example:**
```pinescript
//@version=6
indicator("Math.sign Example", overlay=false)

price_momentum = close - close[20]
momentum_direction = math.sign(price_momentum)

plot(momentum_direction, title="Momentum Direction", 
     color=momentum_direction > 0 ? color.green : color.red,
     style=plot.style_histogram)

// Trading application: Trend direction filter
bullish_trend = momentum_direction > 0
bearish_trend = momentum_direction < 0

bgcolor(bullish_trend ? color.new(color.green, 95) : 
        bearish_trend ? color.new(color.red, 95) : na)
```

---

### math.round(number, precision)

Rounds a number to a specified precision.

**Syntax:**
```pinescript
math.round(number) → series float
math.round(number, precision) → series float
```

**Parameters:**
- `number` (series int/float): The number to round
- `precision` (series int): Number of decimal places (optional, default: 0)

**Returns:** Rounded number as series float

**Example:**
```pinescript
//@version=6
indicator("Math.round Example", overlay=true)

// Round price to nearest cent
rounded_price = math.round(close, 2)

// Round to nearest 5 cents
nearest_nickel = math.round(close * 20) / 20

// Trading application: Position sizing with round lots
equity = 10000
risk_percent = 2
stop_distance = math.abs(close - low[1])
position_size = math.round((equity * risk_percent / 100) / stop_distance)

label.new(bar_index, high, 
          "Position Size: " + str.tostring(position_size),
          style=label.style_label_down,
          color=color.blue)
```

---

### math.floor(number)

Returns the largest integer less than or equal to the number.

**Syntax:**
```pinescript
math.floor(number) → series float
```

**Parameters:**
- `number` (series int/float): The number to floor

**Returns:** Floor value as series float

**Example:**
```pinescript
//@version=6
indicator("Math.floor Example", overlay=false)

// Price level support/resistance
support_level = math.floor(close)
resistance_level = math.floor(close) + 1

plot(support_level, title="Support Level", color=color.green)
plot(resistance_level, title="Resistance Level", color=color.red)

// Trading application: Grid trading levels
grid_size = 10
grid_level = math.floor(close / grid_size) * grid_size
```

---

### math.ceil(number)

Returns the smallest integer greater than or equal to the number.

**Syntax:**
```pinescript
math.ceil(number) → series float
```

**Parameters:**
- `number` (series int/float): The number to ceil

**Returns:** Ceiling value as series float

**Example:**
```pinescript
//@version=6
indicator("Math.ceil Example", overlay=true)

// Dynamic support/resistance levels
next_dollar = math.ceil(close)
next_ten = math.ceil(close / 10) * 10

hline(next_dollar, title="Next Dollar", color=color.blue, linestyle=hline.style_dashed)
hline(next_ten, title="Next $10", color=color.red, linestyle=hline.style_solid)

// Trading application: Option strike selection
strike_spacing = 5
next_strike = math.ceil(close / strike_spacing) * strike_spacing
```

---

## Trigonometric Functions

### math.sin(angle), math.cos(angle), math.tan(angle)

Trigonometric functions for sine, cosine, and tangent.

**Syntax:**
```pinescript
math.sin(angle) → series float
math.cos(angle) → series float  
math.tan(angle) → series float
```

**Parameters:**
- `angle` (series int/float): Angle in radians

**Returns:** Trigonometric value as series float

**Example:**
```pinescript
//@version=6
indicator("Trigonometric Waves", overlay=false)

// Create sine wave oscillator
bars_back = bar_index - math.floor(bar_index / 100) * 100
angle = bars_back * 2 * math.pi / 100

sine_wave = math.sin(angle)
cosine_wave = math.cos(angle)

plot(sine_wave, title="Sine Wave", color=color.blue)
plot(cosine_wave, title="Cosine Wave", color=color.red)

// Trading application: Cycle analysis
cycle_length = 20
cycle_angle = bar_index * 2 * math.pi / cycle_length
cycle_oscillator = math.sin(cycle_angle)

// Generate signals when crossing zero
bullish_signal = cycle_oscillator > 0 and cycle_oscillator[1] <= 0
bearish_signal = cycle_oscillator < 0 and cycle_oscillator[1] >= 0

plotshape(bullish_signal, title="Bullish Cycle", 
          style=shape.triangleup, location=location.bottom, 
          color=color.green, size=size.small)
plotshape(bearish_signal, title="Bearish Cycle", 
          style=shape.triangledown, location=location.top, 
          color=color.red, size=size.small)
```

---

### math.asin(number), math.acos(number), math.atan(number)

Inverse trigonometric functions.

**Syntax:**
```pinescript
math.asin(number) → series float
math.acos(number) → series float
math.atan(number) → series float
```

**Parameters:**
- `number` (series int/float): Input value

**Returns:** Angle in radians as series float

**Example:**
```pinescript
//@version=6
indicator("Inverse Trigonometric Example", overlay=false)

// Normalize price change to [-1, 1] range for asin
price_change = (close - close[1]) / close[1]
normalized_change = math.max(-0.99, math.min(0.99, price_change * 100))

angle = math.asin(normalized_change)
plot(angle, title="Price Change Angle", color=color.purple)

// Trading application: Angle-based momentum
momentum_angle = math.atan((close - close[10]) / 10)
steep_momentum = math.abs(momentum_angle) > math.pi / 6  // 30 degrees

bgcolor(steep_momentum ? color.new(color.yellow, 90) : na)
```

---

## Logarithmic and Exponential Functions

### math.log(number), math.log10(number)

Natural logarithm and base-10 logarithm functions.

**Syntax:**
```pinescript
math.log(number) → series float
math.log10(number) → series float
```

**Parameters:**
- `number` (series int/float): Input value (must be positive)

**Returns:** Logarithm as series float

**Example:**
```pinescript
//@version=6
indicator("Logarithmic Functions", overlay=false)

// Log returns calculation
log_return = math.log(close / close[1])
plot(log_return, title="Log Returns", color=color.blue)

// Trading application: Log-normal distribution analysis
cumulative_log_return = math.sum(log_return, 20)
plot(cumulative_log_return, title="20-Period Cumulative Log Return", color=color.red)

// Volatility estimation using log returns
log_return_squared = log_return * log_return
volatility = math.sqrt(math.sum(log_return_squared, 20) / 20) * math.sqrt(252)
```

---

### math.exp(number)

Exponential function (e raised to the power of number).

**Syntax:**
```pinescript
math.exp(number) → series float
```

**Parameters:**
- `number` (series int/float): Exponent value

**Returns:** e^number as series float

**Example:**
```pinescript
//@version=6
indicator("Exponential Function Example", overlay=false)

// Exponential moving average calculation (manual implementation)
alpha = 2 / (20 + 1)
var float ema_manual = na
ema_manual := na(ema_manual) ? close : alpha * close + (1 - alpha) * ema_manual

// Exponential decay function for weighting
decay_factor = 0.1
weight = math.exp(-decay_factor * (bar_index - bar_index[20]))

plot(weight, title="Exponential Decay Weight", color=color.green)

// Trading application: Exponential probability distribution
price_change = (close - close[1]) / close[1]
probability = math.exp(-math.abs(price_change) * 100)
```

---

### math.pow(base, exponent)

Power function (base raised to the power of exponent).

**Syntax:**
```pinescript
math.pow(base, exponent) → series float
```

**Parameters:**
- `base` (series int/float): Base number
- `exponent` (series int/float): Exponent value

**Returns:** base^exponent as series float

**Example:**
```pinescript
//@version=6
indicator("Power Function Example", overlay=false)

// Quadratic price momentum
price_momentum = (close - close[10]) / close[10] * 100
quadratic_momentum = math.pow(price_momentum, 2) * math.sign(price_momentum)

plot(quadratic_momentum, title="Quadratic Momentum", color=color.blue)

// Trading application: Non-linear transformation of RSI
rsi_value = ta.rsi(close, 14)
transformed_rsi = math.pow(rsi_value / 100, 2) * 100

plot(transformed_rsi, title="Transformed RSI", color=color.red)
hline(25, title="Oversold", color=color.green)
hline(75, title="Overbought", color=color.red)
```

---

### math.sqrt(number)

Square root function.

**Syntax:**
```pinescript
math.sqrt(number) → series float
```

**Parameters:**
- `number` (series int/float): Input value (must be non-negative)

**Returns:** Square root as series float

**Example:**
```pinescript
//@version=6
indicator("Square Root Example", overlay=false)

// True Range calculation (manual)
tr1 = high - low
tr2 = math.abs(high - close[1])
tr3 = math.abs(low - close[1])
true_range = math.max(tr1, math.max(tr2, tr3))

// RMS (Root Mean Square) of returns
returns = (close - close[1]) / close[1]
squared_returns = math.pow(returns, 2)
mean_squared_returns = ta.sma(squared_returns, 20)
rms_returns = math.sqrt(mean_squared_returns)

plot(rms_returns * 100, title="RMS Returns %", color=color.purple)

// Trading application: Volatility normalization
volatility = ta.stdev(close, 20)
normalized_price_change = (close - close[1]) / volatility
```

---

## Statistical Functions

### math.min(value1, value2), math.max(value1, value2)

Returns the minimum or maximum of two values.

**Syntax:**
```pinescript
math.min(value1, value2) → series float
math.max(value1, value2) → series float
```

**Parameters:**
- `value1` (series int/float): First value
- `value2` (series int/float): Second value

**Returns:** Minimum or maximum value as series float

**Example:**
```pinescript
//@version=6
indicator("Min/Max Functions", overlay=true)

// Dynamic support and resistance
daily_high = math.max(high, high[1])
daily_low = math.min(low, low[1])

plot(daily_high, title="Running High", color=color.red)
plot(daily_low, title="Running Low", color=color.green)

// Trading application: Risk management
entry_price = close
stop_loss = entry_price * 0.98
take_profit = entry_price * 1.04

// Ensure minimum risk-reward ratio
min_reward = math.abs(entry_price - stop_loss) * 2
adjusted_take_profit = math.max(take_profit, entry_price + min_reward)

// Position sizing with maximum risk
max_risk_per_trade = 1000
position_size = math.min(max_risk_per_trade / math.abs(entry_price - stop_loss), 100)
```

---

### math.avg(value1, value2, ...)

Returns the average of the input values.

**Syntax:**
```pinescript
math.avg(value1, value2) → series float
math.avg(value1, value2, value3) → series float
// ... up to multiple values
```

**Parameters:**
- Multiple numeric values (series int/float)

**Returns:** Average value as series float

**Example:**
```pinescript
//@version=6
indicator("Average Function Example", overlay=true)

// Multi-timeframe average
htf_close = request.security(syminfo.tickerid, "1D", close)
avg_price = math.avg(close, htf_close)

plot(avg_price, title="Multi-timeframe Average", color=color.blue)

// Trading application: Composite oscillator
rsi_14 = ta.rsi(close, 14)
rsi_21 = ta.rsi(close, 21)
stoch = ta.stoch(close, high, low, 14)

composite_oscillator = math.avg(rsi_14, rsi_21, stoch)
plot(composite_oscillator, title="Composite Oscillator", color=color.purple)

hline(70, title="Overbought", color=color.red)
hline(30, title="Oversold", color=color.green)
```

---

### math.sum(value, length)

Note: This is actually `math.sum()` from the `ta.*` namespace, but commonly used with math functions.

**Example:**
```pinescript
//@version=6
indicator("Sum with Math Functions", overlay=false)

// Calculate sum of absolute returns
abs_returns = math.abs((close - close[1]) / close[1])
sum_abs_returns = math.sum(abs_returns, 20)

plot(sum_abs_returns * 100, title="Sum of Absolute Returns %", color=color.blue)

// Trading application: Volatility regime detection
high_volatility = sum_abs_returns > ta.sma(sum_abs_returns, 50) * 1.5
bgcolor(high_volatility ? color.new(color.red, 90) : na)
```

---

## Random Number Generation

### math.random(min, max, seed)

Generates a random number between min and max values.

**Syntax:**
```pinescript
math.random() → series float
math.random(min, max) → series float
math.random(min, max, seed) → series float
```

**Parameters:**
- `min` (series int/float): Minimum value (optional, default: 0)
- `max` (series int/float): Maximum value (optional, default: 1)
- `seed` (series int): Random seed for reproducibility (optional)

**Returns:** Random number as series float

**Example:**
```pinescript
//@version=6
indicator("Random Number Example", overlay=false)

// Generate random walk
var float random_walk = 0
random_step = math.random(-1, 1, 12345)  // Fixed seed for reproducibility
random_walk := random_walk + random_step

plot(random_walk, title="Random Walk", color=color.blue)

// Trading application: Monte Carlo simulation for position sizing
num_simulations = 10
var array<float> simulation_results = array.new<float>()

if bar_index % 20 == 0  // Run simulation every 20 bars
    array.clear(simulation_results)
    for i = 0 to num_simulations - 1
        random_return = math.random(-0.05, 0.05)  // ±5% random return
        array.push(simulation_results, random_return)
    
    avg_return = array.avg(simulation_results)
    worst_case = array.min(simulation_results)
    
    label.new(bar_index, 0, 
              "Avg: " + str.tostring(avg_return, "#.###") + 
              "\nWorst: " + str.tostring(worst_case, "#.###"),
              style=label.style_label_right)

// Random entry timing (for testing purposes)
random_entry = math.random(0, 1) > 0.95  // 5% chance per bar
plotshape(random_entry, title="Random Entry", 
          style=shape.triangleup, location=location.bottom, 
          color=color.green, size=size.tiny)
```

---

## Mathematical Constants

### math.pi, math.e, math.phi, math.rphi

Important mathematical constants.

**Values:**
- `math.pi`: π (3.14159...)
- `math.e`: Euler's number (2.71828...)
- `math.phi`: Golden ratio (1.61803...)
- `math.rphi`: Reciprocal of golden ratio (0.61803...)

**Example:**
```pinescript
//@version=6
indicator("Mathematical Constants", overlay=false)

// Display constants
plot(math.pi, title="Pi", color=color.blue)
plot(math.e, title="Euler's Number", color=color.red)
plot(math.phi, title="Golden Ratio", color=color.green)
plot(math.rphi, title="Reciprocal Golden Ratio", color=color.orange)

// Trading application: Fibonacci-based calculations
fib_multiplier = math.phi
dynamic_resistance = close * fib_multiplier
dynamic_support = close * math.rphi

// Golden ratio spiral for trend analysis
spiral_factor = math.pow(math.phi, (bar_index % 100) / 25)

// Circle calculations for cycle analysis
circle_angle = bar_index * 2 * math.pi / 252  // Annual cycle
cycle_sine = math.sin(circle_angle)
cycle_cosine = math.cos(circle_angle)
```

---

## Trading Applications

### Volatility Calculations

```pinescript
//@version=6
indicator("Advanced Volatility Calculations", overlay=false)

// True Range with math functions
tr1 = high - low
tr2 = math.abs(high - close[1])
tr3 = math.abs(low - close[1])
true_range = math.max(tr1, math.max(tr2, tr3))

// Parkinson volatility (using high-low range)
hl_ratio = math.log(high / low)
parkinson_vol = math.sqrt(math.sum(math.pow(hl_ratio, 2), 20) / (4 * math.log(2) * 20))

// Rogers-Satchell volatility
rs_vol_component = math.log(high / close) * math.log(high / open) + 
                   math.log(low / close) * math.log(low / open)
rs_volatility = math.sqrt(math.sum(rs_vol_component, 20) / 20)

plot(parkinson_vol * 100, title="Parkinson Volatility %", color=color.blue)
plot(rs_volatility * 100, title="Rogers-Satchell Volatility %", color=color.red)
```

### Risk Management

```pinescript
//@version=6
indicator("Math-Based Risk Management", overlay=true)

// Kelly Criterion position sizing
win_rate = 0.6  // 60% win rate
avg_win = 0.03  // 3% average win
avg_loss = 0.02  // 2% average loss

kelly_fraction = win_rate - ((1 - win_rate) / (avg_win / avg_loss))
kelly_position_size = math.max(0, math.min(0.25, kelly_fraction))  // Cap at 25%

// VaR calculation using normal distribution
returns = math.log(close / close[1])
return_mean = ta.sma(returns, 252)
return_std = ta.stdev(returns, 252)

// 5% VaR (95% confidence)
var_95 = return_mean - 1.645 * return_std  // Z-score for 95% confidence
var_amount = close * (1 - math.exp(var_95))

label.new(bar_index, high, 
          "Kelly: " + str.tostring(kelly_position_size, "#.##") + 
          "\nVaR 95%: $" + str.tostring(var_amount, "#.##"),
          style=label.style_label_down)
```

### Advanced Oscillators

```pinescript
//@version=6
indicator("Math-Enhanced Oscillators", overlay=false)

// Sine-wave smoothed RSI
rsi_raw = ta.rsi(close, 14)
rsi_angle = (rsi_raw - 50) * math.pi / 50  // Convert to radians
sine_rsi = 50 + 50 * math.sin(rsi_angle)

// Logarithmic transformation of Stochastic
stoch_raw = ta.stoch(close, high, low, 14)
log_stoch = math.log(stoch_raw + 1) / math.log(101) * 100  // Normalize log

// Exponential-weighted momentum
price_change = close - close[1]
var float exp_momentum = 0
alpha = 2 / 21
exp_momentum := alpha * price_change + (1 - alpha) * exp_momentum

plot(sine_rsi, title="Sine RSI", color=color.blue)
plot(log_stoch, title="Log Stochastic", color=color.red)
plot(exp_momentum * 1000, title="Exp Momentum", color=color.green)

hline(70, "Overbought", color=color.red)
hline(30, "Oversold", color=color.green)
hline(0, "Zero Line", color=color.gray)
```

---

## Performance Considerations

### Optimization Tips

1. **Avoid Repeated Calculations**: Store complex math results in variables
```pinescript
// Good
calculated_value = math.sqrt(math.pow(close - open, 2) + math.pow(high - low, 2))
result1 = calculated_value * 1.5
result2 = calculated_value * 2.0

// Bad - calculates sqrt and pow twice
result1 = math.sqrt(math.pow(close - open, 2) + math.pow(high - low, 2)) * 1.5
result2 = math.sqrt(math.pow(close - open, 2) + math.pow(high - low, 2)) * 2.0
```

2. **Use Built-in Functions When Available**: Many math operations have optimized built-ins
```pinescript
// Prefer built-in functions
volatility = ta.stdev(close, 20)

// Over manual calculation
mean = ta.sma(close, 20)
variance = ta.sma(math.pow(close - mean, 2), 20)
manual_stdev = math.sqrt(variance)
```

3. **Minimize Division Operations**: Division is slower than multiplication
```pinescript
// Better
multiplier = 1 / 252
daily_vol = annual_vol * multiplier

// Slower
daily_vol = annual_vol / 252
```

### Error Handling

Always validate inputs for math functions that have domain restrictions:

```pinescript
// Safe logarithm calculation
safe_log_return = close > 0 and close[1] > 0 ? math.log(close / close[1]) : na

// Safe square root
safe_sqrt = value >= 0 ? math.sqrt(value) : na

// Safe division with math functions
safe_ratio = denominator != 0 ? numerator / denominator : na
```

---

## Summary

Pine Script v6's math functions provide a comprehensive toolkit for:

- **Basic Arithmetic**: abs, sign, round, floor, ceil for data manipulation
- **Trigonometry**: sin, cos, tan, asin, acos, atan for cycle analysis
- **Logarithmic**: log, log10, exp, pow, sqrt for returns and volatility
- **Statistical**: min, max, avg for data aggregation
- **Random**: random for simulation and testing
- **Constants**: pi, e, phi, rphi for mathematical calculations

These functions enable sophisticated trading algorithms, risk management systems, and technical analysis tools. Combined with Pine Script's built-in technical analysis functions, they provide the mathematical foundation for professional trading systems.

Remember to:
- Validate inputs for domain-restricted functions
- Optimize performance by avoiding repeated calculations
- Use appropriate precision for financial calculations
- Handle edge cases and invalid data gracefully
- Test mathematical models thoroughly before live trading