# Namespaces Reference

This document provides a comprehensive reference for all namespaces available in Pine Script v6.

## Table of Contents

- [Technical Analysis (ta)](#technical-analysis-ta)
- [Mathematical Functions (math)](#mathematical-functions-math)
- [String Operations (str)](#string-operations-str)
- [Array Operations (array)](#array-operations-array)
- [Matrix Operations (matrix)](#matrix-operations-matrix)
- [Map Operations (map)](#map-operations-map)
- [Request Functions (request)](#request-functions-request)
- [Strategy Functions (strategy)](#strategy-functions-strategy)
- [Input Functions (input)](#input-functions-input)
- [Time Functions (time)](#time-functions-time)
- [Color Functions (color)](#color-functions-color)
- [Drawing Objects](#drawing-objects)
- [Built-in Constants](#built-in-constants)
- [Usage Examples](#usage-examples)

## Technical Analysis (ta)

The `ta` namespace contains all technical analysis functions for indicators and calculations.

### Purpose
Provides comprehensive technical analysis tools including moving averages, oscillators, trend indicators, and statistical functions.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Moving Averages** | `sma()`, `ema()`, `wma()`, `rma()`, `swma()`, `alma()`, `hma()`, `linreg()`, `vwma()` | Various moving average calculations |
| **Oscillators** | `rsi()`, `stoch()`, `cci()`, `mfi()`, `roc()`, `mom()`, `tsi()` | Momentum and oscillator indicators |
| **Volatility** | `atr()`, `tr()`, `stdev()`, `variance()`, `range()` | Volatility and range measurements |
| **Volume** | `obv()`, `pvt()`, `ad()`, `pvi()`, `nvi()` | Volume-based indicators |
| **Trend** | `adx()`, `dmi()`, `aroon()`, `sar()` | Trend direction and strength |
| **Support/Resistance** | `pivot_point_levels()`, `supertrend()` | Key level calculations |
| **Statistical** | `correlation()`, `percentile_linear_interpolation()`, `percentile_nearest_rank()` | Statistical analysis |
| **Utility** | `change()`, `cross()`, `crossover()`, `crossunder()`, `rising()`, `falling()`, `highest()`, `lowest()` | Utility functions |

### Common Usage Examples

```pinescript
// Moving averages
sma20 = ta.sma(close, 20)
ema50 = ta.ema(close, 50)
alma21 = ta.alma(close, 21, 0.85, 6)

// Oscillators
rsi14 = ta.rsi(close, 14)
stoch_k = ta.stoch(close, high, low, 14)
cci20 = ta.cci(hlc3, 20)

// Volatility
atr14 = ta.atr(14)
bb_basis = ta.sma(close, 20)
bb_dev = ta.stdev(close, 20)

// Trend analysis
adx_value = ta.adx(high, low, close, 14)
sar_value = ta.sar(0.02, 0.02, 0.2)

// Utility functions
price_change = ta.change(close)
ma_cross = ta.crossover(close, sma20)
```

## Mathematical Functions (math)

The `math` namespace provides mathematical operations and constants.

### Purpose
Essential mathematical functions for calculations, transformations, and mathematical operations.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Basic Math** | `abs()`, `sign()`, `round()`, `floor()`, `ceil()`, `max()`, `min()` | Basic mathematical operations |
| **Powers & Roots** | `pow()`, `sqrt()`, `exp()`, `log()`, `log10()` | Exponential and logarithmic functions |
| **Trigonometry** | `sin()`, `cos()`, `tan()`, `asin()`, `acos()`, `atan()`, `atan2()` | Trigonometric functions |
| **Statistical** | `avg()`, `sum()`, `random()` | Statistical and random functions |
| **Constants** | `math.pi`, `math.e`, `math.phi` | Mathematical constants |
| **Conversion** | `todegrees()`, `toradians()` | Angle conversions |

### Usage Examples

```pinescript
// Basic operations
absolute_change = math.abs(close - open)
price_rounded = math.round(close, 2)
range_max = math.max(high - low, math.abs(close - open))

// Mathematical calculations
price_log = math.log(close)
volatility_sqrt = math.sqrt(ta.stdev(close, 20))

// Trigonometry for cycles
cycle_position = math.sin(2 * math.pi * bar_index / 50)

// Random for testing
random_value = math.random(0, 100)
```

## String Operations (str)

The `str` namespace handles string manipulation and formatting.

### Purpose
String processing, formatting, and conversion functions for text operations.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Conversion** | `tostring()`, `tonumber()` | Type conversions |
| **Formatting** | `format()` | Advanced string formatting |
| **Manipulation** | `length()`, `substring()`, `pos()`, `startswith()`, `endswith()` | String operations |
| **Case** | `upper()`, `lower()` | Case conversions |
| **Splitting** | `split()` | String splitting |
| **Replacement** | `replace()`, `replace_all()` | String replacement |
| **Matching** | `match()`, `contains()` | Pattern matching |

### Usage Examples

```pinescript
// Number to string conversion
price_text = str.tostring(close, "#.##")
volume_text = str.tostring(volume, "#,###")

// String formatting
formatted_text = str.format("Price: {0}, Volume: {1}", close, volume)

// String operations
symbol_upper = str.upper(syminfo.ticker)
description_length = str.length(syminfo.description)

// Pattern matching
is_crypto = str.contains(str.upper(syminfo.type), "CRYPTO")
```

## Array Operations (array)

The `array` namespace provides dynamic array functionality.

### Purpose
Dynamic data structures for storing and manipulating collections of values.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Creation** | `new<type>()`, `from()`, `copy()` | Array creation and copying |
| **Size** | `size()`, `clear()` | Array size management |
| **Access** | `get()`, `set()`, `first()`, `last()` | Element access |
| **Modification** | `push()`, `pop()`, `shift()`, `unshift()`, `insert()`, `remove()` | Array modification |
| **Search** | `indexof()`, `lastindexof()`, `includes()` | Element searching |
| **Sorting** | `sort()`, `reverse()` | Array ordering |
| **Iteration** | `slice()`, `concat()`, `join()` | Array processing |
| **Statistics** | `sum()`, `avg()`, `min()`, `max()`, `stdev()`, `variance()` | Statistical operations |

### Usage Examples

```pinescript
// Array creation and management
var prices = array.new<float>()
var volumes = array.new<float>(10, 0.0)  // Pre-filled with 10 zeros

// Adding data
array.push(prices, close)
array.unshift(volumes, volume)

// Array operations
if array.size(prices) > 100
    array.shift(prices)  // Remove oldest element

// Statistical calculations
avg_price = array.avg(prices)
max_volume = array.max(volumes)

// Searching and sorting
price_index = array.indexof(prices, close)
array.sort(prices, order.ascending)
```

## Matrix Operations (matrix)

The `matrix` namespace provides 2D matrix functionality.

### Purpose
Two-dimensional data structures for complex mathematical operations and data organization.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Creation** | `new<type>()`, `copy()`, `from_columns()`, `from_rows()` | Matrix creation |
| **Dimensions** | `rows()`, `columns()`, `elements_count()` | Size information |
| **Access** | `get()`, `set()`, `row()`, `col()` | Element and row/column access |
| **Modification** | `add_row()`, `add_col()`, `remove_row()`, `remove_col()`, `swap_rows()`, `swap_columns()` | Structure modification |
| **Operations** | `mult()`, `add()`, `submatrix()`, `transpose()`, `determinant()`, `inv()` | Mathematical operations |
| **Statistics** | `sum()`, `avg()`, `min()`, `max()` | Statistical functions |
| **Conversion** | `to_string()` | String conversion |

### Usage Examples

```pinescript
// Matrix creation
var price_matrix = matrix.new<float>(5, 3, 0.0)  // 5 rows, 3 columns
var correlation_matrix = matrix.new<float>()

// Setting values
matrix.set(price_matrix, 0, 0, close)
matrix.set(price_matrix, 0, 1, high)
matrix.set(price_matrix, 0, 2, low)

// Matrix operations
matrix.add_row(price_matrix, 0, array.from(open, high, low))
transposed = matrix.transpose(matrix.copy(price_matrix))

// Statistics
matrix_avg = matrix.avg(price_matrix)
matrix_sum = matrix.sum(price_matrix)
```

## Map Operations (map)

The `map` namespace provides key-value pair functionality.

### Purpose
Associative arrays for storing data with string or other type keys.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Creation** | `new<key_type, value_type>()`, `copy()`, `from_str()` | Map creation |
| **Access** | `get()`, `put()`, `contains()` | Key-value operations |
| **Management** | `remove()`, `clear()`, `size()` | Map management |
| **Iteration** | `keys()`, `values()` | Key and value extraction |
| **Conversion** | `to_str()` | String conversion |

### Usage Examples

```pinescript
// Map creation
var symbol_data = map.new<string, float>()
var indicator_values = map.new<string, float>()

// Storing data
map.put(symbol_data, "price", close)
map.put(symbol_data, "volume", volume)
map.put(indicator_values, "RSI", ta.rsi(close, 14))
map.put(indicator_values, "SMA", ta.sma(close, 20))

// Retrieving data
current_rsi = map.get(indicator_values, "RSI")
has_volume = map.contains(symbol_data, "volume")

// Map operations
all_keys = map.keys(indicator_values)
map_size = map.size(symbol_data)
```

## Request Functions (request)

The `request` namespace handles external data requests.

### Purpose
Fetching data from different symbols, timeframes, and data sources.

### Key Functions

| Function | Purpose | Usage |
|----------|---------|-------|
| `security()` | Multi-timeframe and multi-symbol data | `request.security(symbol, timeframe, expression)` |
| `security_lower_tf()` | Lower timeframe data | `request.security_lower_tf(symbol, timeframe, expression)` |
| `dividends()` | Dividend data | `request.dividends(ticker, field, ignore_invalid_symbol)` |
| `splits()` | Stock split data | `request.splits(ticker, field, ignore_invalid_symbol)` |
| `earnings()` | Earnings data | `request.earnings(ticker, field, ignore_invalid_symbol)` |
| `economic()` | Economic data | `request.economic(country_code, field, ignore_invalid_symbol)` |
| `quandl()` | Quandl data (deprecated) | `request.quandl(ticker, gaps, index, ignore_invalid_symbol)` |

### Usage Examples

```pinescript
// Multi-timeframe analysis
daily_close = request.security(syminfo.tickerid, "1D", close)
weekly_volume = request.security(syminfo.tickerid, "1W", volume)

// Different symbol data
spy_close = request.security("SPY", timeframe.period, close)
btc_price = request.security("BINANCE:BTCUSDT", "1H", close)

// Lower timeframe data
lower_tf_data = request.security_lower_tf(syminfo.tickerid, "1m", [close, volume])

// Fundamental data
dividend_amount = request.dividends(syminfo.tickerid, dividends.gross, ignore_invalid_symbol=true)
earnings_actual = request.earnings(syminfo.tickerid, earnings.actual, ignore_invalid_symbol=true)
```

## Strategy Functions (strategy)

The `strategy` namespace provides strategy-specific functions (only available in strategy scripts).

### Purpose
Trade execution, position management, and strategy performance functions.

### Key Functions

| Category | Functions | Description |
|----------|-----------|-------------|
| **Orders** | `entry()`, `exit()`, `order()`, `cancel()`, `cancel_all()` | Order management |
| **Position** | `close()`, `close_all()` | Position closing |
| **Risk Management** | `risk.allow_entry_in()`, `risk.max_intraday_filled_orders()`, `risk.max_position_size()` | Risk controls |

### Usage Examples

```pinescript
// Strategy entries
if bullish_condition
    strategy.entry("Long", strategy.long, qty=100)

if bearish_condition
    strategy.entry("Short", strategy.short, qty=100)

// Strategy exits
strategy.exit("Long Exit", "Long", stop=stop_loss, limit=take_profit)

// Position management
if exit_condition
    strategy.close("Long")

// Risk management
strategy.risk.max_position_size(1000)
strategy.risk.allow_entry_in(strategy.direction.long)
```

## Input Functions (input)

The `input` namespace provides user input functionality.

### Purpose
Creating configurable parameters for scripts.

### Key Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `input.int()` | Integer input | `length = input.int(14, "Length", minval=1)` |
| `input.float()` | Float input | `factor = input.float(2.0, "Factor", step=0.1)` |
| `input.bool()` | Boolean input | `show_signals = input.bool(true, "Show Signals")` |
| `input.string()` | String input with options | `ma_type = input.string("SMA", "MA Type", options=["SMA", "EMA"])` |
| `input.source()` | Price source input | `src = input.source(close, "Source")` |
| `input.timeframe()` | Timeframe input | `tf = input.timeframe("1H", "Timeframe")` |
| `input.symbol()` | Symbol input | `symbol = input.symbol("SPY", "Symbol")` |
| `input.color()` | Color input | `line_color = input.color(color.blue, "Line Color")` |
| `input.time()` | Time input | `start_time = input.time(timestamp("01 Jan 2023"), "Start")` |

### Usage Examples

```pinescript
// Input declarations
length = input.int(14, "RSI Length", minval=1, maxval=100)
overbought = input.float(70.0, "Overbought Level", minval=50, maxval=100, step=0.5)
show_levels = input.bool(true, "Show Levels")
ma_source = input.source(close, "MA Source")
comparison_symbol = input.symbol("SPY", "Comparison Symbol")

// Using inputs
rsi_value = ta.rsi(ma_source, length)
is_overbought = rsi_value > overbought

// Conditional features
if show_levels
    hline(overbought, "Overbought", color=color.red)
    hline(30, "Oversold", color=color.green)
```

## Time Functions (time)

Time-related functions and constants.

### Purpose
Working with time, dates, and time zones.

### Key Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `timestamp()` | Create timestamp | `timestamp("2023-01-01 09:30")` |
| `time()` | Current bar time | `time(timeframe.period)` |
| `time_close()` | Bar close time | `time_close(timeframe.period)` |

### Usage Examples

```pinescript
// Time calculations
market_open = timestamp(year, month, dayofmonth, 9, 30)
is_market_hours = time >= market_open and time <= timestamp(year, month, dayofmonth, 16, 0)

// Time-based conditions
is_monday = dayofweek == dayofweek.monday
is_first_hour = hour == 9 and minute < 60
```

## Color Functions (color)

The `color` namespace provides color manipulation functions.

### Purpose
Creating and modifying colors for visual elements.

### Key Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `color.new()` | Create color with transparency | `color.new(color.red, 50)` |
| `color.rgb()` | Create RGB color | `color.rgb(255, 0, 0, 128)` |
| `color.from_gradient()` | Gradient between colors | `color.from_gradient(value, 0, 100, color.red, color.green)` |

### Usage Examples

```pinescript
// Color creation
transparent_red = color.new(color.red, 80)
custom_blue = color.rgb(0, 100, 255)

// Dynamic colors
dynamic_color = close > open ? color.green : color.red
gradient_color = color.from_gradient(ta.rsi(close, 14), 0, 100, color.red, color.green)
```

## Drawing Objects

Various namespaces for drawing objects on charts.

### Line Objects
- `line.new()`, `line.set_*()`, `line.get_*()`
- `polyline.new()`, `polyline.set_*()`, `polyline.get_*()`
- `linefill.new()`, `linefill.set_*()`, `linefill.get_*()`

### Shape Objects
- `label.new()`, `label.set_*()`, `label.get_*()`
- `box.new()`, `box.set_*()`, `box.get_*()`

### Table Objects
- `table.new()`, `table.cell()`, `table.set_*()`, `table.get_*()`

## Built-in Constants

Various constant namespaces for predefined values.

### Examples
- `color.*` (color.red, color.blue, etc.)
- `location.*` (location.top, location.bottom, etc.)
- `size.*` (size.small, size.large, etc.)
- `style.*` (style.solid, style.dashed, etc.)
- `barstate.*` (barstate.isconfirmed, barstate.islast, etc.)
- `syminfo.*` (syminfo.ticker, syminfo.type, etc.)

## Usage Examples

### Comprehensive Multi-Namespace Example

```pinescript
//@version=6
indicator("Multi-Namespace Example", overlay=true)

// Input namespace
length = input.int(20, "MA Length", minval=1)
source = input.source(close, "Source")
show_stats = input.bool(true, "Show Statistics")
line_color = input.color(color.blue, "Line Color")

// Technical analysis namespace
sma_value = ta.sma(source, length)
rsi_value = ta.rsi(source, 14)
atr_value = ta.atr(14)

// Mathematical namespace
price_change = math.abs(source - source[1])
normalized_rsi = math.round(rsi_value, 2)

// String namespace
stats_text = str.format("RSI: {0}, ATR: {1}", 
    str.tostring(normalized_rsi, "#.##"),
    str.tostring(atr_value, "#.####"))

// Array namespace for price tracking
var price_array = array.new<float>()
if barstate.isnew
    array.push(price_array, source)
    if array.size(price_array) > 50
        array.shift(price_array)

// Statistical calculations using array
if array.size(price_array) >= 10
    array_avg = array.avg(price_array)
    array_stdev = array.stdev(price_array)

// Map namespace for indicators
var indicator_map = map.new<string, float>()
map.put(indicator_map, "SMA", sma_value)
map.put(indicator_map, "RSI", rsi_value)
map.put(indicator_map, "ATR", atr_value)

// Request namespace for higher timeframe
daily_close = request.security(syminfo.tickerid, "1D", source)

// Color namespace
dynamic_color = color.from_gradient(rsi_value, 0, 100, color.red, color.green)
transparent_color = color.new(line_color, 70)

// Plotting with multiple namespaces
plot(sma_value, color=dynamic_color, title="SMA")
plot(daily_close, color=transparent_color, title="Daily Close")

// Labels with string formatting
if show_stats and barstate.islast
    label.new(bar_index, high, stats_text, 
        style=label.style_label_down, 
        color=color.white, 
        textcolor=color.black)
```

## Best Practices

1. **Namespace Usage**: Always use the appropriate namespace for functions
2. **Performance**: Be mindful of resource-intensive operations (arrays, matrices, requests)
3. **Error Handling**: Check for `na` values when using mathematical functions
4. **Memory Management**: Clean up large data structures when not needed
5. **Readability**: Use namespace prefixes for clarity

## Common Patterns

1. **Data Collection**: Use arrays/maps for collecting historical data
2. **Multi-timeframe Analysis**: Use request.security() for different timeframes
3. **Dynamic Visualization**: Combine color and math namespaces for dynamic colors
4. **User Customization**: Use input namespace extensively for user control
5. **Statistical Analysis**: Combine ta, math, and array namespaces for advanced analysis

## Related Documentation

- [Built-in Functions](../built-in-functions.md)
- [Language Reference](../language-reference.md)
- [Function Index](function-index.md)
- [Built-in Variables](built-in-variables.md)