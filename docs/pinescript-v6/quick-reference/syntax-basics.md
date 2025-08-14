# Pine Script v6 Syntax Basics

## CRITICAL: Line Wrapping Rules

⚠️ **Pine Script has STRICT line continuation rules that MUST be followed:**

### ✅ CORRECT Line Wrapping:
```pine
// Continuation lines MUST be indented MORE than the first line
longCondition = ta.crossover(ema50, ema200) and 
     rsi < 30 and 
     volume > ta.sma(volume, 20)

// Function arguments - each line indented
plot(myValue,
     title="My Plot",
     color=color.blue,
     linewidth=2)

// Complex calculations
result = (high - low) / 2 + 
     (close - open) * 1.5 + 
     volume / 1000000
```

### ❌ INCORRECT (Causes "end of line without line continuation" error):
```pine
// WRONG - not indented
longCondition = ta.crossover(ema50, ema200) and
rsi < 30 and
volume > ta.sma(volume, 20)

// WRONG - same indentation level
plot(myValue,
title="My Plot",
color=color.blue)
```

### Key Rules:
1. **Always indent** continuation lines MORE than the first line (use spaces or tabs consistently)
2. **Break after** operators (and, or, +, -, *, /, etc.) or commas, NOT before
3. **No backslash** or special continuation character needed in Pine Script v6
4. **Consistent indentation** throughout the continuation
5. **Common places** needing line wrapping:
   - Long conditional statements
   - Function calls with many arguments
   - Complex mathematical expressions
   - Strategy/indicator declarations

## Version Declaration
Every Pine Script must start with a version declaration:
```pine
//@version=6
```

## Script Types

### Indicator
```pine
//@version=6
indicator("My Indicator", shorttitle="MI", overlay=true)
```

### Strategy
```pine
//@version=6
strategy("My Strategy", shorttitle="MS", overlay=true, default_qty_type=strategy.percent_of_equity, default_qty_value=10)
```

### Library
```pine
//@version=6
library("MyLibrary", overlay=true)
```

## Variable Declarations

### Simple Variables
```pine
// Regular variable (recalculates on each bar)
myVar = close > open

// Var (maintains state across bars, initializes once)
var float myPrice = 0.0

// Varip (maintains state across ticks within same bar)
varip int tickCount = 0
```

## Data Types

### Basic Types
- `int` - Integer numbers
- `float` - Floating point numbers
- `bool` - Boolean (true/false)
- `string` - Text strings
- `color` - Color values

### Series Types
- `series<type>` - Values that change over time
- `simple <type>` - Constant values
- `input <type>` - User input values

### Example Type Usage
```pine
// Simple types
simple int lookback = 14
simple string myTitle = "RSI"

// Series types
series float rsiValue = ta.rsi(close, 14)
series bool isOverbought = rsiValue > 70

// Input types
input.int length = input.int(14, "Period", minval=1)
input.color bullColor = input.color(color.green, "Bull Color")
```

## Operators

### Arithmetic
```pine
+   // Addition
-   // Subtraction
*   // Multiplication
/   // Division
%   // Modulo
```

### Comparison
```pine
==  // Equal to
!=  // Not equal to
>   // Greater than
<   // Less than
>=  // Greater than or equal
<=  // Less than or equal
```

### Logical
```pine
and  // Logical AND
or   // Logical OR
not  // Logical NOT
```

### Assignment
```pine
:=   // Reassignment operator
```

## Control Structures

### If Statement
```pine
if condition
    // code block
    result = value1
else if condition2
    result = value2
else
    result = value3
```

### Ternary Operator
```pine
result = condition ? value_if_true : value_if_false
```

### Switch Statement
```pine
result = switch
    condition1 => value1
    condition2 => value2
    => default_value  // Default case
```

### For Loop
```pine
sum = 0.0
for i = 0 to 9
    sum := sum + close[i]
```

### While Loop
```pine
i = 0
while i < 10
    // code block
    i := i + 1
```

## Functions

### Function Declaration
```pine
// Simple function
myFunction(x, y) =>
    result = x + y
    result

// Function with type specification
myTypedFunction(float x, int y) =>
    float result = x * y
    result

// Function with multiple return values
getHighLow() =>
    [high, low]
```

### Function Call
```pine
value = myFunction(10, 20)
[h, l] = getHighLow()
```

## Comments

### Single Line
```pine
// This is a single line comment
```

### Multi-line
```pine
/*
This is a multi-line comment
spanning multiple lines
*/
```

## Built-in Variables

### Price Data
```pine
open     // Open price of current bar
high     // High price of current bar
low      // Low price of current bar
close    // Close price of current bar
volume   // Volume of current bar
```

### Bar Information
```pine
bar_index    // Index of current bar (0-based)
time         // Timestamp of current bar
timenow      // Current timestamp
```

### Symbol Information
```pine
syminfo.ticker      // Symbol ticker
syminfo.currency    // Symbol currency
syminfo.type        // Symbol type
syminfo.timezone    // Symbol timezone
```

## Arrays, Matrices, and Maps

### Arrays
```pine
// Create array
myArray = array.new<float>(0)

// Add elements
array.push(myArray, close)

// Get elements
lastValue = array.get(myArray, array.size(myArray) - 1)
```

### Matrices
```pine
// Create matrix
myMatrix = matrix.new<float>(3, 3, 0.0)

// Set values
matrix.set(myMatrix, 0, 0, close)

// Get values
value = matrix.get(myMatrix, 0, 0)
```

### Maps
```pine
// Create map
myMap = map.new<string, float>()

// Set values
map.put(myMap, "rsi", ta.rsi(close, 14))

// Get values
rsiValue = map.get(myMap, "rsi")
```

## User Defined Types (UDT)

```pine
// Define type
type Point
    float x
    float y
    string label

// Create instance
myPoint = Point.new(10.0, 20.0, "Entry")

// Access fields
xValue = myPoint.x
yValue = myPoint.y
```

## Import/Export (Libraries)

### Export from Library
```pine
//@version=6
library("MyLib")

export myFunction(float x) =>
    x * 2
```

### Import in Script
```pine
//@version=6
import MyUsername/MyLib/1 as lib

value = lib.myFunction(close)
```

## Common Patterns

### Historical Reference
```pine
previousClose = close[1]     // Previous bar's close
closeFromTenBarsAgo = close[10]  // Close from 10 bars ago
```

### Conditional Assignment
```pine
var float lastHigh = na
if high > high[1]
    lastHigh := high
```

### Series Manipulation
```pine
// Calculate moving average manually
sum = 0.0
for i = 0 to 9
    sum := sum + close[i]
ma10 = sum / 10
```

## Error Handling

### NA Values
```pine
// Check for NA
if not na(close)
    // Process only when close is not NA
    value = close * 2

// Use na() function
safeValue = na(close) ? 0.0 : close
```

### Runtime Errors
```pine
// Avoid division by zero
divisor = volume == 0 ? 1 : volume
ratio = close / divisor
```

## Best Practices

1. **Always declare version**: Start with `//@version=6`
2. **Use appropriate variable types**: Choose between var, varip, and regular variables
3. **Handle NA values**: Check for NA before calculations
4. **Optimize performance**: Minimize calculations in loops
5. **Use meaningful names**: Make code self-documenting
6. **Comment complex logic**: Explain non-obvious calculations
7. **Test thoroughly**: Verify behavior in different market conditions