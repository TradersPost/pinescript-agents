# Common Pine Script v6 Errors and Solutions

This guide covers the most frequently encountered errors in Pine Script v6 development, their causes, and detailed solutions with examples.

## Table of Contents
1. [Cannot Use Mutable Variable Errors](#cannot-use-mutable-variable-errors)
2. [Syntax Errors](#syntax-errors)
3. [Script Too Large Errors](#script-too-large-errors)
4. [Na Value Handling Errors](#na-value-handling-errors)
5. [Type Mismatch Errors](#type-mismatch-errors)
6. [Series vs Simple Context Errors](#series-vs-simple-context-errors)
7. [Lookahead and Repainting Errors](#lookahead-and-repainting-errors)

---

## Cannot Use Mutable Variable Errors

### Error Message
```
Cannot use mutable variable in this context
```

### Cause
Attempting to modify a variable declared with `var` or `varip` in contexts where Pine Script expects immutable values, such as in function parameters or certain built-in function arguments.

### Solution
Use regular variable assignment or create local copies of mutable variables.

### Example

**❌ Incorrect:**
```pinescript
//@version=6
indicator("Mutable Error", overlay=true)

var float myVar = 0.0

// This will cause an error
plot(myVar := close)  // Cannot modify var in plot context
```

**✅ Correct:**
```pinescript
//@version=6
indicator("Mutable Fixed", overlay=true)

var float myVar = 0.0
myVar := close  // Modify var first
plot(myVar)     // Then use it
```

---

## Syntax Errors

### Error Message
```
Syntax error at input 'token'
```

### Common Causes
1. Missing commas in function calls
2. Incorrect indentation
3. Missing parentheses
4. Incorrect operator usage
5. Reserved keyword misuse

### Solutions and Examples

#### Missing Commas
**❌ Incorrect:**
```pinescript
plot(close color=color.blue linewidth=2)
```

**✅ Correct:**
```pinescript
plot(close, color=color.blue, linewidth=2)
```

#### Incorrect Indentation
**❌ Incorrect:**
```pinescript
if close > open
plot(close, color=color.green)
```

**✅ Correct:**
```pinescript
if close > open
    plot(close, color=color.green)
```

#### Missing Parentheses
**❌ Incorrect:**
```pinescript
rsi_value = ta.rsi close, 14
```

**✅ Correct:**
```pinescript
rsi_value = ta.rsi(close, 14)
```

---

## Script Too Large Errors

### Error Message
```
Script is too large. The compiled script is limited to 500KB
```

### Causes
1. Too many variables or calculations
2. Large arrays or matrices
3. Excessive use of security() calls
4. Too many plot statements
5. Large string concatenations

### Solutions

#### Optimize Security Calls
**❌ Inefficient:**
```pinescript
htf1 = request.security(syminfo.tickerid, "1D", close)
htf2 = request.security(syminfo.tickerid, "1D", high)
htf3 = request.security(syminfo.tickerid, "1D", low)
```

**✅ Efficient:**
```pinescript
[htf_close, htf_high, htf_low] = request.security(syminfo.tickerid, "1D", [close, high, low])
```

#### Reduce Redundant Calculations
**❌ Inefficient:**
```pinescript
sma20 = ta.sma(close, 20)
sma20_shifted = ta.sma(close[1], 20)
sma20_high = ta.sma(high, 20)
```

**✅ Efficient:**
```pinescript
sma20 = ta.sma(close, 20)
sma20_shifted = sma20[1]
sma20_high = ta.sma(high, 20)
```

---

## Na Value Handling Errors

### Error Message
```
Cannot call 'function_name' with 'na' argument
```

### Cause
Passing `na` values to functions that don't accept them, or not properly handling `na` values in calculations.

### Solution
Always check for `na` values before using them in calculations.

### Example

**❌ Incorrect:**
```pinescript
//@version=6
indicator("Na Error", overlay=true)

rsi_val = ta.rsi(close, 14)
// Error: rsi_val might be na for first 13 bars
plot(rsi_val * 2)
```

**✅ Correct:**
```pinescript
//@version=6
indicator("Na Fixed", overlay=true)

rsi_val = ta.rsi(close, 14)
safe_rsi = na(rsi_val) ? 50 : rsi_val  // Provide default value
plot(safe_rsi * 2)

// Alternative approach
if not na(rsi_val)
    plot(rsi_val * 2)
```

---

## Type Mismatch Errors

### Error Message
```
Cannot call 'function_name' with argument 'arg_name'='value'. An argument of 'expected_type' type was used but a 'actual_type' is expected
```

### Cause
Passing wrong data types to functions or operators.

### Solution
Ensure correct type conversion or use appropriate functions.

### Example

**❌ Incorrect:**
```pinescript
//@version=6
indicator("Type Error", overlay=true)

// Trying to use series in simple context
length = input.int(14, "Length")
colors = array.new<color>(length)  // Error: length is series, need simple
```

**✅ Correct:**
```pinescript
//@version=6
indicator("Type Fixed", overlay=true)

// Use input.int which returns simple int
length = input.int(14, "Length")
var colors = array.new<color>(0)  // Initialize empty, resize later

if barstate.isfirst
    array.clear(colors)
    for i = 0 to length - 1
        array.push(colors, color.blue)
```

---

## Series vs Simple Context Errors

### Error Message
```
Cannot use series value in simple context
```

### Cause
Attempting to use series values (values that change bar by bar) in contexts that require simple values (constants).

### Solution
Use var declarations, input functions, or conditional logic to work with series data.

### Example

**❌ Incorrect:**
```pinescript
//@version=6
indicator("Series Error", overlay=true)

// close is series, cannot be used in array size
my_array = array.new<float>(int(close))  // Error
```

**✅ Correct:**
```pinescript
//@version=6
indicator("Series Fixed", overlay=true)

// Use var for dynamic array management
var my_array = array.new<float>(0)

if barstate.isfirst
    // Initialize with fixed size
    for i = 0 to 99
        array.push(my_array, 0.0)

// Or use input for user-defined size
array_size = input.int(50, "Array Size", minval=1, maxval=500)
var my_array2 = array.new<float>(array_size)
```

---

## Lookahead and Repainting Errors

### Error Message
```
The script is requesting future data
```

### Cause
1. Using `request.security()` without proper lookahead settings
2. Accessing future data in calculations
3. Incorrect historical reference usage

### Solution
Use proper lookahead settings and avoid future data access.

### Example

**❌ Repainting:**
```pinescript
//@version=6
indicator("Repainting Error", overlay=true)

// This repaints - gets future data
daily_close = request.security(syminfo.tickerid, "1D", close)
plot(daily_close)
```

**✅ Non-Repainting:**
```pinescript
//@version=6
indicator("Non-Repainting", overlay=true)

// Use lookahead.on to prevent repainting
daily_close = request.security(syminfo.tickerid, "1D", close, lookahead=barmerge.lookahead_on)

// Or use confirmed data
daily_close_confirmed = request.security(syminfo.tickerid, "1D", close[1])

plot(daily_close_confirmed, "Daily Close")
```

### Advanced Non-Repainting Pattern
```pinescript
//@version=6
indicator("Advanced Non-Repainting", overlay=true)

// Function to get confirmed higher timeframe data
get_htf_value(tf, src) =>
    request.security(syminfo.tickerid, tf, src[1], lookahead=barmerge.lookahead_off)

// Usage
daily_high = get_htf_value("1D", high)
weekly_close = get_htf_value("1W", close)

plot(daily_high, "Daily High", color=color.red)
plot(weekly_close, "Weekly Close", color=color.blue)
```

---

## Error Prevention Best Practices

### 1. Always Handle Na Values
```pinescript
safe_value = na(source) ? fallback_value : source
```

### 2. Use Proper Type Conversions
```pinescript
// Convert series to simple when needed
simple_length = input.int(14, "Length")
series_value = close
converted_value = int(series_value)  // Only in local scope
```

### 3. Validate Inputs
```pinescript
length = input.int(14, "Length", minval=1, maxval=500)
source = input.source(close, "Source")

// Additional validation
validated_length = math.max(1, math.min(500, length))
```

### 4. Use Debugging Functions
```pinescript
// Add debugging information
debug_table = table.new(position.top_right, 2, 10)
if barstate.islast
    table.cell(debug_table, 0, 0, "RSI", bgcolor=color.gray)
    table.cell(debug_table, 1, 0, str.tostring(ta.rsi(close, 14)))
```

### 5. Test Edge Cases
```pinescript
// Test with minimal data
if bar_index < 50
    // Handle early bars differently
    plot(na, "Not enough data")
else
    // Normal calculation
    plot(ta.sma(close, 50))
```

## Common Debugging Workflow

1. **Check for Na Values**: Use `na()` function to test values
2. **Verify Types**: Ensure correct data types are being used
3. **Test with Minimal Code**: Comment out sections to isolate issues
4. **Use Plot for Debugging**: Plot intermediate values to understand behavior
5. **Check Bar Index**: Ensure sufficient historical data exists
6. **Validate Inputs**: Test with different input parameters

This comprehensive error guide should help agents quickly identify and resolve common Pine Script v6 issues during development.