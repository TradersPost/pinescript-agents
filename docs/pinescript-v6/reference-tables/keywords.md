# Keywords Reference

This document provides a comprehensive reference for all keywords and reserved words in Pine Script v6.

## Table of Contents

- [Reserved Keywords](#reserved-keywords)
- [Type Keywords](#type-keywords)
- [Control Flow Keywords](#control-flow-keywords)
- [Function Keywords](#function-keywords)
- [Variable Qualifiers](#variable-qualifiers)
- [Special Keywords](#special-keywords)
- [Script Type Declarations](#script-type-declarations)
- [Import and Library Keywords](#import-and-library-keywords)
- [Usage Examples](#usage-examples)

## Reserved Keywords

Core language keywords that cannot be used as variable names or identifiers.

| Keyword | Category | Purpose | Example |
|---------|----------|---------|---------|
| `and` | Logical | Logical AND operator | `condition1 and condition2` |
| `or` | Logical | Logical OR operator | `condition1 or condition2` |
| `not` | Logical | Logical NOT operator | `not overbought` |
| `if` | Control Flow | Conditional execution | `if condition` |
| `else` | Control Flow | Alternative condition | `if condition ... else` |
| `for` | Control Flow | Loop iteration | `for i = 0 to 10` |
| `while` | Control Flow | Conditional loop | `while condition` |
| `break` | Control Flow | Exit loop | `break` |
| `continue` | Control Flow | Skip iteration | `continue` |
| `switch` | Control Flow | Multi-way branching | `switch expression` |
| `true` | Literal | Boolean true value | `bullish = true` |
| `false` | Literal | Boolean false value | `bearish = false` |
| `na` | Literal | Not-a-number value | `value = na` |
| `to` | Range | Range operator | `for i = 1 to 10` |
| `by` | Range | Step increment | `for i = 0 to 100 by 5` |
| `in` | Iteration | Collection iteration | `for item in array` |

## Type Keywords

Keywords that define data types in Pine Script.

| Keyword | Type | Description | Example |
|---------|------|-------------|---------|
| `int` | Primitive | Integer numbers | `int length = 14` |
| `float` | Primitive | Floating-point numbers | `float price = 100.5` |
| `bool` | Primitive | Boolean values | `bool condition = true` |
| `string` | Primitive | Text strings | `string message = "Hello"` |
| `color` | Primitive | Color values | `color bar_color = color.red` |
| `array` | Collection | Dynamic arrays | `array<float> prices = array.new<float>()` |
| `matrix` | Collection | 2D matrices | `matrix<float> data = matrix.new<float>(3, 3)` |
| `map` | Collection | Key-value pairs | `map<string, float> values = map.new<string, float>()` |
| `line` | Drawing | Line objects | `line trend_line = line.new(...)` |
| `label` | Drawing | Label objects | `label price_label = label.new(...)` |
| `box` | Drawing | Box objects | `box support_box = box.new(...)` |
| `table` | Drawing | Table objects | `table info_table = table.new(...)` |
| `polyline` | Drawing | Polyline objects | `polyline trend = polyline.new(...)` |
| `linefill` | Drawing | Line fill objects | `linefill area = linefill.new(...)` |

## Control Flow Keywords

Keywords used for controlling program execution flow.

### Conditional Keywords

| Keyword | Purpose | Syntax | Example |
|---------|---------|--------|---------|
| `if` | Start conditional block | `if condition` | `if close > open` |
| `else if` | Additional condition | `else if condition` | `else if close == open` |
| `else` | Default condition | `else` | `else` |
| `switch` | Multi-way branching | `switch expression` | `switch trend_direction` |
| `=>` | Case arrow | `value =>` | `1 => "Bullish"` |

### Loop Keywords

| Keyword | Purpose | Syntax | Example |
|---------|---------|--------|---------|
| `for` | Start loop | `for iterator in range/collection` | `for i = 1 to 10` |
| `while` | Conditional loop | `while condition` | `while price > support` |
| `to` | Range end | `from to end` | `for i = 1 to 100` |
| `by` | Step increment | `from to end by step` | `for i = 0 to 100 by 5` |
| `in` | Collection iteration | `for item in collection` | `for price in price_array` |
| `break` | Exit loop | `break` | `if condition break` |
| `continue` | Skip iteration | `continue` | `if condition continue` |

## Function Keywords

Keywords related to function definition and usage.

| Keyword | Purpose | Scope | Example |
|---------|---------|-------|---------|
| `export` | Export function from library | Library | `export method calculate(this) =>` |
| `method` | Define method function | Any | `method get_value(this int) =>` |
| `=>` | Function body separator | Function | `calculate(x) => x * 2` |

## Variable Qualifiers

Keywords that modify variable behavior and scope.

| Qualifier | Purpose | Behavior | Example |
|-----------|---------|----------|---------|
| `var` | Variable persistence | Initialized once, keeps value across bars | `var float total = 0.0` |
| `varip` | Intrabar persistence | Keeps value within the same bar on real-time | `varip int tick_count = 0` |
| `const` | Constant value | Compile-time constant, cannot change | `const int PERIOD = 20` |
| `simple` | Simple type | Cannot change during script execution | `simple int length = input.int(14)` |
| `series` | Series type | Can change on each bar | `series float price = close` |

### Variable Qualifier Details

#### `var` Qualifier
```pinescript
// Initialize once, persist across bars
var float running_sum = 0.0
var int bar_count = 0
var bool first_run = true

running_sum += close
bar_count += 1

if first_run
    // This block runs only on the first bar
    first_run := false
```

#### `varip` Qualifier
```pinescript
// Persists within the same bar (intrabar)
varip float intrabar_high = high
varip float intrabar_low = low
varip int tick_count = 0

// Update on each tick
if high > intrabar_high
    intrabar_high := high
if low < intrabar_low
    intrabar_low := low
tick_count += 1
```

#### `const` Qualifier
```pinescript
// Compile-time constants
const int DEFAULT_LENGTH = 14
const float GOLDEN_RATIO = 1.618
const string SCRIPT_NAME = "My Indicator"
const color BULL_COLOR = color.green

// Use in calculations
rsi_value = ta.rsi(close, DEFAULT_LENGTH)
```

#### Type Qualifiers
```pinescript
// Simple type - value known at compile time
simple int ma_length = input.int(20, "MA Length")
simple string ma_type = input.string("SMA", "MA Type", options=["SMA", "EMA"])

// Series type - value can change each bar
series float ma_value = ma_type == "SMA" ? ta.sma(close, ma_length) : ta.ema(close, ma_length)
```

## Special Keywords

Keywords with special meanings in specific contexts.

| Keyword | Context | Purpose | Example |
|---------|---------|---------|---------|
| `this` | Method functions | Reference to calling object | `method get_size(this array<float>) =>` |
| `runtime` | Error handling | Runtime error generation | `runtime.error("Invalid input")` |
| `math` | Mathematical | Access to math namespace | `math.abs(value)` |
| `str` | String operations | Access to string namespace | `str.tostring(close)` |
| `array` | Array operations | Access to array namespace | `array.size(my_array)` |
| `matrix` | Matrix operations | Access to matrix namespace | `matrix.rows(my_matrix)` |
| `map` | Map operations | Access to map namespace | `map.size(my_map)` |

## Script Type Declarations

Keywords that declare the type of Pine Script.

| Declaration | Purpose | Required Elements | Example |
|-------------|---------|-------------------|---------|
| `indicator()` | Create indicator | Title | `indicator("My RSI", overlay=false)` |
| `strategy()` | Create strategy | Title | `strategy("My Strategy", overlay=true)` |
| `library()` | Create library | Title | `library("MyLibrary")` |

### Script Declaration Examples

#### Indicator Declaration
```pinescript
//@version=6
indicator(
    title="Advanced RSI", 
    shorttitle="ARSI",
    overlay=false,
    timeframe="",
    timeframe_gaps=true,
    max_bars_back=500,
    max_lines_count=100,
    max_labels_count=100
)
```

#### Strategy Declaration
```pinescript
//@version=6
strategy(
    title="Trend Following Strategy",
    shorttitle="TFS",
    overlay=true,
    initial_capital=10000,
    default_qty_type=strategy.percent_of_equity,
    default_qty_value=10,
    pyramiding=1,
    calc_on_order_fills=false,
    calc_on_every_tick=false,
    close_entries_rule="FIFO"
)
```

#### Library Declaration
```pinescript
//@version=6
library("TechnicalAnalysisUtils", overlay=true)

export calculate_rsi(series float source, simple int length) =>
    // Library function implementation
    ta.rsi(source, length)
```

## Import and Library Keywords

Keywords for working with libraries and imports.

| Keyword | Purpose | Syntax | Example |
|---------|---------|--------|---------|
| `import` | Import library | `import username/library_name as alias` | `import TradingView/ta as ta` |
| `as` | Create alias | `import ... as alias` | `import MyLibrary/utils as utils` |
| `export` | Export from library | `export function_name(params) =>` | `export calculate(x) => x * 2` |

### Import Examples

```pinescript
//@version=6
indicator("Import Examples")

// Import built-in library with alias
import TradingView/ta as technical

// Import user library
import PineCoders/Utils as utils

// Import with version specification
import TradingView/ta/1 as ta_v1

// Use imported functions
rsi_value = technical.rsi(close, 14)
sma_value = technical.sma(close, 20)
```

## Usage Examples

### Complete Keyword Usage
```pinescript
//@version=6
indicator("Keyword Examples", overlay=false)

// Constants
const int RSI_LENGTH = 14
const int MA_LENGTH = 50
const float OVERSOLD = 30.0
const float OVERBOUGHT = 70.0

// Variable declarations with qualifiers
var float max_rsi = 0.0
var float min_rsi = 100.0
varip int signal_count = 0

// Simple inputs
simple int user_length = input.int(RSI_LENGTH, "RSI Length", minval=1)
simple bool show_signals = input.bool(true, "Show Signals")

// Series calculations
series float rsi = ta.rsi(close, user_length)
series float ma = ta.sma(close, MA_LENGTH)
series bool oversold_condition = rsi < OVERSOLD
series bool overbought_condition = rsi > OVERBOUGHT

// Control flow with keywords
if barstate.isnew and not na(rsi)
    // Update extremes
    if rsi > max_rsi
        max_rsi := rsi
    else if rsi < min_rsi
        min_rsi := rsi
        
// Loop example
if barstate.islast
    var array<float> rsi_values = array.new<float>()
    for i = 0 to 9
        historical_rsi = rsi[i]
        if not na(historical_rsi)
            array.push(rsi_values, historical_rsi)

// Switch statement
trend_status = switch
    close > ma and rsi > 50 => "Strong Bullish"
    close > ma and rsi <= 50 => "Weak Bullish"
    close < ma and rsi < 50 => "Strong Bearish"
    close < ma and rsi >= 50 => "Weak Bearish"
    => "Neutral"

// Method definition
method is_extreme(this float, float threshold_high, float threshold_low) =>
    this > threshold_high or this < threshold_low

// Logical operators
bullish_signal = close > open and volume > ta.sma(volume, 20) and not overbought_condition
bearish_signal = close < open and volume > ta.sma(volume, 20) and not oversold_condition

// Ternary with keywords
signal_color = bullish_signal ? color.green : bearish_signal ? color.red : color.gray

// Plot with keywords
plot(rsi, color=signal_color, title="RSI")
hline(OVERBOUGHT, "Overbought", color=color.red, linestyle=hline.style_dashed)
hline(OVERSOLD, "Oversold", color=color.green, linestyle=hline.style_dashed)

// Conditional plotting
plotchar(show_signals and oversold_condition, "Oversold", "▲", location.bottom, color.green)
plotchar(show_signals and overbought_condition, "Overbought", "▼", location.top, color.red)
```

### Library with Keywords
```pinescript
//@version=6
library("TradingIndicators")

// Export constants
export const int DEFAULT_RSI_LENGTH = 14
export const float DEFAULT_OVERBOUGHT = 70.0
export const float DEFAULT_OVERSOLD = 30.0

// Export method
export method calculate_enhanced_rsi(series float source, simple int length) =>
    rsi_value = ta.rsi(source, length)
    smoothed_rsi = ta.sma(rsi_value, 3)
    [rsi_value, smoothed_rsi]

// Export function with control flow
export trend_strength(series float price, simple int fast_length, simple int slow_length) =>
    fast_ma = ta.sma(price, fast_length)
    slow_ma = ta.sma(price, slow_length)
    
    strength = switch
        fast_ma > slow_ma and price > fast_ma => 3  // Strong bullish
        fast_ma > slow_ma and price < fast_ma => 2  // Weak bullish
        fast_ma < slow_ma and price < fast_ma => -3 // Strong bearish
        fast_ma < slow_ma and price > fast_ma => -2 // Weak bearish
        => 0  // Neutral
    
    strength
```

## Keyword Restrictions

### Cannot Be Used as Identifiers
- All reserved keywords cannot be used as variable names, function names, or other identifiers
- Type keywords cannot be redefined
- Built-in function names should not be overridden

### Context-Sensitive Keywords
Some keywords have different meanings in different contexts:
- `=>` can be used in switch statements, function definitions, and method definitions
- `this` is only valid in method contexts
- `export` is only valid in library scripts

## Best Practices

1. **Use Descriptive Names**: Avoid using keywords as part of longer identifiers
2. **Consistent Qualifier Usage**: Use appropriate qualifiers (`var`, `const`, etc.) consistently
3. **Control Flow Clarity**: Use proper indentation with control flow keywords
4. **Method Naming**: Follow conventions when using `method` keyword
5. **Library Organization**: Group related exports in libraries

## Common Mistakes

1. **Using Reserved Words**: Attempting to use keywords as variable names
2. **Incorrect Qualifiers**: Using wrong qualifiers for variable types
3. **Method Context**: Using `this` outside of method definitions
4. **Export Scope**: Using `export` in non-library scripts
5. **Switch Syntax**: Incorrect syntax in switch statements

## Related Documentation

- [Language Reference](../language-reference.md)
- [Built-in Variables](built-in-variables.md)
- [Operators Reference](operators.md)
- [Function Index](function-index.md)